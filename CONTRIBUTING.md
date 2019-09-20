# Contribution Guide

In the context of this repo, a _Quickstart_ is a collection of manifests, OpenShift templates, images that can be used to easily build and/or deploy a piece of software to OpenShift. Each quickstart should be independently consumable and user friendly.

| NOTE: If you have some interesting manifests or templates you would like to contribute as examples or references and they do not fit the description of a _quickstart_, please contribute them to https://github.com/rht-labs/openshift-templates |
| --- |

## Guiding Principles for Writing a Quickstart

In general, a good quickstart should:

- Serve as a standalone example of some sort of deployment to OpenShift
- Have comprehensive, clear documentation
- Follow the standard structure documented below
- Be automated using [OpenShift Applier](https://github.com/redhat-cop/openshift-applier)

## Structure of a QuickStart

This documents the expected directory structure of a Quickstart.

```
/<name of tech being deployed/
  README.md - Please include a comprehensive README documenting the use case for this quickstart (see below of readme guidance)
  .applier/ - inventory for deploying said quickstart via openshift-applier
  .openshift/ - manifests, templates, and parameters
  requirements.yml - ansible-galaxy requirements file.
  Dockerfile
```

## Guidance for Quickstart README

Good documentation is key to a good quickstart. Helping a consumer quickly understand the purpose of your quickstart and how to deploy it will make it more widely consumable to the community. We are constantly trying to achieve more consistency across quickstart documentation to make for a better user experience. With that in mind, we've put together the following starter skeleton for a quickstart README.

```
# Technology X on OpenShift

Provide a brief description of the technology being deployed, and a link to more info about this technology.

## Prerequisites & Assumptions

Describe the tools, environments, and assumed skills needed to understand the quickstart

## Deploy Quickstart

As briefly as possible, walk through the steps to deploy. Ideally this step should just be the commands for running the openshift-applier inventory

## Architecture and Details

Please include a deeper explanation of the resources that get deployed and some demonstrable features of this deplyment.
```

## Opening a Pull Request

We follow a standard open source forking workflow in this repo. Please see the [Red Hat Communities of Practice Contribution Guide](https://redhat-cop.github.io/contrib/) for a walkthrough of this workflow.
