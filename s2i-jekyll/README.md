# S2I Image for Building Jekyll Sites

This image builds sites using [Jekyll](https://jekyllrb.com/).

## Requirements
This example is using the [OpenShift Applier](https://github.com/redhat-cop/openshift-applier) to build and deploy Jekyll. As a result you'll need to have [ansible installed](http://docs.ansible.com/ansible/latest/intro_installation.html).

## OpenShift objects
The openshift-applier will create the following OpenShift objects:
* A Project named `s2i-jekyll` (see [files/projects/projects.yml](files/projects/projects.yml))
* Three ImageStreams named `ruby`, `jekyll-builder` and `openshift-playbooks` (see [files/imagestreams/template.yml](files/imagestreams/template.yml).
* Two BuildConfigs named `jekyll-builder` and `openshift-playbooks` (see [files/builds/docker-template.yml](files/builds/docker-template.yml) and [files/builds/source-template.yml](files/builds/source-template.yml))
* A Service named `openshift-playbooks` (see [files/deployments/template.yml](files/deployments/template.yml))
* A Route named `openshift-playbooks` (see [files/deployments/template.yml](files/deployments/template.yml))
* A DeploymentConfig named `openshift-playbooks` (see [files/deployments/template.yml](files/deployments/template.yml))

## Quickstart

1. Clone this repository:
   `git clone https://github.com/redhat-cop/containers-quickstarts`
2. `cd containers-quickstarts/s2i-jekyll`
3. Run `ansible-galaxy install -r requirements.yml --roles-path=roles`
4. Login to Openshift: `oc login -u <username> https://master.example.com:8443`
5. Run openshift-applier: `ansible-playbook -i inventory/hosts roles/openshift-applier/playbooks/openshift-cluster-seed.yml`

Now we can `oc get routes` to get the hostname of the route that was just created, or click the link in the OpenShift Web Console, and test our newly published jekyll site.

>**_NOTE_**: This image is not intended to be used to serve the content provided by jekyll. It can do so, but is meant for testing purposes only. For hosting the html site produced by this image, consider using the [s2i-httpd image](/s2i-httpd/), or for someting even more light weight, check out our [Go Web Server](https://github.com/redhat-cop/gows).
