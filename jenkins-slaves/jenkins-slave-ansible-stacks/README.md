Jenkins Slave for Ansible Stacks
=============================

Jenkins [Slave](https://wiki.jenkins-ci.org/display/JENKINS/Distributed+builds) that enables various container and image management capabilities and is optimized for deployment to a Jenkins instance running in the OpenShift Container Platform.

## Primary Components

[ansible-stacks](https://github.com/rht-labs/ansible-stacks) - Ansible playbook and roles used to create stacks via push button infrastructure (PBI)

## Instantiate Template

A [template](../templates/jenkins-slave-ansible-stacks-template.json) is available providing the necessary OpenShift components to build and make the slave image available to be referenced by Jenkins.

Execute the following command to instantiate the template:

```
oc process -f ../templates/jenkins-slave-ansible-stacks-template.json | oc create -f-
```

Parameters may be passed to the template to specify:

* `ANSIBLE_YUM_REPO` (default rhel-7-server-ose-3.3-rpms) - Yum repository that provides ansible

* `ANSIBLE_STACKS_SOURCE_REPOSITORY_URL` (https://github.com/rht-labs/ansible-stacks.git) - SCM for ansible-stacks

* `ANSIBLE_STACKS_SOURCE_REPOSITORY_REF` (https://github.com/rht-labs/ansible-stacks.git) - SCM branch for ansible-stacks

* `CONTEXT_DIR` (jenkins-slaves/jenkins-slave-ansible-stacks) - Reference pointing to this directory for docker build.

* `SOURCE_REPOSITORY_URL` (https://github.com/redhat-cop/containers-quickstarts.git) - Source repo for docker build

* `SOURCE_REPOSITORY_REF` (master) - Source branch for docker build

A new image build will be started automatically

## Use within Jenkins

The template contains an *ImageStream* that has been configured with the appropriate labels that will be picked up by newly deployed Jenkins instances.

For existing Jenkins servers, the slave can be added by using the following steps.

1. Login to Jenkins
2. Click on **Manage Jenkins** and then **Configure System**
3. Under the *Cloud* section, locate the *Kubernetes* Plugin. Click the *Add Pod Template* dropdown and select **
4. Enter the following details
	1. Name: jenkins-slave-ansible-stacks
	2. Labels: jenkins-slave-ansible-stacks
	3. Docker image
		1. Using the `oc` command line, run `oc get is jenkins-slave-ansible-stacks --template='{{ .status.dockerImageRepository }}`. A value similar to *172.30.186.87:5000/jenkins/jenkins-slave-ansible-stacks* should be used
	4. Jenkins slave root directory: `/tmp`
5. Click **Save** to apply the changes
	

## Use within Jenkins Pipeline Script

The following provides an example of how to make use of the image within a Jenkins [pipeline](https://jenkins.io/doc/book/pipeline/) script to execute an ansible run using the `local-file.yml` ansible-stacks playbook:

```
node('jenkins-slave-ansible-stacks') { 

  stage('Create Project') {
    sh """
set +x

cd /tmp

cat >ansible.cfg <<EOF
[defaults]
roles_path = /opt/ansible-stacks/roles
EOF

cat >local-file.yml <<EOF
- name: "Load up the infrastructure..."
  hosts: localhost
  vars_files:
  - "{{ resource_file }}"
  roles:
  - role: openshift-defaults
  - role: create-openshift-resources
EOF

cat >resources.yml <<EOF
openshift_clusters:
- openshift_host_env: master.openshift.example.com:8443
  openshift_resources:
    projects:
    - name: example
      display_name: Ansible Stacks Example
      environment_type: build
openshift_user: username
openshift_password: password
EOF

ansible-playbook local-file.yml -e resource_file=resources.yml
    """
  }
}
```
