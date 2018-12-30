# Deploying a MongoDB Cluster Using StatefulSets

 [MongoDB replication](https://docs.mongodb.com/manual/replication/) example
that demonstrates the use of a [StatefulSet](https://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/) to deploy a sharded MongoDB cluster.


## Table of Contents

* [Overview](#overview)
  * [OpenShift objects](#openshift-objects)
* [Prerequisites](#prerequisites)
* [Bill of Materials](#bill-of-materials)
	* [Environment Specifications](#environment-specifications)
	* [Template Files](#template-files)
	* [Config Files](#config-files)
	* [External Source Code Repositories](#external-source-code-repositories)
* [Setup Instructions](#setup-instructions)
* [Presenter Notes](#presenter-notes)
	* [Environment Setup](#environment-setup)
  * [Deploy the MongoDB cluster](#deploy-the-mongodb-cluster)
	* [Confirm the state of the Replica Set](#confirm-the-state-of-the-replica-set)
* [Deploy an Application to Connect to the Replica Set](#deploy-an-application-to-connect-to-the-replica-set)
* [Cleaning up](#cleaning-up)

## Overview

The functionality to automate the deployment and management of a MongoDB replica is an existing functionality found into the [registry.access.redhat.com/rhscl/mongodb-34-rhel7](https://access.redhat.com/containers/#/registry.access.redhat.com/rhscl/mongodb-34-rhel7) image.


It makes use of the following technologies:

* [StatefulSets](http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/)
* [Headless Services](http://kubernetes.io/docs/user-guide/services/#headless-services)
* [Openshift Applier](https://github.com/redhat-cop/openshift-applier)

>**NOTE:** If the project name is changed from the default (mongodb), updates will be required to match the new internal domain name (see headless service above)

### OpenShift objects
The openshift-applier will create the following OpenShift objects:
* A Project named `mongodb` (see [files/projects/projects.yml](files/projects/projects.yml))
* Four Services named `mongodb-configsvr-internal`, `mongodb-replset-internal-abc`, `mongodb-replset-internal-def` and `mongodb-mongos-ext` (see [applier/templates/configsvr.yml](applier/templates/configsvr.yml), [applier/templates/replset.yml](applier/templates/replset.yml) and [applier/templates/mongos.yml](applier/templates/mongos.yml))
* Three StatefulSets named `mongodbconfigsvr`, `mongodbreplset-abc`, `mongodbreplset-def` (see [applier/templates/configsvr.yml](applier/templates/configsvr.yml) and [applier/templates/replset.yml](applier/templates/replset.yml))
* A DeploymentConfig named `mongodb-mongos` (see [applier/templates/mongos.yml](applier/templates/mongos.yml))

>**NOTE:** This requires permission to create new projects and that the `mongodb` project doesn't already exist

## Prerequisites

The following prerequisites must be met prior to beginning to deploy MongoDB

* 11 [Persistent Volumes](https://docs.openshift.com/container-platform/latest/architecture/additional_concepts/storage.html). 3 for the config servers and 4 for each of the sharding replica sets [see below](#verify-storage)) or a cluster that supports [dynamic provisioning with a default StorageClass](https://docs.openshift.com/container-platform/latest/install_config/storage_examples/storage_classes_dynamic_provisioning.html)
* OpenShift Command Line Tool
* [Openshift Applier](https://github.com/redhat-cop/openshift-applier) to deploy MongoDB. As a result you'll need to have [ansible installed](http://docs.ansible.com/ansible/latest/intro_installation.html)

## Bill of Materials

### Environment Specifications

This demo should be run on an installation of OpenShift Container Platform V3.5. A persistent volume must be statically predefined per replica set member pod, or configuration server member pod - this example will require 11 persistent volumes. Another option is have these persistent volumes allocated dynamically using a [StorageClass](https://docs.openshift.com/container-platform/latest/install_config/storage_examples/storage_classes_dynamic_provisioning.html). An EBS storage class is provided as an example.

### Template Files

Three template files are available:

[configsvr.yml](applier/templates/configsvr.yml)- Contains a template for deploying a replica set of shard configuration servers. At least one member is required for setting up a fully sharded cluster.

[mongos.yml](applier/templates/mongos.yml)- Contains a template for deploying a MongoDB shard router

[replset.yml](applier/templates/replset.yml) - Contains a template for deploying a replica set.

### Config Files

None

### External Source Code Repositories

To demonstrate an the usage of the MongoDB replica set, the [default OpenShift Node.js](https://github.com/openshift/nodejs-ex) application will be deployed and configured to make use of the deployed data store.

## Setup Instructions

The presenter should have an OpenShift Container Platform 3 environment available with access to the public internet and the OpenShift Command Line Tools installed on their machine. The use of StatefulSet ecosystem was introduced in OpenShift 3.3. Prior to version 3.5, StatefulSets was known as PetSets. The object type definition must be updated to refer to the legacy term.

## Presenter Notes

The following steps are to be used to demonstrate how to add the template to OpenShift, deploy the MongoDB replica set along with deploying a sample application to validate connectivity.

### Environment Setup

1. Clone this repository: `git clone https://github.com/redhat-cop/containers-quickstarts`
2. `cd containers-quickstarts/mongodb`
3. Run `ansible-galaxy install -r requirements.yml --roles-path=roles`
4. Login to OpenShift: `oc login -u <username> https://master.example.com:8443`

### Deploy the MongoDB cluster

Run the openshift-applier to create the `mongodb` project and deploy config servers, shard replica sets and a shard router.
```
ansible-playbook -i applier/inventory roles/openshift-applier/playbooks/openshift-cluster-seed.yml
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
			"name" : "mongodbreplsetabc-0.mongodb-replset-internal-abc.mongodb.svc.cluster.local:27017",
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
			"name" : "mongodbreplsetabc-1.mongodb-replset-internal-abc.mongodb.svc.cluster.local:27017",
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
			"syncingTo" : "mongodbreplsetabc-0.mongodb-replset-internal-abc.mongodb.svc.cluster.local:27017",
			"configVersion" : 4
		},
		{
			"_id" : 2,
			"name" : "mongodbreplsetabc-2.mongodb-replset-internal-abc.mongodb.svc.cluster.local:27017",
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
			"syncingTo" : "mongodbreplsetabc-0.mongodb-replset-internal-abc.mongodb.svc.cluster.local:27017",
			"configVersion" : 4
		},
		{
			"_id" : 3,
			"name" : "mongodbreplsetabc-3.mongodb-replset-internal-abc.mongodb.svc.cluster.local:27017",
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
			"syncingTo" : "mongodbreplsetabc-2.mongodb-replset-internal-abc.mongodb.svc.cluster.local:27017",
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
$ oc logs mongodb-mongos-2-t5zp8
```

Log into the mongos pod

```
$ oc rsh mongodb-mongos-2-t5zp8
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
	{  "_id" : "rs0",  "host" : "rs0/mongodbreplsetabc-0.mongodb-replset-internal-abc.mongodb.svc.cluster.local:27017,mongodbreplsetabc-1.mongodb-replset-internal-abc.mongodb.svc.cluster.local:27017,mongodbreplsetabc-2.mongodb-replset-internal-abc.mongodb.svc.cluster.local:27017,mongodbreplsetabc-3.mongodb-replset-internal-abc.mongodb.svc.cluster.local:27017",  "state" : 1 }
	{  "_id" : "rs1",  "host" : "rs1/mongodbreplsetdef-0.mongodb-replset-internal-def.mongodb.svc.cluster.local:27017,mongodbreplsetdef-1.mongodb-replset-internal-def.mongodb.svc.cluster.local:27017,mongodbreplsetdef-2.mongodb-replset-internal-def.mongodb.svc.cluster.local:27017,mongodbreplsetdef-3.mongodb-replset-internal-def.mongodb.svc.cluster.local:27017",  "state" : 1 }
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
nodejs-ex   nodejs-ex-mongodb-example.192.168.99.100.nip.io             nodejs-ex   8080-tcp                 None
```

Open a web browser and navigate to the address indicated in the _HOST/PORT_ column


The example application is designed to be run with or without access to an external database. Environment variables specified within the deployed container dictate the execution of the application.

Several environment variables can be defined to enable and drive the functionality to allow the application to make use of a database. However, a single variable `MONGODB_URL` can be specified containing the connection string for the database.

Execute the following command which will interrogate the running environment and set environment variable on the _nodejs-ex_ DeploymentConfig.

```
$ oc set env dc/nodejs-ex MONGO_URL='mongodb://user:pass@mongodb-mongos-ext.mongodb.svc:27017/example'
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
Connected to MongoDB at: mongodb://IMC:GTCyRg1TS80PnGcM@mongodb-0.mongodb-internal.mongodb-example.svc.cluster.local:27017,mongodb-1.mongodb-internal.mongodb-example.svc.cluster.local:27017,mongodb-2.mongodb-internal.mongodb-example.svc.cluster.local:27017/sampledb?replicaSet=rs0
```

Once the application is connected to the database, the number of page views is now visible with the metrics being persistently stored to MongoDB.

Currently the database is enabled for sharding, but you must shard a collection for it to be effective. Experiment around with sharding using different collections. See sh.shardCollection()

## Cleaning up
```
oc delete project mongodb
```
