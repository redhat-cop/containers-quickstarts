## Prerequisites

This app has the following prereq:

* OpenShift Command Line Tool
* [Openshift Applier](https://github.com/redhat-cop/openshift-applier/). As a result you'll need to have [ansible installed](http://docs.ansible.com/ansible/latest/intro_installation.html)
* The permissions to grant an SA the anyuid scc.

### Environment Setup

1. Clone this repository: `git clone https://github.com/redhat-cop/containers-quickstarts`
2. `cd containers-quickstarts/ipa-server`
3. Run `ansible-galaxy install -r requirements.yml --roles-path=roles`
4. Login to OpenShift: `oc login -u <username> https://console.example.com:8443`

:heavy_exclamation_mark: freeipa-server container will run under a replica of `anyuid` SCC. You should ensure you are logged into the Cluster (step 4) with an user with privileges to create SecurityContextConstraints with the required scope

### Deploy freeipa-server

Edit `.applier/group_vars/seed-hosts.yml` to match your environment requirements. See below for explanation of specific parameters.

Run the openshift-applier to create the `ipa` project and deploy required objects
```
ansible-playbook -i ./applier roles/openshift-applier/playbooks/openshift-cluster-seed.yml
```

### Parameters

namespace: name of the project to create (and deploy to)
app_name: name of what you would like to call your app. This will create the app at a route called <app>.example.com
base_openshift_url: the base of the url that the app will be created at. (i.e. if your apps are created at myapp.apps.mycluster.com, the base_openshift_url should be apps.mycluster.com)
realm: the realm that you would like to create inside of IdM (i.e. EXAMPLE.COM)
admin_password: admin password for login
openshift_templates_version: version of the openshift_templates repo to use (i.e. vX.Y.Z)
ipa_templates_version: version of the https://github.com/freeipa/freeipa-container repo to use (right now this is an appropriate git hash)
deployment_timeout: number of seconds before the deployment container times out

### :heavy_exclamation_mark: Warnings and Common Errors :heavy_exclamation_mark:

- The first deployment of this can take a _very long_ time (potentially up to 10 minutes. This is why you'll see the deployment_timeout defaulted to 1000 seconds (16 minutes?). It likely won't take the full time, but can at times come close. Subsequent runs are just a handful of minutes due to the fact that the image is already in place and the install has already taken place (so everything that is required is already in place on the pvc).
- Occasionally this will run over your deployment_timeout and you'll see the deploy container enters an `Error` state and you'll see that the app container enters a `Terminating` state. This can happen for a number of reasons (connection, etc.), but can likely be remedied just by redeploying (and/or increasing the deployment_timeout parameter).
- Currently there is an issue with idempotency of running this multiple times. This is due to the fact that the template that we're relying on sets a `ClusterIP`, which cannot be done if it's already set. In order to redeploy this, the best way is to just delete the objects that the deployment template creates and then redeploy.
- The last issue that we're seeing right now pertains specifically to OCP 4.X. In order to run IdM, it expects that the SELinux Boolean `container_manage_cgroup` is `on`. The current workaround for this is to create a `machineconfig` that creates a systemd file that will run the `setsebool` command. This can be found [here](.openshift/files/01-worker-sebool.yml) and can be run by providing the following `include_tag` to the applier: `-e 'include_tag=ipa_machineconfig'`. This should be done before proceeding with a full run of this quickstart if necessary.
