#!/usr/bin/env python

import kopf
import kubernetes
import os
import json
import subprocess
import yaml

operator_domain = os.environ.get('OPERATOR_DOMAIN', 'app.example.com')
config_map_label = operator_domain + '/config'
app_name_label = operator_domain + '/name'

if os.path.exists('/var/run/secrets/kubernetes.io/serviceaccount/namespace'):
    kubernetes.config.load_incluster_config()
    namespace = open("/var/run/secrets/kubernetes.io/serviceaccount/namespace").read()
else:
    kubernetes.config.load_kube_config()
    namespace = kubernetes.config.list_kube_config_contexts()[1]['context']['namespace']

core_v1_api = kubernetes.client.CoreV1Api()
custom_objects_api = kubernetes.client.CustomObjectsApi()

def owner_reference_from_resource(resource):
    return dict(
        apiVersion = resource['apiVersion'],
        controller = True,
        blockOwnerDeletion = False,
        kind = resource['kind'],
        name = resource['metadata']['name'],
        uid = resource['metadata']['uid']
    )

def process_template(owner_reference, template_name, template_namespace, template_parameters):
    '''
    Use `oc` to process template and produce resource list json.
    '''
    oc_process_cmd = [
        'oc', 'process', template_namespace + '//' + template_name,
        '-l', '{0}={1}'.format(app_name_label, owner_reference['name']),
        '-o', 'json',
    ]
    for k, v in template_parameters.items():
        oc_process_cmd.extend(['-p', '{0}={1}'.format(k, v)])
    oc_process_result = subprocess.run(oc_process_cmd, stdout=subprocess.PIPE, check=True)
    resource_list = json.loads(oc_process_result.stdout)
    add_owner_reference(resource_list, owner_reference)
    return resource_list

def add_owner_reference(resource_list, owner_reference):
    '''
    Add owner references to resource definition metadata.
    '''
    for item in resource_list['items']:
        metadata = item['metadata']
        if 'ownerReferences' in metadata:
            if owner_reference not in metadata['ownerReferences']:
                metadata['ownerReferences'].append(owner_reference)
        else:
            metadata['ownerReferences'] = [owner_reference]

def sanity_check_config_map(config_map):
    metadata = config_map['metadata']
    name = metadata['name']
    if not 'data' in config_map or 'config' not in config_map['data']:
        raise kopf.PermanentError('Config map must include config data')

def deploy_app_from_config_map(config_map, logger):
    '''
    Deploy application based on config map
    '''
    sanity_check_config_map(config_map)
    name = config_map['metadata']['name']
    try:
        config = yaml.safe_load(config_map['data']['config'])
    except yaml.parser.ParserError as e:
        raise kopf.PermanentError('Unable to load config YAML: {0}'.format(str(e)))
    owner_reference = owner_reference_from_resource(config_map)
    deploy_app(owner_reference, config, logger)

def deploy_app(owner_reference, config, logger):
    logger.info("Deploying app '%s'", owner_reference['name'])
    if 'template' in config:
        template_name = config['template'].get('name')
        template_namespace = config['template'].get('namespace', namespace)
        template_parameters = config['template'].get('parameters', {})
        logger.info("Processing resources from template %s//%s", template_namespace, template_name)
        resource_list = process_template(owner_reference, template_name, template_namespace, template_parameters)
        oc_apply_result = subprocess.run(
            ['oc', 'apply', '-f', '-'],
            check=True,
            input=json.dumps(resource_list).encode('utf-8'),
            stdout=subprocess.PIPE,
        )
        for line in oc_apply_result.stdout.decode('utf-8').splitlines():
            logger.info(line)

@kopf.on.startup()
def configure(settings: kopf.OperatorSettings, **_):
    # Disable scanning for CustomResourceDefinitions
    settings.scanning.disabled = True

@kopf.on.create('', 'v1', 'configmaps', labels={config_map_label: kopf.PRESENT})
def on_create_config_map(body, logger, **_):
    logger.info("New app ConfigMap '%s'", body['metadata']['name'])
    deploy_app_from_config_map(body, logger)
