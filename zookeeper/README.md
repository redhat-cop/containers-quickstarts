Apache Zookeeper
============

Deployment of [Apache Zookeeper](https://zookeeper.apache.org/) on the OpenShift Container Platform

## Overview

Zookeeper is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services. The deployment to OpenShift was adapted from the upstream [Kubernetes Zookeeper](https://github.com/kubernetes/contrib/tree/master/statefulsets/zookeeper) example.

It makes use of the following technologies:

* [PetSets](http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/) (StatefulSets)
* [Headless Services](http://kubernetes.io/docs/user-guide/services/#headless-services)

## Prerequisites

The following prerequisites must be met prior to beginning to build and deploy Zookeeper

* 3 [Persistent Volumes](https://docs.openshift.com/container-platform/3.3/architecture/additional_concepts/storage.html#architecture-additional-concepts-storage)
* OpenShift Command Line Tool

## Build and Deployment

Prior to building and deploying Zookeeper, a new project must be allocated to contain the resources for the deployment. Login to an OpenShift environment and execute the following command to create a new project called *zookeeper*

```
oc new-project zookeeper
```

A set of templates are available to streamline the build and deployment of Zookeeper and are found in the [templates](templates) directory.

The first step is to build the zookeeper container for deployment in OpenShift. Since the Zookeeper image uses Red Hat Enterprise Linux (RHEL) 7 as the base, the ImageStream must be first added to OpenShift

Execute the following command to create the ImageStream:

```
oc create -f templates/rhel7-is.json
```

Next, instantiate the template to create a Build Configuration to produce a docker image

```
oc process -f templates/zookeeper-build.json | oc create -f-
```

A new image build will be kicked off automatically. It can be tracked by running `oc logs -f builds/zookeeper-1`

Once the build completes successfully, the newly created image can be deployed to OpenShift.

PetSets provide a way to effectively deploy stateful applications. However, it does not currently have the ability to resolve images backed by ImageStreams. To work around this limitation, the template for deploying zookeeper has a parameter that accepts the image reference. 

To locate the image reference of the previously built image, use the following command repository:

```
oc get istag zookeeper:latest --template='{{ .image.dockerImageReference }}'
```
The response can be used as an input parameter *ZOOKEEPER_IMAGESTREAMTAG* for the [template](templates/zookeeper.json)

The full command to both resolve the image reference and instantiate the zookeeper template is shown below:

```
oc process -v=ZOOKEEPER_IMAGESTREAMTAG=$(oc get istag zookeeper:latest --template='{{.image.dockerImageReference}}') -f templates/zookeeper.json | oc create -f-
```

## Verify the Deployment

One of the benefits of a PetSet is the ability for each deployed instance to have its own backing storage. To verify storage was bound successfully, run `oc get pvc -l=application=zookeeper`. A result similar to the following should be displayed:

```
NAME                  STATUS    VOLUME    CAPACITY   ACCESSMODES   AGE
datadir-zookeeper-0   Bound     pv01      1Gi        RWO,RWX       49m
datadir-zookeeper-1   Bound     pv02      2Gi        RWO,RWX       49m
datadir-zookeeper-2   Bound     pv03      3Gi        RWO,RWX       49m
```*Note: Volume names, access modes and capacities are dependent on the persistent storage deployed in the environment*

Next, validate PetSet members are running and ready by executing `oc get pods -l=application=zookeeper`.  If three pods have a status of *RUNNING*, the containers have a status of *1/1*, and have a restart count of *0*, then zookeeper is deployed successfully. A successful deployment is shown below:

```
NAME          READY     STATUS    RESTARTS   AGE
zookeeper-0   1/1       Running   0          1h
zookeeper-1   1/1       Running   0          1h
zookeeper-2   1/1       Running   0          1h
```

## Verify the Deployment

Validate the quorum configuration by creating a node on one instance and reading from it on another. 

First create a node on the first zookeeper instance by using the `oc exec` command:

```
oc exec zoo-0 -- /opt/zookeeper/bin/zkCli.sh create /foo bar;
```

If the node was successfully created, the following will appear:

```
Created /foo
```

Validate that another instance can retrieve details about the node previously created:

```
oc exec zookeeper-1 -- /opt/zookeeper/bin/zkCli.sh get /foo;
```

A successful response will be similar to the following:

```
bar
cZxid = 0x100000002
ctime = Wed Jan 04 20:44:54 EST 2017
mZxid = 0x100000002
mtime = Wed Jan 04 20:44:54 EST 2017
pZxid = 0x100000002
cversion = 0
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 3
numChildren = 0
```
