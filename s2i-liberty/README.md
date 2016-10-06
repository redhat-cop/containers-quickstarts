
# Liberty Source to Image Builder Demo

This demonstration describes how to produce a new Source to Image (S2I) runtime image to deploy web application running on liberty on OpenShift.

![IBM Liberty](https://browser-call.wasdev.developer.ibm.com/assets/liberty_logo_transp.png "IBM Liberty")

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
	* [Produce Runtime Image](#produce-runtime-image)
		* [Git Source](#git-source)
		* [Binary Source](#binary-source)
	* [Create the build config](#create-the-build-config)	
	* [Create a new Application](#create-a-new-application)
    * [Considerations on HTTP session failover](#considerations-on-http-session-failover)	


## Overview

OpenShift provides several out of the box Source to Image builder images. To support deployments in Liberty, a new s2i builder image will be created to support a simplified deployment to OpenShift. Once the new image is produced, an example application will be deployed. 

We will demonstrate two approaches to achieve this objective:

1. two s2i builds. With this option the first s2i build builds an image with the right artifacts, the second s2i build grabs the artifacts from the first build and create the final runnable liberty image.  

2. use the [extended builds approach](https://docs.openshift.com/container-platform/3.3/dev_guide/builds.html#extended-builds). This experimental feature chains the two previous build together creating a single build that does both the previous actions. 

## Bill of Materials

### Environment Specifications

This demo should be run on an installation of OpenShift Enterprise V3.3

### Template Files

None

### Config Files

None

### External Source Code Repositories

* [Example JEE Application](https://github.com/efsavage/hello-world-war) -  Public repository for a simple JEE hello world app.

## Two build approach

### Setup Instructions

There is no specific requirements necessary for this demonstration. The presenter should have an OpenShift Enterprise 3.3 environment available with access to the public Internet and the OpenShift Command Line Tools installed on their machine.

### Presenter Notes

The following steps are to be used to demonstrate two methods for producing the Source to Image builder image and deploying an application using the resulting image.

#### Environment Setup

Using the OpenShift CLI, login to the OpenShift environment.


```
oc login <OpenShift_Master_API_Address>
```

Create a new project called *liberty-demo*


```
oc new-project liberty-demo
```

### Produce s2i Liberty Image

The Liberty runtime image can be created using the [Git](https://docs.openshift.com/enterprise/latest/dev_guide/builds.html#source-code) or [Binary](https://docs.openshift.com/enterprise/latest/dev_guide/builds.html#binary-source) build source

In this example we will use a pre-existing builder image that can build maven based apps: `registry.access.redhat.com/jboss-eap-7/eap70-openshift` 

##### Git Source

The content used to produce the Liberty runtime image can originate from a Git repository. Execute the following command to start a new image build using the git source strategy.:

```
oc new-build websphere-liberty:webProfile7~https://github.com/raffaelespazzoli/containers-quickstarts --context-dir=s2i-liberty --name=liberty-runtime-s2i --strategy=docker
```

Let's break down the command in further detail

* `oc new-build` - OpenShift command to create a new build
* `websphere-liberty:webProfile7` - The location of the base Docker image for which a new ImageStream will be created
* `~` - Specifying that source code will be provided
* `https://github.com/redhat-cop/containers-quickstarts` - URL of the Git repository
* `--context-dir` - Location within the repository containing source code
* `--name=s2i-liberty` - Name for the build and resulting image
* `--strategy=docker` - Name of the OpenShift source strategy that is used to produce the new image

*Note: If the repository was moved to a different location (such as a fork), be sure to reference to correct location.*

A new image called *s2i-liberty* was produced and can be used to build Liberty applications in the subsequent sections.

##### Binary Source

Instead of referencing a git repository, the content can be provided directly to the OpenShift build process using a binary source build. 

The first step is to obtain the source code containing the builder. Once the code has been obtained, navigate to the folder containing the Play Framework *Dockerfile*, and execute the following command to start a new image build using the binary source strategy:

```
oc new-build websphere-liberty:webProfile7 --name=liberty-runtime-s2i --strategy=docker --from-dir=. --binary=true
```

Let's break down the command in further detail

* `oc new-build` - OpenShift command to create a new build
* `websphere-liberty:webProfile7` - The location of the base Docker image for which a new ImageStream will be created
* `--from-dir` - Location of source code that will be used as the source for the build process. The contents will be tar'ed up and uploaded to the builder image.
* `--name=s2i-liberty` - Name for the build and resulting image
* `--strategy=docker` - Name of the OpenShift source strategy that is used to produce the new image
* `--binary=true` - Specifies this build will be of a binary source type

A new image called *s2i-liberty* was produced and can be used to build Play Framework applications in the subsequent sections.

#### Create the first s2i build

The first s2i build  will create the artifact. For this buld we will use the `jboss-eap-7/eap70-openshift` which is capable of building a maven project. 

Run the following command:
```
oc new-build --docker-image=registry.access.redhat.com/jboss-eap-7/eap70-openshift --code=https://github.com/efsavage/hello-world-war --name=hello-world-artifacts
```
#### Create the second s2i build

The second s2i build grabs the artifacts created by the first image and puts them in the expected locations in the Liberty image.

Run the following command:
```
oc new-build --image-stream=liberty-runtime-s2i --name=hello-world --strategy=source --source-image=hello-world-artifacts --source-image-path=/opt/eap/standalone/deployments/hello-world-war-1.0.0.war:artifacts
```


### Create a new Application

To demonstrate the usage of the newly created builder and runtime images, a JEE example application will be built and deployed to Liberty using the Source to Image process. 

Create the new application by passing in the name of the newly created and configured extended builder image :

```
oc new-app -i hello-world --name=hello-world
```

Let's break down the command in further detail

* `oc new-app` - OpenShift command to create a a new application
* `-i=hello-world` - Name of the ImageStream that contains the result of the build config that uses the extended s2i process
* `--name=hello-world` - Name to be applied to the newly created resources

The build that was triggered by the `new-app` command can be found by executing the following command:

```
oc get builds -l=app=hello-world
```

View the build logs by executing the following command:

```
oc logs builds/<build_name>
```

*Note: Replace `<build_name>` with the name of the build found in the previous command.*

Once the build completes, the application will be deployed.

## Extended build approach

### Setup Instructions

There is no specific requirements necessary for this demonstration. The presenter should have an OpenShift Enterprise 3.3 environment available with access to the public Internet and the OpenShift Command Line Tools installed on their machine.

### Presenter Notes

The following steps are to be used to demonstrate two methods for producing the Source to Image builder image and deploying an application using the resulting image.

#### Environment Setup

Using the OpenShift CLI, login to the OpenShift environment.


```
oc login <OpenShift_Master_API_Address>
```

Create a new project called *liberty-demo*


```
oc new-project liberty-demo
```

### Produce s2i Liberty Image

The Liberty runtime image can be created using the [Git](https://docs.openshift.com/enterprise/latest/dev_guide/builds.html#source-code) or [Binary](https://docs.openshift.com/enterprise/latest/dev_guide/builds.html#binary-source) build source

In this example we will use a pre-existing builder image that can build maven based apps: `registry.access.redhat.com/jboss-eap-7/eap70-openshift` 

##### Git Source

The content used to produce the Liberty runtime image can originate from a Git repository. Execute the following command to start a new image build using the git source strategy.:

```
oc new-build websphere-liberty:webProfile7~https://github.com/raffaelespazzoli/containers-quickstarts --context-dir=s2i-liberty --name=liberty-runtime-s2i --strategy=docker
```

Let's break down the command in further detail

* `oc new-build` - OpenShift command to create a new build
* `websphere-liberty:webProfile7` - The location of the base Docker image for which a new ImageStream will be created
* `~` - Specifying that source code will be provided
* `https://github.com/redhat-cop/containers-quickstarts` - URL of the Git repository
* `--context-dir` - Location within the repository containing source code
* `--name=s2i-liberty` - Name for the build and resulting image
* `--strategy=docker` - Name of the OpenShift source strategy that is used to produce the new image

*Note: If the repository was moved to a different location (such as a fork), be sure to reference to correct location.*

A new image called *s2i-liberty* was produced and can be used to build Liberty applications in the subsequent sections.

##### Binary Source

Instead of referencing a git repository, the content can be provided directly to the OpenShift build process using a binary source build. 

The first step is to obtain the source code containing the builder. Once the code has been obtained, navigate to the folder containing the Play Framework *Dockerfile*, and execute the following command to start a new image build using the binary source strategy:

```
oc new-build websphere-liberty:webProfile7 --name=s2i-liberty --strategy=docker --from-dir=. --binary=true
```

Let's break down the command in further detail

* `oc new-build` - OpenShift command to create a new build
* `websphere-liberty:webProfile7` - The location of the base Docker image for which a new ImageStream will be created
* `--from-dir` - Location of source code that will be used as the source for the build process. The contents will be tar'ed up and uploaded to the builder image.
* `--name=s2i-liberty` - Name for the build and resulting image
* `--strategy=docker` - Name of the OpenShift source strategy that is used to produce the new image
* `--binary=true` - Specifies this build will be of a binary source type

A new image called *s2i-liberty* was produced and can be used to build Play Framework applications in the subsequent sections.

#### Create the first build config

In order to use the extended s2i process we need to configure the build config with some additional pieces of information. There does not appear to be a way to do this directly from the command line so we will use a two-phase approach.

First we will create a standard build config using the git source apporach explained above. Run the follwoing command:
```
oc new-build --docker-image=registry.access.redhat.com/jboss-eap-7/eap70-openshift --code=https://github.com/efsavage/hello-world-war --name=hello-world
```
Second modify the newly created build config to look as follows:
```
    sourceStrategy:
      from:
        kind: ImageStreamTag
        name: 'eap70-openshift:latest'
      runtimeImage:
        kind: ImageStreamTag
        name: 'liberty-runtime-s2i:latest'
      runtimeArtifacts:
        - sourcePath: /opt/eap/standalone/deployments/hello-world-war-1.0.0.war
          destinationDir: artifacts
```
notice that the source strategy has two additional sections:
* `runtimeImage`: which defines the runtime image to be used during the build
* `runtimeArtifacts:`: which is an array and specifies a list of artifacts that will be copied from the builder image to the runtime image.

For mode details on how this copy process works, see the [runtime image documentation](https://github.com/openshift/source-to-image/blob/master/docs/runtime_image.md).

The liberty runtime image expects:
* any deployable artifacts in the $WORKDIR/artifacts directory
* any [Liberty configuration files] (http://www.ibm.com/support/knowledgecenter/SSAW57_liberty/com.ibm.websphere.wlp.nd.doc/ae/cwlp_config.html) in the $WORKDIR/config directory 

As you can notice the runtimeArtifacts section mentions files by name. This implies that for this process to work the artifact created by the builder image have to be always the same. I expect improvements on this front in future releases of OpenShigt but for now this is a constraint that must be kept in mind.

### Create a new Application

To demonstrate the usage of the newly created builder and runtime images, a JEE example application will be built and deployed to Liberty using the Source to Image process. 

Create the new application by passing in the name of the newly created and configured extended builder image :

```
oc new-app -i hello-world --name=hello-world
```

Let's break down the command in further detail

* `oc new-app` - OpenShift command to create a a new application
* `-i=hello-world` - Name of the ImageStream that contains the result of the build config that uses the extended s2i process
* `--name=hello-world` - Name to be applied to the newly created resources

The build that was triggered by the `new-app` command can be found by executing the following command:

```
oc get builds -l=app=hello-world
```

View the build logs by executing the following command:

```
oc logs builds/<build_name>
```

*Note: Replace `<build_name>` with the name of the build found in the previous command.*

Once the build completes, the application will be deployed.

## Considerations on http session failover

When liberty is deployed in a cloud environment, there are certain limitations that apply as explained in this [document](http://www.ibm.com/support/knowledgecenter/en/SSD28V_8.5.5/com.ibm.websphere.wlp.core.doc/ae/cwlp_paas_restrict.html).
With respect to the http session failover, two techniques generally apply:

1. session replication: Liberty does not support session replication out-of-the-box. This feature can be implemented by integrating with eXtremeScale, as described in this [article](http://www.ibm.com/support/knowledgecenter/SSTVLU_8.6.0/com.ibm.websphere.extremescale.doc/cxshttpsession.html?view=embed).  
2. session persistence: it is possible to persist the session using any database that support a JDBC connection. This [article](http://www.ibm.com/support/knowledgecenter/en/SSD28V_8.5.5/com.ibm.websphere.base.doc/ae/tprs_cnfp.html) explains how to configure Liberty to do so.