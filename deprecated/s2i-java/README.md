# S2I Java builder image 

**Note: This example is deprecated. A Red Hat Supported Java image is available at [registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift](https://access.redhat.com/containers/#/repo/58ada5701fbe981673cd6b10/image/openshift)**

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

* **JAVA_APP_DIR** the directory where the application resides. All paths in your application are relative to this directory.
* **JAVA_LIB_DIR** directory holding the Java jar files as well an optional `classpath` file which holds the classpath. Either as a single line classpath (colon separated) or with jar files listed line-by-line. If not set **JAVA_LIB_DIR** is the same as **JAVA_APP_DIR**.
* **JAVA_OPTIONS** options to add when calling `java`
* **JAVA_MAX_MEM_RATIO** is used when no `-Xmx` option is given in `JAVA_OPTIONS`. This is used to calculate a default maximal Heap Memory based on a containers restriction. If used in a Docker container without any memory constraints for the container then this option has no effect. If there is a memory constraint then `-Xmx` is set to a ratio of the container available memory as set here. The default is 50 which means 50% of the available memory is used as an upper boundary. You can skip this mechanism by setting this value to 0 in which case no `-Xmx` option is added.
* **JAVA_MAX_CORE** restrict manually the number of cores available which is used for calculating certain defaults like the number of garbage collector threads. If set to 0 no base JVM tuning based on the number of cores is performed.
* **JAVA_DIAGNOSTICS** set this to get some diagnostics information to standard out when things are happening
* **JAVA_MAIN_CLASS** A main class to use as argument for `java`. When this environment variable is given, all jar files in `$JAVA_APP_DIR` are added to the classpath as well as `$JAVA_LIB_DIR`.
* **JAVA_APP_JAR** A jar file with an appropriate manifest so that it can be started with `java -jar` if no `$JAVA_MAIN_CLASS` is set. In all cases this jar file is added to the classpath, too.
* **JAVA_APP_NAME** Name to use for the process
* **JAVA_CLASSPATH** the classpath to use. If not given, the startup script checks for a file `${JAVA_APP_DIR}/classpath` and use its content literally as classpath. If this file doesn't exists all jars in the app dir are added (`classes:${JAVA_APP_DIR}/*`).
* **JAVA_DEBUG** If set remote debugging will be switched on
* **JAVA_DEBUG_PORT** Port used for remote debugging. Default: 5005

If neither `$JAVA_APP_JAR` nor `$JAVA_MAIN_CLASS` is given, `$JAVA_APP_DIR` is checked for a single JAR file which is taken as `$JAVA_APP_JAR`. If no or more then one jar file is found, an error is thrown.

The classpath is build up with the following parts:

* If `$JAVA_CLASSPATH` is set, this classpath is taken.
* The current directory (".") is added first.
* If the current directory is not the same as `$JAVA_APP_DIR`, `$JAVA_APP_DIR` is added.
* If `$JAVA_MAIN_CLASS` is set, then
  - A `$JAVA_APP_JAR` is added if set
  - If a file `$JAVA_APP_DIR/classpath` exists, its content is appended to the classpath. This file
    can be either a single line with the jar files colon separated or a multi-line file where each line
    holds the path of the jar file relative to `$JAVA_LIB_DIR` (which by default is the `$JAVA_APP_DIR`)
  - If this file is not set, a `${JAVA_APP_DIR}/*` is added which effectively adds all
    jars in this directory in alphabetical order.

These variables can be also set in a shell config file `run-env.sh`, which will be sourced by the startup script. This file can be located in the directory where the startup script is located and in `${JAVA_APP_DIR}`, whereas environment variables in the latter override the ones in `run-env.sh` from the script directory.

This startup script also checks for a command `run-java-options`. If existant it will be called and the output is added to the environment variable `$JAVA_OPTIONS`.

The startup script also exposes some environment variables describing container limits which can be used by applications:

* **CONTAINER_CORE_LIMIT** a calculated core limit as desribed in https://www.kernel.org/doc/Documentation/scheduler/sched-bwc.txt
* **CONTAINER_MAX_MEMORY** memory limit given to the container

Any arguments given during startup are taken over as arguments to the Java app.


#### Jolokia configuration

* **AB_JOLOKIA_OFF** : If set disables activation of Jolokia (i.e. echos an empty value). By default, Jolokia is enabled.
* **AB_JOLOKIA_CONFIG** : If set uses this file (including path) as Jolokia JVM agent properties (as described 
  in Jolokia's [reference manual](http://www.jolokia.org/reference/html/agents.html#agents-jvm)). If not set, 
  the `/opt/jolokia/etc/jolokia.properties` will be created using the settings as defined in this document, otherwise
  the reset of the settings in this document are ignored.
* **AB_JOLOKIA_HOST** : Host address to bind to (Default: `0.0.0.0`)
* **AB_JOLOKIA_PORT** : Port to use (Default: `8778`)
* **AB_JOLOKIA_USER** : User for basic authentication. Defaults to 'jolokia'
* **AB_JOLOKIA_PASSWORD** : Password for basic authentication. By default authentication is switched off.
* **AB_JOLOKIA_PASSWORD_RANDOM** : Should a random AB_JOLOKIA_PASSWORD be generated? Generated value will be written to `/opt/jolokia/etc/jolokia.pw`
* **AB_JOLOKIA_HTTPS** : Switch on secure communication with https. By default self signed server certificates are generated
  if no `serverCert` configuration is given in `AB_JOLOKIA_OPTS`
* **AB_JOLOKIA_ID** : Agent ID to use (`$HOSTNAME` by default, which is the container id)
* **AB_JOLOKIA_DISCOVERY_ENABLED** : Enable Jolokia discovery.  Defaults to false.
* **AB_JOLOKIA_OPTS**  : Additional options to be appended to the agent configuration. They should be given in the format 
  "key=value,key=value,..."

Some options for integration in various environments:

* **AB_JOLOKIA_AUTH_OPENSHIFT** : Switch on client authentication for OpenShift TSL communication. The value of this 
  parameter can be a relative distinguished name which must be contained in a presented client certificate. Enabling this
  parameter will automatically switch Jolokia into https communication mode. The default CA cert is set to 
  `/var/run/secrets/kubernetes.io/serviceaccount/ca.crt` 

Application arguments can be provided by setting the variable **JAVA_ARGS** to the corresponding value.
  
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
* [Source to Image](https://docs.openshift.com/container-platform/3.11/architecture/core_concepts/builds_and_image_streams.html#source-build)
* [Builds](https://docs.openshift.com/container-platform/3.11/dev_guide/builds/index.html)
* [Developer CLI Reference](https://docs.openshift.com/container-platform/3.11/cli_reference/basic_cli_operations.html)
