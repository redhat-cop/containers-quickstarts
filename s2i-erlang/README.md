# S2I Image for Building Erlang applications using Rebar3

This image builds [Erlang](https://erlang.org) applications using [Rebar3](https://rebar3.org)

## Requirements
This example is using the [OpenShift Applier](https://github.com/redhat-cop/openshift-applier) to build and deploy Erlang applications. As a result you'll need to have [ansible installed](http://docs.ansible.com/ansible/latest/intro_installation.html)

The s2i image is also expecting that you're using a [Rebar3 release](https://www.rebar3.org/docs/releases), e.g. there's a `{relx, [{release, {<release name>, <vsn>},}]}` line in your `rebar.config` file.

## OpenShift objects
The openshift-applier will create the following OpenShfit objects:
* A Project named `s2i-erlang` (see [.openshift/projects/projects.yml](.openshift/projects/projects.yml))
* Two ImageStreams named `erlang-builder` and `erlang-cowboy-rest` (see [.openshift/templates/is.yml](.openshift/templates/is.yml))
* Two BuildConfigs named `erlang-builder` and `erlang-cowboy-rest` (see [.openshift/templates/bc.yml](.openshift/templates/is.yml))
* A Service named `erlang-cowboy-rest` (see [.openshift/templates/dc.yml](.openshift/templates/dc.yml))
* A Route named `erlang-cowboy-rest` (see [.openshift/templates/dc.yml](.openshift/templates/dc.yml))
* A DeploymentConfig named `erlang-cowboy-rest` (see [.openshift/templates/dc.yml](.openshift/templates/dc.yml))

## Quickstart
1. Clone this repository:
   `git clone https://github.com/redhat-cop/containers-quickstarts`
2. `cd containers-quickstarts/s2i-erlang`
3. Run `ansible-galaxy install -r requirements.yml --roles-path=.applier/roles`
4. Login to Openshift: `oc login -u <username> https://master.example.com:8443`
5. Run openshift-applier: `ansible-playbook -i .applier/inventory/hosts .applier/roles/openshift-applier/playbooks/openshift-cluster-seed.yml`

Now we can `oc get routes` to get the hostname of the route that was just created, or click the link in the OpenShift Web Console, and test our newly created Erlang application.

## Known issues
We are currently using a builder-image based on the `centos/s2i-base-centos7`. There's also a builder-image based on `rhscl/s2i-base-rhel7:1` but it is currently failing to build. We're hoping to have this issue resolved in the near future.
