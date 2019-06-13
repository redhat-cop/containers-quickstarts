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

Edit `.applier/group_vars/seed-hosts.yml` to match your environment requirements.

Run the openshift-applier to create the `ipa` project and deploy required objects
```
ansible-playbook -i ./applier roles/openshift-applier/playbooks/openshift-cluster-seed.yml
```
