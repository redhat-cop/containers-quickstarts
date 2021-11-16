# RabbitMQ Cluster in Openshift

This demonstration describes how to create a RabbitMQ cluster in Openshift.

![RabbitMQ](images/RabbitMQ-logo.svg "RabbitMQ")

## Requirements
1. OpenShift Container Platform v3.6 or newer (we're using [this feature](https://docs.openshift.com/container-platform/3.6/dev_guide/managing_images.html#using-is-with-k8s)).
2. This example is configured to use a `PersistentVolume` for storing cluster and message data. Thus it is a requirement that Openshift is configured to support [Persistent Volumes](https://docs.openshift.com/container-platform/3.11/dev_guide/persistent_volumes.html) and that there are PVs with at least `ReadWriteOnce` (RWO) access available.

3. This example is also using the [OpenShift Applier](https://github.com/redhat-cop/openshift-applier) to build and deploy RabbitMQ. As a result you'll need to have [ansible installed](http://docs.ansible.com/ansible/latest/intro_installation.html).

## OpenShift objects
The openshift-applier will create the following OpenShift objects:
* A Project named `rabbitmq` 
* Two ImageStreams `rabbitmq` and `ubi` (see [.openshift/templates/builds/template.yml](.openshift/templates/builds/template.yml) and [.openshift/templates/imagestreams/images.yml](.openshift/templates/imagestreams/images.yml))
* A BuildConfig named `rabbitmq` (see [.openshift/templates/builds/template.yml](.openshift/templates/builds/template.yml))
* A RoleBinding named `rabbitmq` (see [.openshift/templates/deployments/template.yml](.openshift/templates/deployments/template.yml))
* A Service named `rabbitmq` (see [.openshift/templates/deployments/template.yml](.openshift/templates/deployments/template.yml))
* A ConfigMap named `rabbitmq-config`(see [.openshift/templates/configmaps/config.yml](.openshift/templates/configmaps/config.yml))
* A StatefulSet named `rabbitmq` (see [.openshift/templates/deployments/template.yml](.openshift/templates/deployments/template.yml))

## Parameters
| NAME                         | DESCRIPTION                         | VALUE
| ---------------------------- | ----------------------------------- | ---------------------------------------------------- |
| APPLICATION_NAME             | The name for the application        | rabbitmq                                             |
| CONTEXT_DIR                  | Path within Git project to build    | rabbitmq                                             |
| ERLANG_VERSION               | Erlang version to use               | 22.1.4                                               |
| FROM_IMAGE                   | Docker image to build from          | ubi:7.7                                            |
| RABBITMQ_VERSION             | RabbitMQ version to build           | 3.8.0                                                |
| SOURCE_REPOSITORY_REF        | Git branch/tag reference            | master                                               |
| SOURCE_REPOSITORY_URL        | Git source URI for application      | https://github.com/redhat-cop/containers-quickstarts |

`ERLANG_VERSION`& `RABBITMQ_VERSION` are passed on to the buildconfig thus these versions can be controlled in the build.
This is the equivivalent of docker build --build-arg ERLANG_VERSION=19.3.6` to a docker build.

## Deploying

### Helm chart
1. Clone this repository:
   `git clone https://github.com/redhat-cop/containers-quickstarts`
2. `cd containers-quickstarts/rabbitmq`
3. `oc new-project rabbitmq`
4. `helm install rabbitmq chart`

**_NOTE:_** This image is currently not compatible with https://github.com/bitnami/charts/tree/master/bitnami/rabbitmq but this might change in the future.

### Build and deploy using Openshift Applier
1. Clone this repository:
   `git clone https://github.com/redhat-cop/containers-quickstarts`
2. `cd containers-quickstarts/rabbitmq`
3. Run `ansible-galaxy install -r requirements.yml --roles-path=roles`
4. Login to Openshift: `oc login -u <username> https://master.example.com:8443`
5. Run openshift-applier: `ansible-playbook -i .applier/ roles/openshift-applier/playbooks/openshift-cluster-seed.yml`

## Verify your pods are running
```
$ oc get pod -n rabbitmq
NAME               READY     STATUS      RESTARTS   AGE
rabbitmq-0         1/1       Running     0          1m
rabbitmq-1         1/1       Running     0          1m
rabbitmq-1-build   0/1       Completed   0          1m
rabbitmq-2         1/1       Running     0          1m
```

## Verify your RabbitMQ Cluster
```
$ oc rsh rabbitmq-1 rabbitmqctl cluster_status --formatter json | tail -1 | jq '{"alarms": .alarms,"running_nodes": .running_nodes,"versions": .versions}'
{
  "alarms": [],
  "running_nodes": [
    "rabbit@rabbitmq-2.rabbitmq.rabbitmq.svc.cluster.local",
    "rabbit@rabbitmq-0.rabbitmq.rabbitmq.svc.cluster.local",
    "rabbit@rabbitmq-1.rabbitmq.rabbitmq.svc.cluster.local"
  ],
  "versions": {
    "rabbit@rabbitmq-0.rabbitmq.rabbitmq.svc.cluster.local": {
      "erlang_version": "22.1.4",
      "rabbitmq_version": "3.8.0"
    },
    "rabbit@rabbitmq-1.rabbitmq.rabbitmq.svc.cluster.local": {
      "erlang_version": "22.1.4",
      "rabbitmq_version": "3.8.0"
    },
    "rabbit@rabbitmq-2.rabbitmq.rabbitmq.svc.cluster.local": {
      "erlang_version": "22.1.4",
      "rabbitmq_version": "3.8.0"
    }
  }
}
```

## Testing
This quickstart is using [bats](https://github.com/bats-core/bats-core) for unit and acceptance testing of the included Helm chart.

### Unit testing
The unit tests will test features of the Helm chart and also requires [yq](https://github.com/mikefarah/yq).
```
bats test/unit
 ✓ configmap: three config files defined
 ✓ rolebinding: default serviceaccount
 ✓ rolebinding: custom serviceaccount
 ✓ service: enabled by default
 ✓ service: name match release name
...
 ✓ statefulset: default tolerations
 ✓ statefulset: custom tolerations

41 tests, 0 failures
```

### Acceptance testing
The acceptance tests will deploy the RabbitMQ cluster using the Helm chart and assumes you have access to an OpenShift cluster (v3.11+) with at least self-provisioner access (it will create a new namespace).
You will also need to install [jq](https://github.com/stedolan/jq) and at the moment you will need to use Bats from the master branch as the test require features added after the latest Bats' release.
```
bats test/acceptance
 ✓ rabbitmq/ha: should have 'hostname' package installed
 ✓ rabbitmq/ha: should have $LANG set to 'en_US.UTF-8'
 ✓ rabbitmq/ha: should not have any alarms
 ✓ rabbitmq/ha: fail if number of replicas aren't ready
 ✓ rabbitmq/ha: should run on different cluster nodes
 ✓ rabbitmq/ha: should have a three node cluster

6 tests, 0 failures
```

## Tear everything down
`helm uninstall rabbitmq`
or
`oc delete project rabbitmq`
