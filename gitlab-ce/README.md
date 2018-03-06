## Prerequisites

The following prerequisites must be met prior to beginning to deploy Gogs

* 4 [Persistent Volumes](https://docs.openshift.com/container-platform/latest/architecture/additional_concepts/storage.html) or a cluster that supports [dynamic provisioning with a default StorageClass](https://docs.openshift.com/container-platform/latest/install_config/storage_examples/storage_classes_dynamic_provisioning.html)
* OpenShift Command Line Tool
* [Openshift Applier](https://github.com/redhat-cop/casl-ansible/tree/master/roles/openshift-applier) to deploy Gogs. As a result you'll need to have [ansible installed](http://docs.ansible.com/ansible/latest/intro_installation.html)


### Environment Setup

1. Clone this repository: `git clone https://github.com/redhat-cop/containers-quickstarts`
2. `cd containers-quickstarts/gitlab-ce`
3. Run `ansible-galaxy install -r requirements.yml --roles-path=roles`
4. Login to OpenShift: `oc login -u <username> https://master.example.com:8443`

### Deploy Gitlab CE

Run the openshift-applier to create the `gitlab` project and deploy required objects
```
ansible-playbook -i ./inventory roles/casl-ansible/playbooks/openshift-cluster-seed.yml
