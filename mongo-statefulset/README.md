# Deploying a MongoDB Cluster Using StatefulSets

 [MongoDB replication](https://docs.mongodb.com/manual/replication/) example
that demonstrates the use of a [StatefulSet](https://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/) to deploy a sharded MongoDB cluster.


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

The functionality to automate the deployment and management of a MongoDB replica is an existing functionality found into the [registry.access.redhat.com/rhscl/mongodb-34-rhel7](https://access.redhat.com/containers/#/registry.access.redhat.com/rhscl/mongodb-34-rhel7) image.


## Bill of Materials

### Environment Specifications

This demo should be run on an installation of OpenShift Container Platform V3.5. A persistent volume must be statically predefined per replica set member pod, or configuration server member pod - this example will require 11 persistent volumes. Another option is have these persistent volumes allocated dynamically using a [StorageClass](https://docs.openshift.com/container-platform/latest/install_config/storage_examples/storage_classes_dynamic_provisioning.html). An EBS storage class is provided as an example.

### Template Files

Three template files are available:

config_server - Contains a template for deploying a replica set of shard configuration servers. At least one member is required for setting up a fully sharded cluster.

mongos - Contains a template for deploying a MongoDB shard router

replset - Contains a template for deploying a replica set.

### Config Files

None

### External Source Code Repositories

To demonstrate an the usage of the MongoDB replica set, the [default OpenShift Node.js](https://github.com/openshift/nodejs-ex) application will be deployed and configured to make use of the deployed data store.

## Setup Instructions

The presenter should have an OpenShift Container Platform 3 environment available with access to the public internet and the OpenShift Command Line Tools installed on their machine. The use of StatefulSet ecosystem was introduced in OpenShift 3.3. Prior to version 3.5, StatefulSets was known as PetSets. The object type definition must be updated to refer to the legacy term.

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


### Create a Configuration Server Cluster

Run the following command to process the configuration server template

```
oc process -f config_server/template.yaml -p MONGODB_CONFIGSVR_REPLICA_NAME=cs0 -p MONGODB_ADMIN_PASSWORD=admin -p MONGODB_KEYFILE_VALUE=123456789 | oc apply -f -
```

### Create Two Replica Sets

Run the following commands to process the replica set template, and generate a stateful set for each replica set. We will shard between these members.

```
oc process -f replset/template.yaml -p MONGODB_USER=user -p MONGODB_PASSWORD=pass -p MONGODB_DATABASE=example -p MONGODB_ADMIN_PASSWORD=admin -p MONGODB_REPLSET_REPLICA_NAME=rs0 -p MONGODB_KEYFILE_VALUE=123456789 -p REPLSET_SEED=abc | oc apply -f -
```

```
oc process -f replset/template.yaml -p MONGODB_USER=user -p MONGODB_PASSWORD=pass -p MONGODB_DATABASE=example -p MONGODB_ADMIN_PASSWORD=admin -p MONGODB_REPLSET_REPLICA_NAME=rs1 -p MONGODB_KEYFILE_VALUE=123456789 -p REPLSET_SEED=def | oc apply -f -
```

### Deploy a Shard Router

Run the following command to process the mongos template:

```
oc process -f mongos/template.yaml -p MONGODB_ADMIN_PASSWORD=admin -p MONGODB_KEYFILE_VALUE=123456789 -p REPLSET_NAMES=rs0,rs1 -p REPLSET_SERVERS=mongodbreplsetabc-0.mongodb-replset-internal-abc.mongodb-statefulset.svc.cluster.local:27017,mongodbreplsetdef-0.mongodb-replset-internal-def.mongodb-statefulset.svc.cluster.local:27017 -p CONFIG_REPLSET_NAME=cs0 -p CONFIG_REPLSET_SERVER=mongodbconfigsvr-0.mongodb-configsvr-internal.mongodb-statefulset.svc.cluster.local:27017 | oc apply -f -
```


### Confirm the state of the Replica Set

Once the replica sets are running, the state can be verified.

To see logs from a particular pod:

```
$ oc logs mongodbreplsetabc-0
```

Launch a remote shell session into one of the members of the replica set:

```
$ oc rsh mongodbreplsetabc-0
```

The replica set can be interrogated by logging into MongoDB using the administrator account that was automatically created:

```
sh-4.2$ mongo admin -u admin -p $MONGODB_ADMIN_PASSWORD  
```

Once successfully connected to the database, execute the `rs.status()` command to view the status of the replica set

```
$ rs0:PRIMARY> rs.status()
{
	"set" : "rs0",
	"date" : ISODate("2017-10-11T02:07:52.389Z"),
	"myState" : 1,
	"term" : NumberLong(1),
	"heartbeatIntervalMillis" : NumberLong(2000),
	"optimes" : {
		"lastCommittedOpTime" : {
			"ts" : Timestamp(1507687663, 1),
			"t" : NumberLong(1)
		},
		"appliedOpTime" : {
			"ts" : Timestamp(1507687663, 1),
			"t" : NumberLong(1)
		},
		"durableOpTime" : {
			"ts" : Timestamp(1507687663, 1),
			"t" : NumberLong(1)
		}
	},
	"members" : [
		{
			"_id" : 0,
			"name" : "mongodbreplsetabc-0.mongodb-replset-internal-abc.mongodb-statefulset.svc.cluster.local:27017",
			"health" : 1,
			"state" : 1,
			"stateStr" : "PRIMARY",
			"uptime" : 981,
			"optime" : {
				"ts" : Timestamp(1507687663, 1),
				"t" : NumberLong(1)
			},
			"optimeDate" : ISODate("2017-10-11T02:07:43Z"),
			"electionTime" : Timestamp(1507686701, 2),
			"electionDate" : ISODate("2017-10-11T01:51:41Z"),
			"configVersion" : 4,
			"self" : true
		},
		{
			"_id" : 1,
			"name" : "mongodbreplsetabc-1.mongodb-replset-internal-abc.mongodb-statefulset.svc.cluster.local:27017",
			"health" : 1,
			"state" : 2,
			"stateStr" : "SECONDARY",
			"uptime" : 944,
			"optime" : {
				"ts" : Timestamp(1507687663, 1),
				"t" : NumberLong(1)
			},
			"optimeDurable" : {
				"ts" : Timestamp(1507687663, 1),
				"t" : NumberLong(1)
			},
			"optimeDate" : ISODate("2017-10-11T02:07:43Z"),
			"optimeDurableDate" : ISODate("2017-10-11T02:07:43Z"),
			"lastHeartbeat" : ISODate("2017-10-11T02:07:50.781Z"),
			"lastHeartbeatRecv" : ISODate("2017-10-11T02:07:51.750Z"),
			"pingMs" : NumberLong(0),
			"syncingTo" : "mongodbreplsetabc-0.mongodb-replset-internal-abc.mongodb-statefulset.svc.cluster.local:27017",
			"configVersion" : 4
		},
		{
			"_id" : 2,
			"name" : "mongodbreplsetabc-2.mongodb-replset-internal-abc.mongodb-statefulset.svc.cluster.local:27017",
			"health" : 1,
			"state" : 2,
			"stateStr" : "SECONDARY",
			"uptime" : 916,
			"optime" : {
				"ts" : Timestamp(1507687663, 1),
				"t" : NumberLong(1)
			},
			"optimeDurable" : {
				"ts" : Timestamp(1507687663, 1),
				"t" : NumberLong(1)
			},
			"optimeDate" : ISODate("2017-10-11T02:07:43Z"),
			"optimeDurableDate" : ISODate("2017-10-11T02:07:43Z"),
			"lastHeartbeat" : ISODate("2017-10-11T02:07:51.436Z"),
			"lastHeartbeatRecv" : ISODate("2017-10-11T02:07:50.819Z"),
			"pingMs" : NumberLong(0),
			"syncingTo" : "mongodbreplsetabc-0.mongodb-replset-internal-abc.mongodb-statefulset.svc.cluster.local:27017",
			"configVersion" : 4
		},
		{
			"_id" : 3,
			"name" : "mongodbreplsetabc-3.mongodb-replset-internal-abc.mongodb-statefulset.svc.cluster.local:27017",
			"health" : 1,
			"state" : 2,
			"stateStr" : "SECONDARY",
			"uptime" : 896,
			"optime" : {
				"ts" : Timestamp(1507687663, 1),
				"t" : NumberLong(1)
			},
			"optimeDurable" : {
				"ts" : Timestamp(1507687663, 1),
				"t" : NumberLong(1)
			},
			"optimeDate" : ISODate("2017-10-11T02:07:43Z"),
			"optimeDurableDate" : ISODate("2017-10-11T02:07:43Z"),
			"lastHeartbeat" : ISODate("2017-10-11T02:07:50.781Z"),
			"lastHeartbeatRecv" : ISODate("2017-10-11T02:07:52.384Z"),
			"pingMs" : NumberLong(0),
			"syncingTo" : "mongodbreplsetabc-2.mongodb-replset-internal-abc.mongodb-statefulset.svc.cluster.local:27017",
			"configVersion" : 4
		}
	],
	"ok" : 1
}
```
4 instances (1 primary and 3 secondary) are shown above and depicts a healthy replica set

### Confirm the health of the two shards through the shard router

Check the logs for mongos, for example

```
$ oc logs mongos-2-t5zp8
```

Log into the mongos pod

```
$ oc rsh mongos-2-t5zp8
```

Run the same command from earlier. This time you will see a "mongos" prompt.

```
$ mongo admin -u admin -p $MONGODB_ADMIN_PASSWORD
```

Check the shard status with "sh.status()". Notice our two replica sets are used as shard members. However, we have no databases enabled for sharding.

```
mongos> sh.status()
--- Sharding Status ---
  sharding version: {
	"_id" : 1,
	"minCompatibleVersion" : 5,
	"currentVersion" : 6,
	"clusterId" : ObjectId("59dd7887f68c97671ce9b289")
}
  shards:
	{  "_id" : "rs0",  "host" : "rs0/mongodbreplsetabc-0.mongodb-replset-internal-abc.mongodb-statefulset.svc.cluster.local:27017,mongodbreplsetabc-1.mongodb-replset-internal-abc.mongodb-statefulset.svc.cluster.local:27017,mongodbreplsetabc-2.mongodb-replset-internal-abc.mongodb-statefulset.svc.cluster.local:27017,mongodbreplsetabc-3.mongodb-replset-internal-abc.mongodb-statefulset.svc.cluster.local:27017",  "state" : 1 }
	{  "_id" : "rs1",  "host" : "rs1/mongodbreplsetdef-0.mongodb-replset-internal-def.mongodb-statefulset.svc.cluster.local:27017,mongodbreplsetdef-1.mongodb-replset-internal-def.mongodb-statefulset.svc.cluster.local:27017,mongodbreplsetdef-2.mongodb-replset-internal-def.mongodb-statefulset.svc.cluster.local:27017,mongodbreplsetdef-3.mongodb-replset-internal-def.mongodb-statefulset.svc.cluster.local:27017",  "state" : 1 }
  active mongoses:
	"3.4.6" : 1
 autosplit:
	Currently enabled: yes
  balancer:
	Currently enabled:  yes
	Currently running:  no
		Balancer lock taken at Wed Oct 11 2017 01:48:55 GMT+0000 (UTC) by ConfigServer:Balancer
	Failed balancer rounds in last 5 attempts:  0
	Migration Results for the last 24 hours:
		No recent migrations
  databases:
```

### Setting up sharding for a sample application

Enable our example database for sharding:

```
oc rsh dc/mongodb-mongos mongo example -u admin -p admin --authenticationDatabase admin --eval "sh.enableSharding('example') ; db.createUser({user: 'user', pwd: 'pass', roles: [{ role: 'readWrite', db: 'example'}]})"
```

## Deploy an Application to Connect to the Shard Router

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
$ oc env dc/nodejs-ex MONGO_URL='mongodb://user:pass@mongodb-mongos-ext.mongodb-statefulset.svc:27017/example'
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

Currently the database is enabled for sharding, but you must shard a collection for it to be effective. Experiment around with sharding using different collections. See sh.shardCollection()
