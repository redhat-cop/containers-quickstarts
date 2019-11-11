# Deploying Openshift v4.X Cluster-Logging Stack

## Overview

This quickstart helps you deploy the cluster-logging stack for Openshift 4.X. This is not deployed by default and is accomplished through the subscribing to 2 operators via OperatorHub and then creating the appropriate custom resource.

This example deploys a 1 Elasticsearch and 1 Kibana EFK stack. This can be modified by updating the `ELASTICSEARCH_NODE_COUNT` and `KIBANA_NODE_COUNT` parameters in the [Cluster Logging Params](.openshift/params/cluster-logging.params).

🚨If deploying a multi-node Elasticsearch cluster, make sure to also update the `ELASTICSEARCH_REDUNDANCY_POLICY` parameter to SingleRedundancy🚨

If you're interested in the other parameters for this logging stack, you can see them [here](.openshift/templates/README.md)

## OCP Objects

This quickstart will create the following:

- A namespace called `openshift-logging` with the appropriate labels
- One [OperatorGroup](https://docs.openshift.com/container-platform/4.1/applications/operators/olm-understanding-olm.html#olm-operatorgroups_olm-understanding-olm): `openshift-logging-operatorgroup`
- Two [CatalogSourceConfig](https://docs.openshift.com/container-platform/4.1/applications/operators/olm-understanding-operatorhub.html#olm-operatorhub-arch-catalogsourceconfig_olm-understanding-operatorhub) objects created in the `openshift-marketplace` project: `elasticsearch-operator` and `cluster-logging-operator`
- Two `Subscription` objects: `cluster-logging` in the `openshift-logging` project and `elasticsearch-operator` in the `openshift-operators` project
- One [ClusterLogging](https://docs.openshift.com/container-platform/4.1/logging/efk-logging-deploying.html#additional-resources) custom resource named `instance` in the `openshift-logging` project

## Prerequisites

- Openshift 4.X cluster
- The appropriate permissions to deploy/create these projects
- Openshift-Applier v2.1.2 or higher (this is accomplished via the ansible-galaxy step below)

## Deployment

1. ansible-galaxy install -r requirements.yml -p galaxy
1. ansible-playbook -i .applier roles/openshift-applier/playbooks/openshift-cluster-seed.yml -e 'exclude_tags=cluster-logging-cr'
1. ansible-playbook -i .applier roles/openshift-applier/playbooks/openshift-cluster-seed.yml -e 'include_tags=cluster-logging-cr'

This deployment needs to be run in two stages due to the fact that the `ClusterLogging` CustomResourceDefinition needs to exist prior to trying to deploy this CustomResource. The second step will deploy all components and operators from OperatorHub. The third step will then ensure that the cluster-logging stack is then deployed (which includes ElasticSearch, Kibana and Fluentd).

🚨 In between Step 2 and 3, you should verify that the appropriate operators are up and running before trying to deploy the `ClusterLogging` custom resource. You can do this by running `oc get pods` in both the `openshift-operators` and `openshift-logging` projects 🚨

