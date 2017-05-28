# MongoDB Replication Example Using a StatefulSet

 [MongoDB replication](https://docs.mongodb.com/manual/replication/) example
that demonstrates the use of a [StatefulSet](https://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/) to manage replica set members.


## Table of Contents

* [Overview](#overview)
* [Bill of Materials](#bill-of-materials)
	* [Environment Specifications](#environment-specifications)
	* [Template Files](#template-files)
	* [Config Files](#config-files)
	* [External Source Code Repositories](#external-source-code-repositories)
* [Setup Instructions](#setup-instructions)
* [Presenter Notes](#presenter-notes)
	* [Environment Setup](#environment-setup)
	* [Adding QuickStart Templates](#adding-quickstart-templates)
	* [Instantiate the mongodb-statefulset-replication Template](#instantiate-the-mongodb-statefulset-replication-template)
	* [Confirm the state of the Replica Set](#confirm-the-state-of-the-replica-set)
* [Deploy an Application to Connect to the Replica Set](#deploy-an-application-to-connect-to-the-replica-set)

## Overview

The functionality to automate the deployment and management of a MongoDB replica is an existing functionality found into the [registry.access.redhat.com/rhscl/mongodb-32-rhel7](https://access.redhat.com/containers/#/registry.access.redhat.com/rhscl/mongodb-32-rhel7) image. An [OpenShift
template](https://docs.openshift.org/latest/dev_guide/templates.html) can be used to deploy the replica set as a StatefulSet along with the necessary supporting components.


## Bill of Materials

### Environment Specifications

This demo should be run on an installation of OpenShift Enterprise V3. Three (3) persistent volumes must be available as statically predefined or allocated dynamically using a [StorageClass](https://docs.openshift.com/container-platform/latest/install_config/storage_examples/storage_classes_dynamic_provisioning.html) to support MongoDB.

### Template Files

A template called *mongodb-statefulset-replication.yaml* is available in the [mongodb-statefulset-replication.yaml](mongodb-statefulset-replication.yaml) file

### Config Files

None

### External Source Code Repositories

To demonstrate an the usage of the MongoDB replica set, the [default OpenShift Node.js](https://github.com/openshift/nodejs-ex) application will be deployed and configured to make use of the deployed data store.

## Setup Instructions

The presenter should have an OpenShift Enterprise 3 environment available with access to the public internet and the OpenShift Command Line Tools installed on their machine. The use of StatefulSet ecosystem was introduced in OpenShift 3.3. Prior to version 3.5, StatefulSets was known as PetSets. The object type definition must be updated to refer to the legacy term. 
 
## Presenter Notes

The following steps are to be used to demonstrate how to add the template to OpenShift, deploy the MongoDB replica set along with deploying a sample application to validate connectivity.

### Environment Setup

Using the OpenShift CLI, login to the OpenShift environment.

```
$ oc login <OpenShift_Master_API_Address>
```

Create a new project called *mongodb-statefulset*

```
$oc new-project mongodb-statefulset
```

### Adding QuickStart Templates

The template containing the MongoDB StatefulSet is located within the _mongo-statefulset_ folder.

If you have cloned the repository to your local machine, navigate to the *mongo-statefulset* folder and execute the following command to add the templates to the OpenShift project.

```
$ oc create -f mongodb-statefulset-replication.yaml
```

Otherwise, you can add the template directly from GitHub by executing the following command:

```
$ oc create -f https://raw.githubusercontent.com/redhat-cop/containers-quickstarts/master/mongo-statefulset/mongodb-statefulset-replication.yaml
```


### Instantiate the mongodb-statefulset-replication Template

Once the _mongodb-statefulset-replication_ template has been added to the platform, it can be instantiated which creates the following resources:

* A MongoDB StatefulSet
* A Service to balance requests from inside the OpenShift cluster
* A [Headless Service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services) for discovering members of the MongoDB replica

Execute the following command to instantiate the template:

```
$ oc new-app --template=mongodb-statefulset-replication
```

Each replica will be launched sequentially and can be tracked by listing the pods:

```
$ oc get pods -l name=mongodb
NAME        READY     STATUS    RESTARTS   AGE
mongodb-0   1/1       Running   0          50m
mongodb-1   1/1       Running   0          50m
mongodb-2   1/1       Running   0          49m
```

### Confirm the state of the Replica Set

Once the 3 instance replica set is running, the state can be verified.

To see logs from a particular pod:

```
$ oc logs mongodb-0
```

Launch a remote shell session into one of the members of the replica set:

```
$ oc rsh mongodb-0
```

The replica set can be interrogated by logging into MongoDB using the administrator account that was automatically created:

```
sh-4.2$ mongo $MONGODB_DATABASE -u admin -p $MONGODB_ADMIN_PASSWORD  --authenticationDatabase admin
```

Once successfully connected to the database, execute the `rs.status()` command to view the status of the replica set

```
$ rs0:PRIMARY> rs.status()
{
	"set" : "rs0",
	"date" : ISODate("2017-05-27T15:11:08.951Z"),
	"myState" : 1,
	"term" : NumberLong(1),
	"heartbeatIntervalMillis" : NumberLong(2000),
	"members" : [
		{
			"_id" : 0,
			"name" : "mongodb-0.mongodb-internal.mongo-statefulset-example.svc.cluster.local:27017",
			"health" : 1,
			"state" : 1,
			"stateStr" : "PRIMARY",
			"uptime" : 713,
			"optime" : {
				"ts" : Timestamp(1495897175, 1),
				"t" : NumberLong(1)
			},
			"optimeDate" : ISODate("2017-05-27T14:59:35Z"),
			"electionTime" : Timestamp(1495897156, 2),
			"electionDate" : ISODate("2017-05-27T14:59:16Z"),
			"configVersion" : 3,
			"self" : true
		},
		{
			"_id" : 1,
			"name" : "mongodb-1.mongodb-internal.mongo-statefulset-example.svc.cluster.local:27017",
			"health" : 1,
			"state" : 2,
			"stateStr" : "SECONDARY",
			"uptime" : 703,
			"optime" : {
				"ts" : Timestamp(1495897175, 1),
				"t" : NumberLong(1)
			},
			"optimeDate" : ISODate("2017-05-27T14:59:35Z"),
			"lastHeartbeat" : ISODate("2017-05-27T15:11:07.523Z"),
			"lastHeartbeatRecv" : ISODate("2017-05-27T15:11:08.810Z"),
			"pingMs" : NumberLong(0),
			"syncingTo" : "mongodb-0.mongodb-internal.mongo-statefulset-example.svc.cluster.local:27017",
			"configVersion" : 3
		},
		{
			"_id" : 2,
			"name" : "mongodb-2.mongodb-internal.mongo-statefulset-example.svc.cluster.local:27017",
			"health" : 1,
			"state" : 2,
			"stateStr" : "SECONDARY",
			"uptime" : 693,
			"optime" : {
				"ts" : Timestamp(1495897175, 1),
				"t" : NumberLong(1)
			},
			"optimeDate" : ISODate("2017-05-27T14:59:35Z"),
			"lastHeartbeat" : ISODate("2017-05-27T15:11:07.173Z"),
			"lastHeartbeatRecv" : ISODate("2017-05-27T15:11:08.483Z"),
			"pingMs" : NumberLong(0),
			"configVersion" : 3
		}
	],
	"ok" : 1
}
```

3 instances (1 primary and 2 secondary) is shown above and depicts a healthy replica set

## Deploy an Application to Connect to the Replica Set

With the replica set deployed and validated, a sample application will be used to connect to demonstrate connectivity.

Deploy the OpenShift Node.js sample application by executing the following command:

```
$ oc new-app https://github.com/openshift/nodejs-ex
```

A new [Source to Image (S2I)](https://docs.openshift.com/container-platform/3.5/architecture/core_concepts/builds_and_image_streams.html#source-build) build will be automatically triggered and once complete, the application will be deployed.

By default, the `new-app` command does not create a [route](https://docs.openshift.com/container-platform/3.5/architecture/core_concepts/routes.html) which will allow traffic originating from outside the cluster to access resources inside the cluster. 

Execute the following command to create a route by exposing the _nodejs-ex_ service

```
$ oc expose svc nodejs-ex
```

Locate the hostname that was automatically created from the prior command:

```
$ oc get routes
NAME        HOST/PORT                                                   PATH      SERVICES    PORT       TERMINATION   WILDCARD
nodejs-ex   nodejs-ex-mongo-statefulset-example.192.168.99.100.nip.io             nodejs-ex   8080-tcp                 None
```

Open a web browser and navigate to the address indicated in the _HOST/PORT_ column


The example application is designed to be run with or without access to an external database. Environment variables specified within the deployed container dictate the execution of the application. 

Several environment variables can be defined to enable and drive the functionality to allow the application to make use of a database. However, a single variable `MONGODB_URL` can be specified containing the connection string for the database.

Execute the following command which will interrogate the running environment and set environment variable on the _nodejs-ex_ DeploymentConfig. 

```
$ oc env dc/nodejs-ex MONGO_URL=$(echo "mongodb://$(oc env statefulset mongodb --list | grep MONGODB_USER | awk -F "=" '{ print $2 }'):$(oc env statefulset mongodb --list | grep MONGODB_PASSWORD | awk -F "=" '{ print $2 }')@mongodb-0.mongodb-internal.$(oc project -q).svc.cluster.local:27017,mongodb-1.mongodb-internal.$(oc project -q).svc.cluster.local:27017,mongodb-2.mongodb-internal.$(oc project -q).svc.cluster.local:27017/$(oc env statefulset mongodb --list | grep MONGODB_DATABASE | awk -F "=" '{ print $2 }')?replicaSet=$(oc env statefulset mongodb --list | grep MONGODB_REPLICA_NAME | awk -F "=" '{ print $2 }')")
```

The resulting environment variable can be viewed with the following command 

```
$ oc env dc/nodejs-ex --list
```

The change to the DeploymentConfig will automatically trigger a new deployment of the _nodejs-ex_ application. 

Once the new deployment has been rolled out, view the logs to confirm connectivity to the database:

```
$ oc logs -f nodejs-ex-4-z3cvp
Environment: 
	DEV_MODE=false
	NODE_ENV=production
	DEBUG_PORT=5858
Launching via npm...
npm info it worked if it ends with ok
npm info using npm@2.15.1
npm info using node@v4.6.2
npm info prestart nodejs-ex@0.0.1
npm info start nodejs-ex@0.0.1
> nodejs-ex@0.0.1 start /opt/app-root/src
> node server.js
Server running on http://0.0.0.0:8080
Connected to MongoDB at: mongodb://IMC:GTCyRg1TS80PnGcM@mongodb-0.mongodb-internal.mongo-statefulset-example.svc.cluster.local:27017,mongodb-1.mongodb-internal.mongo-statefulset-example.svc.cluster.local:27017,mongodb-2.mongodb-internal.mongo-statefulset-example.svc.cluster.local:27017/sampledb?replicaSet=rs0
```

Once the application is connected to the database, the number of page views is now visible with the metrics being persistently stored to MongoDB.