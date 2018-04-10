Apache Kafka - Deprecated
============

## This quickstart is now deprecated. Please refer to the [Strimzi](http://strimzi.io) project for deployment of Kafka on OpenShift


Deployment of [Apache Kafka](https://kafka.apache.org/) on the OpenShift Container Platform

## Overview

Kafka is a distributed publish-subscribe messaging system that is designed to be fast, scalable, and durable.

It makes use of the following technologies:

* [StatefulSets](http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/)
* [Headless Services](http://kubernetes.io/docs/user-guide/services/#headless-services)
* [Openshift Applier](https://github.com/redhat-cop/openshift-applier)

### OpenShift objects
The openshift-applier will create the following OpenShift objects:
* A Project named `kafka` (see [files/projects/projects.yml](files/projects/projects.yml))
* Three ImageStreams `kafka`, `zookeeper` and `rhel` (see [files/builds/template.yml](files/builds/template.yml), [../zookeeper/files/builds/template.yml](../zookeeper/files/builds/template.yml) and [files/imagestreams/images.yml](files/imagestreams/images.yml))
* Two BuildConfigs named `kafka` and `zookeeper` (see [files/builds/template.yml](files/builds/template.yml) and [../zookeeper/files/builds/template.yml](../zookeeper/files/builds/template.yml))
* Four Services named `kafka`, `kafka-headless`, `zookeeper` and `zookeeper-headless` (see [files/deployments/template.yml](files/deployments/template.yml) and [../zookeeper/files/deployments/template.yml](../zookeeper/files/deployments/template.yml))
* Two StatefulSets named `kafka` and `zookeeper` (see [files/deployments/template.yml](files/deployments/template.yml) and [../zookeeper/files/deployments/template.yml](../zookeeper/files/deployments/template.yml))

>**NOTE:** This requires permission to create new projects and that the `kafka` project doesn't already exist

## Prerequisites

The following prerequisites must be met prior to beginning to build and deploy Kafka

* 6 [Persistent Volumes](https://docs.openshift.com/container-platform/latest/architecture/additional_concepts/storage.html). 3 for Kafka and 3 for Zookeeper ([see below](#verify-storage)) or a cluster that supports [dynamic provisioning with a default StorageClass](https://docs.openshift.com/container-platform/latest/install_config/storage_examples/storage_classes_dynamic_provisioning.html)
* OpenShift Command Line Tool
* Zookeeper ([see below](#zookeeper))
* [Openshift Applier](https://github.com/redhat-cop/openshift-applier) to build and deploy Kafka. As a result you'll need to have [ansible installed](http://docs.ansible.com/ansible/latest/intro_installation.html)

## Zookeeper

Apache Zookeeper is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services. Kafka uses it for configuration management, coordination between distributed instances and a registry. It must be deployed and operational prior to the deployment of Kafka.

The Openshift Applier will take care of building and deploying Zookeeper as part of building and deploying Kafka.

A full example of how to build, deploy and validate a Zookeeper deployment is also [available](../zookeeper/). Follow these steps to create a new project and deploy Zookeeper.

## Build and Deployment

1. Clone this repository: `git clone https://github.com/redhat-cop/containers-quickstarts`
2. `cd containers-quickstarts/kafka`
3. Run `ansible-galaxy install -r requirements.yml --roles-path=roles`
4. Login to OpenShift: `oc login -u <username> https://master.example.com:8443`
5. Run openshift-applier: `ansible-playbook -i inventory/hosts roles/openshift-applier/playbooks/openshift-cluster-seed.yml`

A new image build will be kicked off automatically. It can be tracked by running `oc logs -f builds/kafka-1`

>**NOTE:** Due to Kafka's dependency on Zookeeper, kafka deployment errors might be observed until the zookeeper pods are up and running. This is normal and the deployment will retry any failed pods.

## Verify Storage

One of the benefits of a StatefulSet is the ability for each deployed instance to have its own backing storage. To verify storage was bound successfully, run `oc get pvc -l=application=kafka`. A result similar to the following should be displayed:

```
NAME                  STATUS    VOLUME    CAPACITY   ACCESSMODES   AGE
datadir-kafka-0   Bound     pv01      1Gi        RWO,RWX       49m
datadir-kafka-1   Bound     pv02      2Gi        RWO,RWX       49m
datadir-kafka-2   Bound     pv03      3Gi        RWO,RWX       49m
```
>**NOTE:** Volume names, access modes and capacities are dependent on the persistent storage deployed in the environment.

Next, validate StatefulSet members are running and ready by executing `oc get pods -l=application=kafka`.  If three pods have a status of *RUNNING*, the containers have a status of *1/1*, and have a restart count of *0*, then kafka is deployed successfully. A successful deployment is shown below:

```
NAME          READY     STATUS    RESTARTS   AGE
kafka-0   1/1       Running   0          1h
kafka-1   1/1       Running   0          1h
kafka-2   1/1       Running   0          1h
```

## Verify the Deployment

To validate the configuration of the kafka cluster, create a topic and validate that messages can be sent and retrieved between two separate instances

### Create a Topic

Remote shell into one of the kafka instances

```
oc rsh kafka-0
```

Create a topic called foo (see Kafka [Topics and Logs](http://kafka.apache.org/documentation/#intro_topics) for different partition and replication options)

```
/opt/kafka/bin/kafka-topics.sh --zookeeper zookeeper:2181 --topic foo --create --partitions 3 --replication-factor 2
```

Verify the topic was created by listing all topics

```
/opt/kafka/bin/kafka-topics.sh --zookeeper zookeeper:2181 --list
```

The topic `foo` should be returned

### Publish and Consume Messages

To verify the stability of communications transport within Kafka, publish messages to the previously created *foo* topic and consume the messages on another instance.

Remote shell into instance *kafka-1* which will be used to consume messages from the *foo* topic

```
oc rsh kafka-1
```

Start consuming messages

```
/opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic foo
```

Open up another terminal and remote shell into the*kafka-0* instance

```
oc rsh kafka-0
```

Use the *kafka-console-producer* tool to begin sending messages

```
/opt/kafka/bin/kafka-console-producer.sh --broker-list kafka:9092 --topic foo
```

Start sending messages by entering a message and then hitting *Enter*

Verify messages that are sent on the producing side is received in the other terminal on the consuming side

*Producer*
*
```
sh-4.2# /opt/kafka/bin/kafka-console-producer.sh --broker-list kafka:9092 --topic foo
testing
openshift
kafka
```

*Consumer*

```
sh-4.2# /opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic foo --from-beginning
testing
openshift
kafka
```

Type CTRL+C to close out of either publisher or consumer commands. If the same command for the consumer is used once again, the same list of responses that were sent by the publisher are returned.

## Cleaning up
```
oc delete project kafka
```
