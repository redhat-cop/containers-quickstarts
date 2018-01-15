# RabbitMQ Cluster in Openshift

This demonstration describes how to create a RabbitMQ cluster in Openshift.

![RabbitMQ](images/RabbitMQ-logo.svg "RabbitMQ")

## Requirements
1. This example is configured to use a `PersistentVolume` for storing cluster and message data. Thus it is a requirement that Openshift is configured to support [Persistent Volumes](https://docs.openshift.com/container-platform/latest/dev_guide/persistent_volumes.html) and that there are PVs with at least `ReadWriteOnce` (RWO) access available.

2. This example is also using the [OpenShift Applier](https://github.com/redhat-cop/casl-ansible/tree/master/roles/openshift-applier) to build and deploy RabbitMQ. As a result you'll need to have [ansible installed](http://docs.ansible.com/ansible/latest/intro_installation.html).

## Parameters
| NAME                         | DESCRIPTION                         | VALUE
| ---------------------------- | ----------------------------------- | ---------------------------------------------------- |
| APPLICATION_NAME             | The name for the application        | rabbitmq                                             |
| CONTEXT_DIR                  | Path within Git project to build    | rabbitmq                                             |
| ERLANG_VERSION               | Erlang version to use               | 20.1.1                                               |
| FROM_IMAGE                   | Docker image to build from          | rhel7:7.4                                            |
| RABBITMQ_AUTOCLUSTER_VERSION | RabbitMQ Autocluster version to use | 0.10.0                                               |
| RABBITMQ_VERSION             | RabbitMQ version to build           | 3.6.12                                               |
| SOURCE_REPOSITORY_REF        | Git branch/tag reference            | master                                               |
| SOURCE_REPOSITORY_URL        | Git source URI for application      | https://github.com/redhat-cop/containers-quickstarts |

`ERLANG_VERSION`, `RABBITMQ_VERSION` & `RABBITMQ_AUTOCLUSTER_VERSION` are passed on to the buildconfig thus these versions can be controlled in the build.
This is the equivivalent of `docker build --build-arg ERLANG_VERSION=19.3.6` to a docker build.

## Start build and deploy
1. Clone this repository:
   `git clone https://github.com/redhat-cop/containers-quickstarts`
2. Clone casl-ansible:
   `git clone https://github.com/redhat-cop/casl-ansible`
3. `cd containers-quickstarts/rabbitmq`
4. Run openshift-applier: `ansible-playbook -i inventory/hosts ../casl-ansible/playbooks/openshift-cluster-seed.yml --connection=local`

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
$ oc rsh -n rabbitmq rabbitmq-1 rabbitmqctl cluster_status
Cluster status of node 'rabbit@172.17.0.3'
[{nodes,[{disc,['rabbit@172.17.0.2','rabbit@172.17.0.3',
                'rabbit@172.17.0.4']}]},
 {running_nodes,['rabbit@172.17.0.4','rabbit@172.17.0.2','rabbit@172.17.0.3']},
 {cluster_name,<<"rabbit@rabbitmq-1.rabbitmq.rabbitmq.svc.cluster.local">>},
 {partitions,[]},
 {alarms,[{'rabbit@172.17.0.4',[]},
          {'rabbit@172.17.0.2',[]},
          {'rabbit@172.17.0.3',[]}]}]
```

## Tear everything down
`oc delete project rabbitmq`
