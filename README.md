# Container Quickstarts by Red Hat's Community of Practice

This repository is meant to help bootstrap users of the OpenShift Container Platform to get started in building and using Source-to-Image to build applications to run in OpenShift.

## What's In This Repo?

This repo contains OpenShift related quickstarts of several different flavors.

### Reference Implementations

A set of examples of deploying various technologies on OpenShift

* [MongoDB Cluster StatefulSet](./mongodb)
* [RabbitMQ Cluster StatefulSet](./rabbitmq)
* [GitLab CE Deployment](./gitlab-ce)
* [Zookeeper StatefulSet](./zookeeper)

### Custom S2I Base Images

A collection of custom built S2I base images

* [GoWS](./s2i-gows)
* [Jekyll](./s2i-jekyll)
* [WebSphere Liberty](./s2i-liberty)
* [Play Framework](./s2i-play)

### Jenkins Slave Images

A set of images we've developed for running as slave pods in a Jenkins Pipeline on OpenShift

* [Ansible Slave](./jenkins-slaves/jenkins-slave-ansible)
* [GoLang](./jenkins-slaves/jenkins-slave-golang)
* [Image Promotion](./jenkins-slaves/jenkins-slave-image-mgmt)
* [Extended Maven Slave](./jenkins-slaves/jenkins-slave-mvn)
* [Ruby](./jenkins-slaves/jenkins-slave-ruby)

### Developer Tools

* [Tool Box](./tool-box) - An openshift deployable contianer image that provides some necessary developer tools

## Related Content

* [Container Pipelines](https://github.com/redhat-cop/container-pipelines) - A set of Jenkins piplines for OpenShift

## Contributing

Checkout out our [contribution guide](./CONTRIBUTING.md) for more details on how to contribute content to this repo.
