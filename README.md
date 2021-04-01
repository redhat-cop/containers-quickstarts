[![Build Status](https://prow-default.apps.ci-1.cop.rht-labs.com/badge.svg?jobs=cq-daily-master)](https://prow-default.apps.ci-1.cop.rht-labs.com/?job=cq-daily-master)
[![License](https://img.shields.io/hexpm/l/plug.svg?maxAge=2592000)]()

# Containers Quickstarts by Red Hat's Community of Practice

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
* [Python Kopf Operator Framework](./build-s2i-python-kopf)

### Jenkins Agent Images

A set of images we've developed for running as agent pods in a Jenkins Pipeline on OpenShift

* [Ansible Agent](./jenkins-agents/jenkins-agent-ansible)
* [Arachni](./jenkins-agents/jenkins-agent-arachni)
* [ArgoCD](./jenkins-agents/jenkins-agent-argocd)
* [Conftest](./jenkins-agents/jenkins-agent-conftest)
* [Erlang](./jenkins-agents/jenkins-agent-erlang)
* [GoLang](./jenkins-agents/jenkins-agent-golang)
* [GraalVM](./jenkins-agents/jenkins-agent-graalvm)
* [Gradle](./jenkins-agents/jenkins-agent-gradle)
* [Helm](./jenkins-agents/jenkins-agent-helm)
* [Image Promotion](./jenkins-agents/jenkins-agent-image-mgmt)
* [MongoDB](./jenkins-agents/jenkins-agent-mongodb)
* [Extended Maven Agent](./jenkins-agents/jenkins-agent-mvn)
* [Node](./jenkins-agents/jenkins-agent-npm)
* [Python](./jenkins-agents/jenkins-agent-python)
* [Ruby](./jenkins-agents/jenkins-agent-ruby)
* [Rust](./jenkins-agents/jenkins-agent-rust)
* [ZAP](./jenkins-agents/jenkins-agent-zap)

### Customized Jenkins Masters

A set of buildConfigs for building custom Jenkins images for OpenShift.

* [Jenkins Master with the Hygieia Plugin](./jenkins-masters/hygieia-plugin)

### Gitlab Runners

Gitlab Runners for your [Gitlab CI/CD](https://docs.gitlab.com/runner/).

* [UBI 7](./ubi7-gitlab-runner)

### Utilities

* [UBI 8 Asciidoctor](./utilities/ubi8-asciidoctor)
* [UBI 8 Bats](./utilities/ubi8-bats)
* [UBI 8 Git](./utilities/ubi8-git)
* [UBI 8 Google API Pyton Client](./utilities/ubi8-google-api-python-client)

### Developer Tools

* [Tool Box](./tool-box) - An OpenShift deployable container image that provides some necessary developer tools

## Github Actions

To enable actions in your fork:
1. Fork this repository
2. Actions -> Click the button to enable
3. Settings -> Secrets

| Secret              | Description                                          |
|---------------------| -----------------------------------------------------|
| REGISTRY_URI        | Registry to push images to, ex: `quay.io`            |
| REGISTRY_REPOSITORY | Repository to push images to, ex: your quay username |
| REGISTRY_USERNAME   | Username used to push to registry                    |
| REGISTRY_PASSWORD   | Password used to push to registry                    |

>**NOTE:** It is recommended to use a service account for registry credentials, for example quay.io can create a robot account associated with your personal account.

## Related Content

* [Container Pipelines](https://github.com/redhat-cop/container-pipelines) - A set of Jenkins piplines for OpenShift
* [Labs CI/CD](https://github.com/rht-labs/labs-ci-cd) - A comprehensive end to end pipeline using many modern testing and quality tools. Suitable for OpenShift v3.x
* [Labs Ubiquitous Journey](https://github.com/rht-labs/ubiquitous-journey) - (The New and Improved _Labs CI/CD_ using GitOps for OpenShift v4.x) A collection of ArgoCD apps for:
  *  Boostrapping a cluster with some projects, roles, bindings and creating an ArgoCD instance using the Operator
  *  Deployments for an end to end pipeline using many modern testing and quality tools such as Jenkins, Nexus, Sonarqube etc
  *  Project management tooling such as Wekan and Mattermost Chat
* [Labs Helm Charts](https://github.com/rht-labs/helm-charts) - A library of OpenShift ready Helm3 Charts
* [OpenShift Templates](https://github.com/rht-labs/openshift-templates) - A library of OpenShift template examples & references
* [OpenShift Applier](https://github.com/redhat-cop/openshift-applier) - An automation framework for keeping manifests and templates applied to a cluster

## Contributing

Checkout out our [contribution guide](./CONTRIBUTING.md) for more details on how to contribute content to this repo.
