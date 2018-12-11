# S2I Image for GoWS - A Tiny Web Server

[GoWS](https://github.com/redhat-cop/gows) is a golang based static content web server.

## Quickstart

1. Clone this repository:
   `git clone https://github.com/redhat-cop/containers-quickstarts`
2. `cd containers-quickstarts/build-s2i-gows`
3. Run `ansible-galaxy install -r requirements.yml --roles-path=roles`
4. Login to Openshift: `oc login -u <username> https://master.example.com:8443`
5. Run openshift-applier: `ansible-playbook -i inventory/hosts roles/openshift-applier/playbooks/openshift-cluster-seed.yml`

Now we can `oc get routes` to get the hostname of the route that was just created, or click the link in the OpenShift Web Console, and test our newly published gows site.
By default our simple [demo site](demo/index.html) will be deployed.

## Overview

GoWS is a webserver built to do nothing more than to serve static content web sites on the smallest possible footprint. This S2I-enabled image makes this one step easier by being able to stream that content straight into the image from source.

This repo contains both a `Dockerfile` for building the image and a directory of [sample content](/build-s2i-gows/demo).

## Bill of Materials

The requirements of this image are simple. All you need are:

* An OpenShift or Minishift cluster
* A git repo with static content in it
* [OpenShift Applier](https://github.com/redhat-cop/openshift-applier) to build and deploy Gows. As a result you'll need to have [ansible installed](http://docs.ansible.com/ansible/latest/intro_installation.html).

## OpenShift objects

The openshift-applier will create the following OpenShift objects:
* A Project named `s2i-gows` (see [files/projects/projects.yml](files/projects/projects.yml))
* Three ImageStreams named `golang`, `busybox` and `gows` (see [files/imagestreams/template.yml](files/imagestreams/template.yml) and [files/builds/gows.yml](files/builds/gows.yml)).
* Four BuildConfigs named `gows-build`, `gows-busybox`, `gows-s2i` and `gows` (see [files/builds/template.yml](files/builds/template.yml))
* A Service named `gows` (see [files/deployments/template.yml](files/deployments/template.yml))
* A Route named `gows` (see [files/deployments/template.yml](files/deployments/template.yml))

## Environment Variables

### Openshift Build Vars
The build supports a few environment variables to specify the source of the site. The default values can be changed by setting the variables below in the [params file](files/builds/params).

| Variable Name | Default Value | Description |
| ------------- | ------------- | ----------- |
| `SITE_CONTEXT_DIR` | `s2i-gows/demo` | Location of the site files within the git repository |
| `SITE_SOURCE_REPOSITORY_REF` | `master` | Git branch/tag of the site files |
| `SITE_SOURCE_REPOSITORY_URL` | `https://github.com/redhat-cop/containers-quickstarts` | Git repository of the site files |

### Docker Build Vars

This image supports a couple of simple environment variables for customizing directory locations.

| Variable Name | Default Value | Description |
| --------------| ------------- | ----------- |
| `SRC_DIR` | `/opt/site/src`| Location to copy source from. This will not change where S2I clones the source to. Only change this value if what you are copying is a sub file or directory. |
| `GOWS_DIR` | `/opt/site/static` | Location to copy source to. This will be where content is served from. This must match the value of `GOWS_DIR` at runtime |

### Docker Runtime Vars

| Variable Name | Default Value | Description |
| --------------| ------------- | ----------- |
| `GOWS_DIR` | `/opt/site/static` | Location to serve static content from |

## Pulling the Image

This image is available from Docker cloud:

```
docker pull redhatcop/build-s2i-gows
```

## Building the Image

```
cd ./image
docker build -t redhatcop/build-s2i-gows .
```

## Cleaning up
`oc delete project s2i-gows`
