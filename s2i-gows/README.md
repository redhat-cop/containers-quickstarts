# S2I Image for GoWS - A Tiny Web Server

[GoWS](https://github.com/redhat-cop/gows) is a golang based static content web server.

## Quickstart

Here's a simple on-liner to get you started.

```
oc new-app redhatcop/s2i-gows~https://github.com/redhat-cop/containers-quickstarts.git --context-dir=s2i-gows/demo --name=gows-test
oc expose svc gows-test
```

## Overview

GoWS is a webserver built to do nothing more than to serve static content web sites on the smallest possible footprint. This S2I-enabled image makes this one step easier by being able to stream that content straight into the image from source.

This repo contains both a `Dockerfile` for building the image and a directory of [sample content](/s2i-gows/demo).

## Bill of Materials

The requirements of this image are simple. All you need are:

* An OpenShift or Minishift cluster
* A git repo with static content in it

## Environment Variables

This image supports a couple of simple environment variables for customizing directory locations.

### Build Vars
| Variable Name | Default Value | Description |
| --------------| ------------- | ----------- |
| `SRC_DIR` | `/opt/site/src`| Location to copy source from. This will not change where S2I clones the source to. Only change this value if what you are copying is a sub file or directory. |
| `GOWS_DIR` | `/opt/site/static` | Location to copy source to. This will be where content is served from. This must match the value of `GOWS_DIR` at runtime |

### Runtime Vars
| Variable Name | Default Value | Description |
| --------------| ------------- | ----------- |
| `GOWS_DIR` | `/opt/site/static` | Location to serve static content from |

## Pulling the Image

This image is available from Docker cloud:

```
docker pull redhatcop/s2i-gows
```

## Building the Image

```
cd ./image
docker build -t redhatcop/s2i-gows .
```
