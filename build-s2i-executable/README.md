# S2I Image for Running an Executable artifact

Source to Image (S2I) compatible image for running an existing executable artifact

## Quickstart

1. Clone this repository:
   `git clone https://github.com/redhat-cop/containers-quickstarts`
2. `cd containers-quickstarts/build-s2i-executable`
3. Run `ansible-galaxy install -r requirements.yml --roles-path=roles`
4. Login to Openshift: `oc login -u <username> https://master.example.com:8443`
5. Run openshift-applier: `ansible-playbook -i .applier/hosts roles/openshift-applier/playbooks/openshift-cluster-seed.yml`


## Overview

Source to Image (S2I) builder for assembling an image that executes a file as part of container execution.

This repo contains both a `Dockerfile` for building the image.

## Bill of Materials

The requirements of this image are simple. All you need are:

* An OpenShift or Minishift cluster
* A git repo with static content in it
* [OpenShift Applier](https://github.com/redhat-cop/openshift-applier) to build the image. As a result you'll need to have [ansible installed](http://docs.ansible.com/ansible/latest/intro_installation.html).

## OpenShift objects

The openshift-applier will create the following OpenShift objects:
* A Project named `build-s2i-executable` 
* Two ImageStreams named `rhel7`, `build-s2i-executable` (see [.openshift/template/build-s2i-executable.yml](.openshift/templates/build-s2i-executable.yml)).
* One BuildConfig named `build-s2i-executable` (see [.openshift/template/build-s2i-executable.yml](.openshift/templates/build-s2i-executable.yml)).

## Environment Variables

The following environment variables can tune the functionality of the image. These variables can be used in both the build and runtime of the image. 

| Variable Name | Default Value | Description |
| ------------- | ------------- | ----------- |
| `RUNTIME_DIRECTORY` | `/app` | Directory containing the executable file |
| `EXECUTABLE_ARGS` |  | Arguments to pass as part of the call to the executable file |

## Pulling the Image

This image is available from [Quay](https://quay.io):

```
docker pull redhatcop/build-s2i-executable
```

## Building the Image

```
docker build -t redhatcop/build-s2i-executable .
```

## Cleaning up
`oc delete project build-s2i-executable`
