## Notes

The primary use case for this buildconfig and imagestream is to install a custom Ansible Tower image using the official Tower container image as its base.

This example adds several dependencies from pip and a single RPM from EPEL to demonstrate how to load a custom Tower image to your OCP internal image registry.

The official docs which outline how to consume this deploy Ansible Tower with a custom image can be found at:

https://docs.ansible.com/ansible-tower/3.8.2/html/administration/openshift_configuration.html#build-custom-virtual-environments

Note that this has been tested with Ansible Tower 3.8.1 and 3.8.2

The example contains a BuildConfig and ImageStream which shows how you might add dependencies to your Tower container such as pandoc, or a custom Python virtualenv.

Currently this example only has 3 configurable parameters, as shown below:

## Example Parameters

| **Option**   |      **Value**    |  
|----------|:-------------:|
| `TOWER_IMAGE` | registry.redhat.io/ansible-tower-38/ansible-tower-rhel7 |
| `TOWER_IMAGE_VERSION` | 3.8.2 |
| `OC_CLIENT_VERSION` | 4.6 |

## Prerequisites

The following prerequisites must be met prior to beginning to deploy the Ansible Tower custom image for OCP 4.x

* OpenShift Command Line Tool
* [Openshift Applier](https://github.com/redhat-cop/openshift-applier/) to deploy custom Ansible Tower base image. As a result you'll need to have [ansible installed](http://docs.ansible.com/ansible/latest/intro_installation.html)

### Environment Setup

1. Clone this repository: `git clone https://github.com/redhat-cop/containers-quickstarts`
2. `cd containers-quickstarts/tower-ocp-custom`
3. Run `ansible-galaxy install -r requirements.yml --roles-path=galaxy`
4. Login to OpenShift: `oc login -u <username> --server=https://api.<example.com>:6443`

### Create the custom Ansible Tower image with Openshift Applier

Run the openshift-applier to create the `tower-ocp` project and deploy required objects

```bash
ansible-playbook -i ./inventory galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml
```

### Cleaning up

```bash
oc delete project tower-ocp
```
