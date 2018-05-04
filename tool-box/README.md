# Tool Box

This container exists to help folks that can't install ansible, git or other necessary tools. It is not to be used in any time of production setting and is not suppportable under an OpenShift subscription. 

## What's in the box?

- `oc` version 3.9.14
- `ansible` 2.5 (stable from `pip`)
- `git`
- `tree`
- `unzip`

If you need something not here, let us know in an issue or submit a PR.

## Usage

### OpenShift

Assuming you have the [CLI installed](https://docs.openshift.com/container-platform/latest/cli_reference/get_started_cli.html)

Build the container and deploy it in OpenShift:

`$ oc new-app https://github.com/rht-labs/labs-ci-cd --name=tool-box --context-dir=docker/tool-box`

Wait for the build to finish and the container to deploy. You can now log into the terminal via the pod web console.

If you want to shell in from your terminal, query the running pods:

`$ oc get pods -l app=tool-box`

Copy the NAME of the `tool-box` pod and then remote shell into it:

`$ oc rsh <NAME>`

### Docker

Clone this repo:

`$ git clone https://github.com/rht-labs/labs-ci-cd`

Build the container:

`[labs-ci-cd/docker/tool-box]$ docker build -t tool-box .`

Run the container in the background, then shell into. There are important things the container does at boot that you don't want to override. If you need sudo for docker:

`$ sudo docker exec -it $(sudo docker run -d tool-box) /bin/bash`

If you don't need sudo:

`$ docker exec -it $(docker run -d tool-box) /bin/bash`
