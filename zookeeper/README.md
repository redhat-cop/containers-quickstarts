Apache Zookeeper
============

Deployment of [Apache Zookeeper](https://zookeeper.apache.org/) on the OpenShift Container Platform

## Overview

Zookeeper is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services. The deployment to OpenShift was adapted from the upstream [Kubernetes Zookeeper](https://github.com/kubernetes/contrib/tree/master/statefulsets/zookeeper) example.

It makes use of the following technologies:

* [StatefulSets](http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/) 
* [Headless Services](http://kubernetes.io/docs/user-guide/services/#headless-services)

## Prerequisites

The following prerequisites must be met prior to beginning to build and deploy Zookeeper

* 3 [Persistent Volumes](https://docs.openshift.com/container-platform/3.3/architecture/additional_concepts/storage.html#architecture-additional-concepts-storage)
* OpenShift Command Line Tool
* [Openshift Applier](https://github.com/redhat-cop/casl-ansible/tree/master/roles/openshift-applier) to build and deploy Zookeeper. As a result you'll need to have [ansible installed](http://docs.ansible.com/ansible/latest/intro_installation.html)

## Build and Deployment

1. Clone this repository: `git clone https://github.com/redhat-cop/containers-quickstarts`
2. `cd containers-quickstarts/zookeeper`
3. Run `ansible-galaxy install -r requirements.yml --roles-path=roles`
4. Login to OpenShift: `oc login -u <username> https://master.example.com:8443`
5. Run openshift-applier: `ansible-playbook -i inventory/hosts roles/casl-ansible/playbooks/openshift-cluster-seed.yml`

The above steps will create the `zookeeper` project and build a Zookeeper image and deployment using StatefulSets.

## OpenShift Objects

The openshift-applier will create the following OpenShift objects:
* A project named `zookeeper` (see [files/projects/projects.yml](files/projects/projects.yml))
* Two ImageStreams named `rhel` and `zookeeper` (see [files/imagestreams/images.yml](files/imagestreams/image.yml) and [files/builds/template.yml](files/builds/template.yml))
* A BuildConfig named `zookeeper` (see [files/builds/template.yml](/files/builds/template.yml))
* Two Services `zookeeper` and `zookeeper-headless` (see [files/deployments/template.yml](files/deployments/template.yml))
* A StatefulSet named `zookeeper` (see [files/deployments/template.yml](files/deployments/template.yml))
* A ConfigMap named `zookeeper-config` (see [files/deployments/template.yml](files/deployments/template.yml))

## Verify the Deployment

One of the benefits of a StatefulSet is the ability for each deployed instance to have its own backing storage. To verify storage was bound successfully, run `oc get pvc -l=application=zookeeper`. A result similar to the following should be displayed:

```
NAME                  STATUS    VOLUME    CAPACITY   ACCESSMODES   AGE
datadir-zookeeper-0   Bound     pv01      1Gi        RWO,RWX       49m
datadir-zookeeper-1   Bound     pv02      2Gi        RWO,RWX       49m
datadir-zookeeper-2   Bound     pv03      3Gi        RWO,RWX       49m
```

*Note: Volume names, access modes and capacities are dependent on the persistent storage deployed in the environment*

Next, validate StatefulSet members are running and ready by executing `oc get pods -l=application=zookeeper`.  If three pods have a status of *RUNNING*, the containers have a status of *1/1*, and have a restart count of *0*, then zookeeper is deployed successfully. A successful deployment is shown below:

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
oc exec zookeeper-0 -- /opt/zookeeper/bin/zkCli.sh create /foo bar;
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

## Cleaning up
`oc delete project zookeeper`
