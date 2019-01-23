## Prerequisites

The following prerequisites must be met prior to beginning to deploy [Zalenium](https://opensource.zalando.com/zalenium/) (A container based Selenium Grid)

* 1 [Persistent Volumes](https://docs.openshift.com/container-platform/latest/architecture/additional_concepts/storage.html) or a cluster that supports [dynamic provisioning with a default StorageClass](https://docs.openshift.com/container-platform/latest/install_config/storage_examples/storage_classes_dynamic_provisioning.html)
* OpenShift Command Line Tool
* [Openshift Applier](https://github.com/redhat-cop/openshift-applier/) to deploy GitLab CE. As a result you'll need to have [ansible installed](http://docs.ansible.com/ansible/latest/intro_installation.html)


### Environment Setup

1. Clone this repository: `git clone https://github.com/redhat-cop/containers-quickstarts`
2. `cd containers-quickstarts/zalenium`
3. Run `ansible-galaxy install -r requirements.yml --roles-path=galaxy`
4. Login to OpenShift: `oc login -u <username> https://master.example.com:8443`

### Deploy Zalenium

Run the openshift-applier to create the `zalenium` project and deploy required objects
```
ansible-playbook -i .applier galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml
```

### Next steps

Access your Zalenium:
* Life Dashboard of ongoing tests:
http://zalenium-zalenium.apps.example.com/grid/admin/live?refresh=20
* Recordings of previous tests:
http://zalenium-zalenium.apps.example.com/dashboard/#

Run simple test from your local machine:
1. Setup [Protractor](https://www.protractortest.org/#/tutorial#setup): `npm install -g protractor`
2. Get into test directory `cd example-tests/protractor`
3. Edit the `conf.js` -file to point to your own Zalenium instance
4. Inspect the `simple-test.js` -file. It will just quickly access Angular.Js -website and make a post to their TODO example.
5. Run the tests with: `protractor conf.js`