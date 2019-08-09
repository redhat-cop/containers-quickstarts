# Apache HTTPD Web Server

Source to Image (S2I) compliant Apache HTTPD Server image which is an extension of the `rhscl/httpd-24-rhel7` image provided by the Red Hat Software Collections Organization.

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
	* [Instantiate the httpd-quickstart-rhel Template](#instantiate-the-httpd-quickstart-rhel-template)
	* [Verify the Application](#verify-the-application)
* [Resources](#resources)


## Overview

The OpenShift Container Platform (OCP) provides several out of the box Source to Image compliant images for many popular web technology frameworks, such as PHP, Python and NodeJS. There is also a need to provide a standalone web server, without the additional libraries and components included by these web frameworks.

## Bill of Materials

### Environment Specifications

This demo should be run on an installation of OpenShift Enterprise V3

### Template Files

A template called *httpd-quickstart-rhel* is available in the [rhel-templates.json](../quickstart-templates/rhel-templates.json) file

### Config Files

None

### External Source Code Repositories

The upstream [httpd-container](https://github.com/sclorg/httpd-container/tree/master/2.4) from the Red Hat Software Collections organization contains a sample that is used the provided quick start template.

## Setup Instructions

There is no specific requirements necessary for this demonstration. The presenter should have an OpenShift Enterprise 3 environment available with access to the public internet and the OpenShift Command Line Tools installed on their machine.

## Presenter Notes

The following steps are to be used to demonstrate how to add a file containing the list of quickstarts to the OpenShift environment and to instantiate a template that will produce a build of the custom Apache HTTPD image and sample application.

### Environment Setup

Using the OpenShift CLI, login to the OpenShift environment.

```
oc login <OpenShift_Master_API_Address>
```

Create a new project called *httpd-demo*

```
oc new-project httpd-demo
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

### Instantiate the httpd-quickstart-rhel Template

A template called *httpd-quickstart-rhel* has been provided in the previous set of created templates. The following actions are performed by the template:

* Perform a Docker build of a custom Apache HTTPD Source to Image compatible image
* Once the HTTPD image is built, it will trigger a new Source to Image build of a sample application
* A new container from the application image will be deployed

Execute the following command to instantiate the template:

```
oc new-app --template=httpd-quickstart-rhel
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
* [Apache HTTPD Web Server](https://httpd.apache.org/)
* [Source to Image](https://docs.openshift.com/container-platform/3.11/architecture/core_concepts/builds_and_image_streams.html#source-build)
* [Builds](https://docs.openshift.com/container-platform/3.11/dev_guide/builds/index.html)
* [Developer CLI Reference](https://docs.openshift.com/container-platform/3.11/cli_reference/basic_cli_operations.html)