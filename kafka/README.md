Apache Kafka
============

Deployment of [Apache Kafka](https://kafka.apache.org/) on the OpenShift Container Platform

## Overview

Kafka is a distributed publish-subscribe messaging system that is designed to be fast, scalable, and durable.

It makes use of the following technologies:

* [PetSets](http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/) (StatefulSets)
* [Headless Services](http://kubernetes.io/docs/user-guide/services/#headless-services)

## Prerequisites

The following prerequisites must be met prior to beginning to build and deploy Zookeeper

* 6 [Persistent Volumes](https://docs.openshift.com/container-platform/3.3/architecture/additional_concepts/storage.html#architecture-additional-concepts-storage). 3 for Kafka and 3 for Zookeeper (see below)
* OpenShift Command Line Tool
* Zookeeper

## Zookeeper

Apache Zookeeper is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services. Kafka uses it for configuration management, coordination between distributed instances and a registry. It must be deployed and operational prior to the deployment of Kafka. 

A full example of how to build, deploy and validate a Zookeeper deployment can be found [here](../zookeeper/README.md). Follow these steps to create a new project and deploy Zookeeper.

## Build and Deployment

A set of templates are available to streamline the build and deployment of Kafka and are found in the [templates](templates) directory.

Instantiate the template to create a Build Configuration to produce a docker image

```
oc process -f templates/kafka-build.json | oc create -f-
```

A new image build will be kicked off automatically. It can be tracked by running `oc logs -f builds/kafka-1`

Once the build completes successfully, the newly created image can be deployed to OpenShift.

PetSets provide a way to effectively deploy stateful applications. However, it does not currently have the ability to resolve images backed by ImageStreams. To work around this limitation, the template for deploying kafka has a parameter that accepts the image reference. 

To locate the image reference of the previously built image, use the following command repository:

```
oc get istag kafka:latest --template='{{ .image.dockerImageReference }}'
```
The response can be used as an input parameter *KAFKA_IMAGESTREAMTAG* for the [template](templates/kafka.json)

The full command to both resolve the image reference and instantiate the kafka template is shown below:

```
oc process -v=KAFKA_IMAGESTREAMTAG=$(oc get istag kafka:latest --template='{{.image.dockerImageReference}}') -f templates/kafka.json | oc create -f-
```

## Verify the Deployment

One of the benefits of a PetSet is the ability for each deployed instance to have its own backing storage. To verify storage was bound successfully, run `oc get pvc -l=application=kafka`. A result similar to the following should be displayed:

```
NAME                  STATUS    VOLUME    CAPACITY   ACCESSMODES   AGE
datadir-kafka-0   Bound     pv01      1Gi        RWO,RWX       49m
datadir-kafka-1   Bound     pv02      2Gi        RWO,RWX       49m
datadir-kafka-2   Bound     pv03      3Gi        RWO,RWX       49m
```*Note: Volume names, access modes and capacities are dependent on the persistent storage deployed in the environment*

Next, validate PetSet members are running and ready by executing `oc get pods -l=application=kafka`.  If three pods have a status of *RUNNING*, the containers have a status of *1/1*, and have a restart count of *0*, then kafka is deployed successfully. A successful deployment is shown below:

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

Create a topic called foo

```
/opt/kafka/bin/kafka-topics.sh --zookeeper zookeeper:2181 --topic foo --create --partitions 1 --replication-factor 1
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
/opt/kafka/bin/kafka-console-consumer.sh --zookeeper zookeeper:2181 --topic foo --from-beginning
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
sh-4.2# /opt/kafka/bin/kafka-console-consumer.sh --zookeeper zookeeper:2181 --topic foo --from-beginning
Using the ConsoleConsumer with old consumer is deprecated and will be removed in a future major release. Consider using the new consumer by passing [bootstrap-server] instead of [zookeeper].
testing
openshift
kafka
```

Type CTRL+C to close out of either publisher or consumer commands. If the same command for the consumer is used once again, the same list of responses that were sent by the publisher are returned. 