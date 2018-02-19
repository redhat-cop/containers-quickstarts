# Liberty Source to Image Builder Demo

This demonstration describes how to produce a new Source to Image (S2I) runtime image to deploy web application running on liberty on OpenShift.

![IBM Liberty](https://browser-call.wasdev.developer.ibm.com/assets/liberty_logo_transp.png "IBM Liberty")

## Table of Contents

* [Overview](#overview)
* [Bill of Materials](#bill-of-materials)
  * [Environment Specifications](#environment-specifications)
  * [External Source Code Repositories](#external-source-code-repositories)
  * [OpenShift objects](#openshift-objects)
* [Setup Instructions](#setup-instructions)
  * [Prerequisites](#prerequisites)
* [Build and Deployment](#build-and-deployment)
  * [Verify the application](#verify-the-application)
* [Considerations on HTTP session failover](#considerations-on-http-session-failover)
* [Cleaning up](#cleaning-up)


## Overview

OpenShift provides several out of the box Source to Image builder images. To support deployments in Liberty, a new s2i builder image will be created to support a simplified deployment to OpenShift. Once the new image is produced, an example application will be deployed.

It makes use of the following technologies:

* [Openshift Applier](https://github.com/redhat-cop/casl-ansible/tree/master/roles/openshift-applier)

## Bill of Materials

### Environment Specifications

This demo should be run on an installation of OpenShift Enterprise V3.7

### External Source Code Repositories

* [Example JEE Application](https://github.com/efsavage/hello-world-war) -  Public repository for a simple JEE hello world app.

### OpenShift objects

The openshift-applier will create the following OpenShift objects:
* A project named `liberty-demo` (see [applier/projects/projects.yml](applier/projects/projects.yml))
* Five ImageStreams named `websphere-liberty`, `s2i-liberty`, `hello-world-artifacts`, `eap70-openshift` and `hello-world` (see [applier/templates/build.yml](applier/templates/build.yml))
* Three BuildConfigs named `websphere-liberty`, `hello-world-artifacts` and `hello-world` (see [applier/templates/build.yml](applier/templates/build.yml))
* A DeploymentConfig named `hello-world` (see [applier/templates/deployment.ym](applier/templates/deployment.yml))
* A Service named `hello-world` (see [applier/templates/deployment.ym](applier/templates/deployment.yml))
* A Route named `hello-world` (see [applier/templates/deployment.ym](applier/templates/deployment.yml))

>**NOTE:** This requires permission to create new projects and that the `liberty-demo` project doesn't already exist

## Setup Instructions

There is no specific requirements necessary for this demonstration. The presenter should have an OpenShift Enterprise 3.7 environment available with access to the public Internet and the OpenShift Command Line Tools installed on their machine.

### Prerequisites

The following prerequisites must be met prior to beginning to build and deploy Liberty

* OpenShift Command Line Tool
* [Openshift Applier](https://github.com/redhat-cop/casl-ansible/tree/master/roles/openshift-applier) to build and deploy artifacts and applications. As a result you'll need to have [ansible installed](http://docs.ansible.com/ansible/latest/intro_installation.html)
The following steps are to be used to demonstrate two methods for producing the Source to Image builder image and deploying an application using the resulting image.

## Build and Deployment

1. Clone this repository: `git clone https://github.com/redhat-cop/containers-quickstarts`
2. `cd containers-quickstarts/s2i-liberty`
3. Run `ansible-galaxy install -r requirements.yml --roles-path=roles`
4. Login to OpenShift: `oc login -u <username> https://master.example.com:8443`
5. Run openshift-applier: `ansible-playbook -i applier/inventory/ roles/casl-ansible/playbooks/openshift-cluster-seed.yml`

Three new image builds will be kicked off automatically. They can be tracked by running `oc logs -f bc/websphere-liberty`, `oc logs -f bc/hello-world-artifacts` and `oc logs -f bc/hello-world` respectively.
Last the deployment will kick of which can be tracked by running `oc logs -f dc/hello-world`.

### Verify the application

The application will be available at the context: `hello-world-war-1.0.0`
You can *curl* as follows:
```
curl -L http://$(oc get route hello-world --template '{{ .spec.host }}')/hello-world-war-1.0.0
```

## Liberty s2i image environment variables

You can set the following environment variable on containers running on images created with the Liberty s2i image:

| Environment Variable | Default | Description |
|----------------------|---------|-------------|
| ENABLE_DEBUG         | false   | enable running the jvm in debug mode |
| DEBUG_PORT           | 7777    | port on which the jvm will listen for a debugger |


## Considerations on http session failover

When liberty is deployed in a cloud environment, there are certain limitations that apply as explained in this [document](http://www.ibm.com/support/knowledgecenter/en/SSD28V_8.5.5/com.ibm.websphere.wlp.core.doc/ae/cwlp_paas_restrict.html).
With respect to the http session failover, two techniques generally apply:

1. session replication: Liberty does not support session replication out-of-the-box. This feature can be implemented by integrating with eXtremeScale, as described in this [article](http://www.ibm.com/support/knowledgecenter/SSTVLU_8.6.0/com.ibm.websphere.extremescale.doc/cxshttpsession.html?view=embed).  
2. session persistence: it is possible to persist the session using any database that support a JDBC connection. This [article](http://www.ibm.com/support/knowledgecenter/en/SSD28V_8.5.5/com.ibm.websphere.base.doc/ae/tprs_cnfp.html) explains how to configure Liberty to do so.

## Cleaning up
```
oc delete project liberty-demo
```
