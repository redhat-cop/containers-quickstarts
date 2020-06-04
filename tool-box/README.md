[![Docker Repository on Quay](https://quay.io/repository/redhat-cop/tool-box/status "Docker Repository on Quay")](https://quay.io/repository/redhat-cop/tool-box)

# Tool Box 🧰

This container exists to help people that can't install ansible, git or other necessary tools locally. It is not to be used in any type of production setting and is not suppportable under an OpenShift subscription.

## What's in the box? 👱‍♂

- `oc` version 4.4.7
- `ansible` v2.9 (stable from `pip`)
- `python` v3.6
- `git` 2.18.4
- `unzip` 6.0-43
- `jq` v1.6
- `odo` 1.2.1
- `helm` Client v3.2.1
- `tkn` Client v0.9.0

If you need something not here, let us know in an issue or submit a PR.

## Usage

### OpenShift

Assuming you have the [CLI installed](https://docs.openshift.com/container-platform/3.11/cli_reference/get_started_cli.html)

Build the container and deploy it in OpenShift:

`$ oc run -i -t tool-box-test --image=quay.io/redhat-cop/tool-box --rm bash`

### Docker

Run the container in the background, then shell into. There are important things the container does at boot that you don't want to override. If you need sudo for docker:

`$ sudo docker run -it tool-box /bin/bash`

If you don't need sudo:

`$ docker run -it tool-box /bin/bash`

## Building the Image

This image is available publicly at `quay.io/redhat-cop/tool-box`, so there's no need to build it yourself. If you need to build it for development reasons, here's how.

### With Docker

Clone this repo:

`$ git clone https://github.com/redhat-cop/containers-quickstarts`

Build the container:

`[containers-quickstarts/tool-box]$ docker build -t tool-box .`

### In OpenShift

`oc new-build https://github.com/redhat-cop/containers-quickstarts --name=tool-box --context-dir=tool-box`
