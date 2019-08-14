## Prerequisites

The following prerequisites must be met prior to beginning to deploy GitLab CE

* 4 [Persistent Volumes](https://docs.openshift.com/container-platform/3.11/architecture/additional_concepts/storage.html) or a cluster that supports [dynamic provisioning with a default StorageClass](https://docs.openshift.com/container-platform/3.11/install_config/storage_examples/storage_classes_dynamic_provisioning.html)
* OpenShift Command Line Tool
* Custom SSL certificates must be generated in advance in order to provide those to the deployment process
* [Openshift Applier](https://github.com/redhat-cop/openshift-applier/) to deploy GitLab CE. As a result you'll need to have [ansible installed](http://docs.ansible.com/ansible/latest/intro_installation.html)


### Environment Setup

1. Clone this repository: `git clone https://github.com/redhat-cop/containers-quickstarts`
2. `cd containers-quickstarts/gitlab-ce`
3. Run `ansible-galaxy install -r requirements.yml --roles-path=galaxy`
4. Login to OpenShift: `oc login -u <username> https://master.example.com:8443`

:heavy_exclamation_mark: GitLab CE container will run under a replica of `anyuid` SCC. Ensure you are logged into the Cluster (step 4) with an user with privileges to create SecurityContextConstraints with the required scope.

### Deploy Gitlab CE

Adecuate `.applier/group_vars/seed-hosts.yml` to match your environment requirements.

#### Custom SSL Certificates:

Custom certificates must be provided during deployment phase.

In order to provide custom certificates, `SSL_CERTIFICATE` and `SSL_KEY` variables must be provided on `.applier/group_vars/seed-hosts.yml`, adding each certificate in *base64* format to the corresponding parameter.

Run the openshift-applier to create the `gitlab` project and deploy required objects
```
ansible-playbook -i ./inventory galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml
```
