[![Build Status](https://prow-default.apps.ci-1.cop.rht-labs.com/badge.svg?jobs=cq-daily-master)](https://prow-default.apps.ci-1.cop.rht-labs.com/?job=cq-daily-master)
[![License](https://img.shields.io/hexpm/l/plug.svg?maxAge=2592000)]()

# Container Quickstarts by Red Hat's Community of Practice

This repository is meant to help bootstrap users of the OpenShift Container Platform to get started in building and using Source-to-Image to build applications to run in OpenShift.

For more details on what a _Quickstart_ is, please read our [contribution guide](./CONTRIBUTING.md).

## What's In This Repo?

This repo contains OpenShift related quickstarts of several different flavors.

### Reference Implementations

A set of examples of deploying various technologies on OpenShift

* [MongoDB Cluster StatefulSet](./mongodb)
* [RabbitMQ Cluster StatefulSet](./rabbitmq)
* [GitLab CE Deployment](./gitlab-ce)
* [SonarQube](./sonarqube)
* [Zalenium](./zalenium)

### Custom S2I Base Images

A collection of custom built S2I base images

* [GoWS](./build-s2i-gows)
* [Jekyll](./build-s2i-jekyll)
* [WebSphere Liberty](./build-s2i-liberty)
* [Play Framework](./build-s2i-play)

### Jenkins Slave Images

A set of images we've developed for running as slave pods in a Jenkins Pipeline on OpenShift

* [Ansible Slave](./jenkins-slaves/jenkins-slave-ansible)
* [GoLang](./jenkins-slaves/jenkins-slave-golang)
* [Image Promotion](./jenkins-slaves/jenkins-slave-image-mgmt)
* [Extended Maven Slave](./jenkins-slaves/jenkins-slave-mvn)
* [Ruby](./jenkins-slaves/jenkins-slave-ruby)
* [Arachni](./jenkins-slaves/jenkins-slave-arachni)
* [Gradle](./jenkins-slaves/jenkins-slave-gradle)
* [MongoDB](./jenkins-slaves/jenkins-slave-mongodb)
* [Node](./jenkins-slaves/jenkins-slave-npm)
* [Python](./jenkins-slaves/jenkins-slave-python)
* [ZAP](./jenkins-slaves/jenkins-slave-zap)

### Customized Jenkins Masters

A set of buildConfigs for building custom Jenkins images for OpenShift.

* [Jenkins Master with the Hygieia Plugin](./jenkins-masters/hygieia-plugin)

### Developer Tools

* [Tool Box](./tool-box) - An OpenShift deployable container image that provides some necessary developer tools
* [motepair](./motepair) - Remote pair programming server and plugin for [Atom](https://atom.io/)

## Related Content

* [Container Pipelines](https://github.com/redhat-cop/container-pipelines) - A set of Jenkins piplines for OpenShift
* [Labs CI/CD](https://github.com/rht-labs/labs-ci-cd) - A comprehensive end to end pipeline using many modern testing and quality tools
* [OpenShift Templates](https://github.com/rht-labs/openshift-templates) - A library of OpenShift template examples & references
* [OpenShift Applier](https://github.com/redhat-cop/openshift-applier) - An automation framework for keeping manifests and templates applied to a cluster

## Contributing

Checkout out our [contribution guide](./CONTRIBUTING.md) for more details on how to contribute content to this repo.
