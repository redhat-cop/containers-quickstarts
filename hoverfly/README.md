# Hoverfly

A simple container to run [hoverfly](https://docs.hoverfly.io/en/latest/). 

TODO create a template

## Usage

### Running in OpenShift

Build the container and deploy it in openshift:

`$ oc new-app https://github.com/rht-labs/labs-ci-cd --name=hoverfly --context-dir=docker/hoverfly`

Expose the proxy/webserver port

`$ oc expose svc hoverfly --port 8500`

Expose the admin interface, including the rest API

`$ oc expose svc hoverfly --port 8888 --name hoverfly-admin`


### Uploading Simulation Files in OpenShift

`$ curl -X PUT <hoverfly-admin-route>/api/v2/simulation --upload-file <file-name>`

See [the docs](https://docs.hoverfly.io/en/latest/pages/reference/api/api.html) for detail


### Running and Uploading in Docker

Running in standalone docker is not an objective for this container. Look at [this issue](https://github.com/SpectoLabs/hoverfly/issues/675) in hoverfly or just [run the binary locally](https://docs.hoverfly.io/en/latest/pages/introduction/downloadinstallation.html) without a container. It's a Go binary, so it's easy.

### Runtime Environment Variables

- `RUN_AS_WEBSERVER`: if set to any value, the hoverfly will start as a webserver. defaults to running as a proxy
