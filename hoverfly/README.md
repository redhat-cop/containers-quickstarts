# Hoverfly

A simple container to run [hoverfly](https://hoverfly.readthedocs.io/en/latest/pages/reference/api/api.html). 

## Usage

### Running in OpenShift

https://github.com/redhat-cop/openshift-applier[OpenShift Applier]

Run the following to pull in applier:

....
ansible-galaxy install -r requirements.yml -p galaxy
....

Now, deploy to your openshift cluster:

....
oc login <dev cluster>
ansible-playbook -i .applier/ galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml
....

### Uploading Simulation Files in OpenShift

`$ curl -X PUT <hoverfly-admin-route>/api/v2/simulation --upload-file <file-name>`

See [the docs](https://docs.hoverfly.io/en/latest/pages/reference/api/api.html) for detail


### Running and Uploading in Docker

Running in standalone docker is not an objective for this container. Look at [this issue](https://github.com/SpectoLabs/hoverfly/issues/675) in hoverfly or just [run the binary locally](https://docs.hoverfly.io/en/latest/pages/introduction/downloadinstallation.html) without a container. It's a Go binary, so it's easy.

### Runtime Environment Variables

- `RUN_AS_WEBSERVER`: if set to any value, the hoverfly will start as a webserver. defaults to running as a proxy
