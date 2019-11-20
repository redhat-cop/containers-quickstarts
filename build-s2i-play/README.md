# Play Framework Source to Image Builder Demo

This demonstration describes how to produce a new Source to Image (S2I) builder image to deploy Play Framework applications on OpenShift.

![Play Framework](images/play-logo.png "Play Framework")

## Table of Contents

* [Overview](#overview)
* [Bill of Materials](#bill-of-materials)
	* [Environment Specifications](#environment-specifications)
	* [External Source Code Repositories](#external-source-code-repositories)
  * [OpenShift objects](#openshift-objects)
* [Setup Instructions](#setup-instructions)
  * [Prerequisites](#prerequisites)
* [Build and deployment](#build-and-deployment)
  * [Verify the application](#verify-the-application)
* [Manual build and deployment](#manual-build-and-deployment)
	* [Environment Setup](#environment-setup)
	* [Produce Builder Image](#produce-builder-image)
		* [Git Source](#git-source)
		* [Binary Source](#binary-source)
	* [Create A New Application](#create-a-new-application)
	* [Validating the Application](#validating-the-application)
	* [Create a Route](#create-a-route)
* [Cleaning up](#cleaning-up)
* [Resources](#resources)


## Overview

OpenShift provides several out of the box Source to Image builder images. To support the vast ecosystem of applications developed using the Play Framework, a new builder image will be created to support a simplified deployment to OpenShift. Once the new image is produced, an example application will be deployed. 

It makes use of the following technologies:

* [Openshift Applier](https://github.com/redhat-cop/openshift-applier)

## Bill of Materials

### Environment Specifications

This demo should be run on an installation of OpenShift Enterprise V3

### External Source Code Repositories

* [Example Play Framework Application](https://github.com/playframework/play-ebean-example) -  Public repository for an example Play Framework application demonstrating how to communicate with an in memory database using [EBean](https://www.playframework.com/documentation/2.5.x/JavaEbean).

### OpenShift objects

The openshift-applier will create the following OpenShift objects:
* A project named `play-demo` 
* Three ImageStreams named `rhel7`, `s2i-play` and `play-app` (see [.openshift/templates/build.yml](.openshift/templates/build.yml))
* Two BuildConfigs named `s2i-play` and `play-app` (see [.openshift/templates/build.yml](.openshift/templates/build.yml))
* A DeploymentConfig named `play-app` (see [.openshift/templates/deployment.yml](.openshift/templates/deployment.yml))
* A Service named `play-app` (see [.openshift/templates/deployment.yml](.openshift/templates/deployment.yml))
* A Route named `play-app` (see [.openshift/templates/deployment.yml](.openshift/templates/deployment.yml))

>**NOTE:** This requires permission to create new projects and that the `play-demo` project doesn't already exist

## Setup Instructions

There is no specific requirements necessary for this demonstration. The presenter should have an OpenShift Enterprise 3 environment available with access to the public internet and the OpenShift Command Line Tools installed on their machine.

### Prerequisites

The following prerequisites must be met prior to beginning to build and deploy the Play application

* OpenShift command line tool
* [Openshift Applier](https://github.com/redhat-cop/openshift-applier) to build and deploy artifacts and applications. As a result you'll need to have [ansible installed](http://docs.ansible.com/ansible/latest/intro_installation.html)

## Build and Deployment

1. Clone this repository: `git clone https://github.com/redhat-cop/containers-quickstarts`
2. `cd containers-quickstarts/build-s2i-play`
3. Run `ansible-galaxy install -r requirements.yml --roles-path=roles`
4. Login in to OpenShift: `oc login -u <username> https://master.example.com:8443`
5. Run openshift-applier: `ansible-playbook -i applier/inventory roles/openshift-applier/playbooks/openshift-cluster-seed.yml`

Two new image builds will be kicked off automatically. They can be tracked by running `oc logs -f bc/build-s2i-play` and `oc logs -f bc/play-app` respectively.
Last the deployment will kick off which can be tracked by running `oc logs -f dc/play-app`.

### Verify the application

The application will be available through the route.
```
curl -L http://$(oc get route play-app --template '{{ .spec.host }}')
```

## Manual build and deployment

The following steps are to be used to demonstrate two methods for producing the Source to Image builder image and deploying an application using the resulting image.

### Environment Setup

Using the OpenShift CLI, login to the OpenShift environment.

```
oc login https://master.example.com:8443
```

Create a new project called *play-demo*

```
oc new-project play-demo
```

### Produce Builder Image

The Play Framework builder image can be created using the [Git](https://docs.openshift.com/container-platform/3.11/dev_guide/builds/build_inputs.html#source-code) or [Binary](https://docs.openshift.com/container-platform/3.11/dev_guide/builds/build_inputs.html#binary-source) build source

#### Git Source

The content used to produce the Play builder image can originate from a Git repository. Execute the following command to start a new image build using the git source strategy.:

```
oc new-build registry.access.redhat.com/rhel7-atomic:7.7~https://github.com/redhat-cop/containers-quickstarts --context-dir=build-s2i-play --name=s2i-play --strategy=docker
```

Let's break down the command in further detail

* `oc new-build` - OpenShift command to create a new build
* `registry.access.redhat.com/rhel7-atomic:7.7` - The location of the base Docker image for which a new ImageStream will be created
* `~` - Specifying that source code will be provided
* `https://github.com/redhat-cop/containers-quickstarts` - URL of the Git repository
* `--context-dir` - Location within the repository containing source code
* `--name=s2i-play` - Name for the build and resulting image
* `--strategy=docker` - Name of the OpenShift source strategy that is used to produce the new image
* `--follow=true` - Follows the build process in the command window

*Note: If the repository was moved to a different location (such as a fork), be sure to reference to correct location.*

The build that was triggered by the `new-build` command can be found by executing the following command:

```
oc get builds -l=build=s2i-play
```

View the build logs by executing the following command:

```
oc logs builds/<build_name>
```

*Note: Replace `<build_name>` with the name of the build found in the previous command.*


A new image called *s2i-play* was produced and can be used to build Play Framework applications in the subsequent sections.

#### Binary Source

Instead of referencing a git repository, the content can be provided directly to the OpenShift build process using a binary source build. 

The first step is to obtain the source code containing the builder. Once the code has been obtained, navigate to the folder containing the Play Framework *Dockerfile*, and execute the following command to start a new image build using the binary source strategy:

```
oc new-build registry.access.redhat.com/rhel7-atomic:7.7 --name=s2i-play --context-dir=build-s2i-play --strategy=docker --binary=true
```

Let's break down the command in further detail

* `oc new-build` - OpenShift command to create a new build
* `registry.access.redhat.com/rhel7-atomic:7.7` - The location of the base Docker image for which a new ImageStream will be created
* `--name=s2i-play` - Name for the build and resulting image
* `--context-dir` - Location within the repository containing source code
* `--strategy=docker` - Name of the OpenShift source strategy that is used to produce the new image
* `--binary=true` - Specifies this build will be of a binary source type

Now, start a new build by pushing the binary contents of the repository to OpenShift

```
oc start-build s2i-play --from-dir=. --follow
```

Let's break down the command in further detail

* `oc start-build` - OpenShift command to start a new build
* `--name=s2i-play` - Name for the build and resulting image
* `--from-dir` - Location of source code that will be used as the source for the build process. The contents will be tar'ed up and uploaded to the builder image.
* `--follow=true` - Follows the build process in the command window


A new image called *s2i-play* was produced and can be used to build Play Framework applications in the subsequent sections.

### Create a new Application

To demonstrate the usage of the newly created builder image, an example application from the Play Framework will be built and deployed using the Source to Image process. 

Create the new application by passing in the name of the builder image created previously and the git repository containing the source code:

```
oc new-app --image-stream=s2i-play --code=https://github.com/playframework/play-samples.git#2.7.x --name=play-app --context-dir=play-java-ebean-example
```

Let's break down the command in further detail

* `oc new-app` - OpenShift command to create a a new application
* `--image-stream=s2i-play` - Name of the ImageStream that will be used as the Source to Image builder
* `--code=https://github.com/playframework/play-samples.git#2.7.x` - Location of appliation source code that will be applied to the builder image.
* `--context-dir` - Location within the repository containing source code
* `--name=play-app` - Name to be applied to the newly created resources

The build that was triggered by the `new-app` command can be found by executing the following command:

```
oc get builds -l=app=play-app
```

View the build logs by executing the following command:

```
oc logs builds/<build_name>
```

*Note: Replace `<build_name>` with the name of the build found in the previous command.*

Once the build completes, the application will be deployed.

### Validating the Application

To validate the status of the application, check the status of the pod by running the following command:

```
oc get pods -l=deploymentconfig=play-app
```

A result similar to the following should appear:

```
NAME               READY     STATUS             RESTARTS   AGE
play-app-1-<random>   0/1       CrashLoopBackOff   6          8m
```

The *CrashLoopBackOff* status indicates that there is an error starting the pod. Attempting to view the pod logs by executing `oc logs play-app-1-<random>` provides insight into the pod failures. This provides an opportunity for users to have first hand experiencing troubleshooting OpenShift applications.

```
[warn] p.a.d.e.ApplicationEvolutions - Run with -Dplay.evolutions.db.default.autoApply=true if you want to run them automatically (be careful)
Oops, cannot start the server.
@71chkb9k9: Database 'default' needs evolution!
```

The example application demonstrates the use of database persistence and while preparing the application, the schema structure of an in memory database is modified. Play uses the concept of evolutions to track these types of changes and will apply them before the application can be run.

Evolutions can be applied automatically, as described in the error message above, by setting a Java runtime argument. The Play Framework builder allows Java arguments to be provided using the `JAVA_OPTS_EXT` environment variable.

Add the Java runtime argument to the DeploymentConfig by executing the following command:

```
oc set env dc/play-app JAVA_OPTS_EXT=-Dplay.evolutions.db.default.autoApply=true
```

The application will automatically deploy once a change to the configuration is detected. Wait a few moments and validate the application has started successfully by using the `oc get pods` and the `oc logs` command.

### Create a Route

By default, applications created using the `oc new-app` command without the use of a template will not have a route created. This results in the application being inaccessible from outside the OpenShift cluster. 

Execute the following command to expose the exisitng *play-app* service:

```
oc expose svc play-app
```

The hostname that the application can be access can be obtained by executing the `oc get routes` command.

Open a browser and confirm the application is accessible.


Feel free to navigate around the application.

## Cleaning up
```
oc delete project play-demo
```

## Resources
* [Play Framework](https://www.playframework.com/)
* [Source to Image](https://docs.openshift.com/container-platform/3.11/architecture/core_concepts/builds_and_image_streams.html#source-build)
* [Builds](https://docs.openshift.com/container-platform/3.11/dev_guide/builds/index.html)
* [Developer CLI Reference](https://docs.openshift.com/container-platform/3.11/cli_reference/basic_cli_operations.html)
