#!/usr/bin/env python

import kopf
import kubernetes_asyncio
import os
import random
import string
import yaml

operator_domain = os.environ.get('OPERATOR_DOMAIN', 'kopf-simple.example.com')
config_map_label = operator_domain + '/config'

if os.path.exists('/var/run/secrets/kubernetes.io/serviceaccount'):
    kubernetes_asyncio.config.load_incluster_config()
else:
    kubernetes_asyncio.config.load_kube_config()

core_v1_api = kubernetes_asyncio.client.CoreV1Api()

def random_string(length=8, character_set=''):
    '''
    Return a random string of specified length and character set.
    '''
    if character_set == '':
        character_set = string.ascii_lowercase + string.digits
    return ''.join(random.choice(character_set) for i in range(length))

def owner_reference_from_resource(resource):
    return kubernetes_asyncio.client.V1OwnerReference(
        api_version = resource['apiVersion'],
        controller = True,
        block_owner_deletion = False,
        kind = resource['kind'],
        name = resource['metadata']['name'],
        uid = resource['metadata']['uid']
    )

def load_config_map(config_map):
    metadata = config_map['metadata']
    name = metadata['name']
    if not 'data' in config_map \
    or 'config' not in config_map['data']:
        raise kopf.PermanentError('Config map must include config data')
    try:
        config = yaml.safe_load(config_map['data']['config'])
    except yaml.parser.ParserError as e:
        raise kopf.PermanentError('Unable to load config YAML: {0}'.format(str(e)))
    if not 'secretNames' in config:
        raise kopf.PermanentError('Config data must include secretNames')
    if not isinstance(config['secretNames'], list):
        raise kopf.PermanentError('Config data secretNames must be a list')
    return config

async def get_secret(name, namespace):
    '''
    Read namespaced secret, return None if not found.
    '''
    try:
        return await core_v1_api.read_namespaced_secret(name, namespace)
    except kubernetes_asyncio.client.rest.ApiException as e:
        if e.status == 404:
            return None
        raise

async def update_config_map_status(name, namespace, config_map, secret):
    '''
    Update status into ConfigMap data
    '''
    await core_v1_api.patch_namespaced_config_map(name, namespace, dict(
        data = dict(
            status = yaml.safe_dump(dict(
                secret = dict(
                    apiVersion = secret.api_version,
                    kind = secret.kind,
                    name = secret.metadata.name,
                    namespace = secret.metadata.namespace,
                    resourceVersion = secret.metadata.resource_version,
                    uid = secret.metadata.uid
                )
            ), default_flow_style=False)
        )
    ))

async def create_secret(config, name, namespace, owner_reference, logger):
    secret_data = dict()

    for secret_name in config['secretNames']:
        secret_data[secret_name] = random_string()

    secret = await core_v1_api.create_namespaced_secret(
        namespace,
        kubernetes_asyncio.client.V1Secret(
            metadata = kubernetes_asyncio.client.V1ObjectMeta(
                name = name,
                owner_references = [owner_reference]
            ),
            string_data = secret_data
        )
    )
    logger.info('Created secret %s', secret.metadata.name)
    return secret

async def manage_secret_values(config, secret, logger):
    '''
    Add any required values to secret.
    '''
    new_secret_data = dict()
    for secret_name in config['secretNames']:
        if secret_name not in secret.data:
           new_secret_data[secret_name] = random_string()
    if new_secret_data:
        secret.string_data = new_secret_data
        secret = await core_v1_api.replace_namespaced_secret(secret.metadata.name, secret.metadata.namespace, secret)
        logger.info('Updated secret %s', secret.metadata.name)
    else:
        logger.debug('No change for secret %s', secret.metadata.name)
    return secret

async def manage_secret_for_config_map(name, namespace, config_map, logger):
    '''
    Create secrets based on config_map.
    '''
    config = load_config_map(config_map)
    owner_reference = owner_reference_from_resource(config_map)
    secret = await get_secret(name, namespace)
    if secret:
        if not secret.metadata.owner_references \
        or not secret.metadata.owner_references[0] == owner_reference:
            raise kopf.TemporaryError('Unable to manage secret, not the owner!')
        secret = await manage_secret_values(config, secret, logger)
    else:
        secret = await create_secret(config, name, namespace, owner_reference, logger)
    await update_config_map_status(name, namespace, config_map, secret)

@kopf.on.startup()
def configure(settings: kopf.OperatorSettings, **_):
    # Disable scanning for Namespaces and CustomResourceDefinitions
    settings.scanning.disabled = True

@kopf.on.create('', 'v1', 'configmaps', labels={config_map_label: kopf.PRESENT})
async def on_create_config_map(body, name, namespace, logger, **_):
    logger.info("New app ConfigMap '%s'", name)
    await manage_secret_for_config_map(name, namespace, body, logger)

@kopf.on.update('', 'v1', 'configmaps', labels={config_map_label: kopf.PRESENT})
async def on_create_config_map(body, name, namespace, logger, **_):
    logger.info("New app ConfigMap '%s'", name)
    await manage_secret_for_config_map(name, namespace, body, logger)
