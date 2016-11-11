# S2I Java builder image 

*Note: This image is a fork of the Java S2I builder from the [fabric8](https://github.com/fabric8io-images/s2i/tree/master/java/images/rhel) project. A first class supported Java S2I builder will be part of Fuse Integration Services 2.0 (Early 2017).*

This is a S2I builder image for Java builds whose result can be run directly without any further application server.

## Table of Contents

* [Overview](#overview)
* [Configuring the Image](#configuring-the-image)
	* [Build Time](#build-time)
	* [Run Time](#run-time)
		* [Jolokia Configuration](#jolokia-configuration)
* [Bill of Materials](#bill-of-materials)
	* [Environment Specifications](#environment-specifications)
	* [Template Files](#template-files)
	* [Config Files](#config-files)
	* [External Source Code Repositories](#external-source-code-repositories)
* [Setup Instructions](#setup-instructions)
* [Presenter Notes](#presenter-notes)
	* [Environment Setup](#environment-setup)
	* [Adding QuickStart Templates](#adding-quickstart-templates)
	* [Instantiate the java-quickstart-rhel Template](#instantiate-the-java-quickstart-rhel-template)
	* [Verify the Application](#verify-the-application)
* [Resources](#resources)


## Overview

This image is suited ideally for microservices with a flat classpath (including "far jars") and also provides an easy integration with an [Jolokia](https://github.com/rhuss/jolokia)  agent. 

## Configuring the Image

The following sections describe environment variables can be used to influence the behavior of this builder image:

### Build Time

* **MAVEN_ARGS** Arguments to use when calling maven, replacing the default `package hawt-app:build -DskipTests -e`. Please be sure to run the `hawt-app:build` goal (when not already bound to the `package` execution phase), otherwise the startup scripts won't work.
* **MAVEN_ARGS_APPEND** Additional Maven  arguments, useful for temporary adding arguments like `-X` or `-am -pl ..`
* **ARTIFACT_DIR** Path to `target/` where the jar files are created for multi module builds. These are added to `${MAVEN_ARGS}`
* **ARTIFACT_COPY_ARGS** Arguments to use when copying artifacts from the output dir to the application dir. Useful to specify which artifacts will be part of the image. It defaults to `-r hawt-app/*` when a `hawt-app` dir is found on the build directory, otherwise jar files only will be included (`*.jar`).
* **MAVEN_CLEAR_REPO** If set then the Maven repository is removed after the artifact is built. This is useful for keeping
  the created application image small, but prevents *incremental* builds. The default is `false`

### Run Time

The run script can be influenced by the following environment variables:

* **JAVA_OPTIONS**  Options that will be passed to the JVM.  Use it to set options like the max JVM memory (-Xmx1G).
* **JAVA_ENABLE_DEBUG**  If set to true, then enables JVM debugging
* **JAVA_DEBUG_PORT** Port used for debugging (default: 5005)
* **JAVA_AGENT** Set this to pass any JVM agent arguments for stuff like profilers
* **JAVA_MAIN_ARGS** Arguments that will be passed to you application's main method.  **Default:** the arguments passed to the `bin/run` script.
* **JAVA_MAIN_CLASS** The main class to use if not configured within the plugin

The environment variables are best set in `.sti/environment` top in you project. This file is picked up bei S2I
during building and running.

#### Jolokia configuration

* **AB_JOLOKIA_OFF** : If set disables activation of Joloka (i.e. echos an empty value). By default, Jolokia is enabled.
* **AB_JOLOKIA_CONFIG** : If set uses this file (including path) as Jolokia JVM agent properties (as described 
  in Jolokia's [reference manual](http://www.jolokia.org/reference/html/agents.html#agents-jvm)). 
  By default this is `/opt/jolokia/jolokia.properties`. 
* **AB_JOLOKIA_HOST** : Host address to bind to (Default: `0.0.0.0`)
* **AB_JOLOKIA_PORT** : Port to use (Default: `8778`)
* **AB_JOLOKIA_USER** : User for authentication. By default authentication is switched off.
* **AB_JOLOKIA_PASSWORD** : Password for authentication. By default authentication is switched off.
* **AB_JOLOKIA_HTTPS** : Switch on secure communication with https. By default self signed server certificates are generated
  if no `serverCert` configuration is given in `AB_JOLOKIA_OPTS`
* **AB_JOLOKIA_ID** : Agent ID to use (`$HOSTNAME` by default, which is the container id)
* **AB_JOLOKIA_OPTS**  : Additional options to be appended to the agent opts. They should be given in the format 
  "key=value,key=value,..."

Some options for integration in various environments:

* **AB_JOLOKIA_AUTH_OPENSHIFT** : Switch on client authentication for OpenShift TSL communication. The value of this 
  parameter can be a relative distinguished name which must be contained in a presented client certificate. Enabling this
  parameter will automatically switch Jolokia into https communication mode. The default CA cert is set to 
  `/var/run/secrets/kubernetes.io/serviceaccount/ca.crt`
  
## Bill of Materials

### Environment Specifications

This demo should be run on an installation of OpenShift Enterprise V3

### Template Files

A template called *java-quickstart-rhel* is available in the [rhel-templates.json](../quickstart-templates/rhel-templates.json) file

### Config Files

None

### External Source Code Repositories

An example project (spring-boot-webmvc) [httpd-container](https://github.com/fabric8-quickstarts/spring-boot-webmvc.git) from the [fabric8](https://fabric8.io/) project is used to demonstrate an application deployed on the newly created builder image.

## Setup Instructions

There is no specific requirements necessary for this demonstration. The presenter should have an OpenShift Enterprise 3 environment available with access to the public internet and the OpenShift Command Line Tools installed on their machine.

## Presenter Notes

The following steps are to be used to demonstrate how to add a file containing the list of quickstarts to the OpenShift environment and to instantiate a template that will produce a build of the custom Java Source to Image builder and sample application.

### Environment Setup

Using the OpenShift CLI, login to the OpenShift environment.

```
oc login <OpenShift_Master_API_Address>
```

Create a new project called *java-s2i-demo*

```
oc new-project java-s2i-demo
```

### Adding QuickStart Templates

A set of OpenShift templates have been provided to simplify usage of these container quickstarts in the *quickstart-templates* folder. To add a template to OpenShift, you can either clone the repository to your local machine or retrieve the template from GitHub.

If you have cloned the repository to your local machine, navigate to the *quickstarts-templates* folder and execute the following command to add the templates to the OpenShift project.

```
oc create -f rhel-templates.json
```

Otherwise, you can add the template directly from GitHub by executing the following command:

```
oc create -f https://raw.githubusercontent.com/redhat-cop/containers-quickstarts/master/quickstart-templates/rhel-templates.json
```
### Instantiate the java-quickstart-rhel Template

A template called *java-quickstart-rhel* has been provided in the previous set of created templates. The following actions are performed by the template:

* Perform a Docker build of a custom Java Source to Image compatible image
* Once the Java S2I builder image is built, it will trigger a new Source to Image build of a sample application
* A new container from the application image will be deployed

Execute the following command to instantiate the template:

```
oc new-app --template=java-quickstart-rhel
```

Track the statuses of the build by executing `oc get builds`. When both builds are complete, validate the application has been deployed by listing the running pods:

```
oc get pods | grep Running
```

### Verify the Application

Verify the example application can be reached in a web browser. First, locate the url of the application by executing the following command

```
oc get routes
```

Using a web browser, navigate to the location referenced in the *HOST/PORT* column.

The application can be successfully validated if the webpage can be accessed

## Resources
* [Upstream Java S2I Builder](https://github.com/fabric8io-images/s2i/tree/master/java/images/rhel)
* [Source to Image](https://docs.openshift.com/enterprise/latest/architecture/core_concepts/builds_and_image_streams.html#source-build)
* [Builds](https://docs.openshift.com/enterprise/latest/dev_guide/builds.html)
* [Developer CLI Reference](https://docs.openshift.com/enterprise/latest/cli_reference/basic_cli_operations.html)
