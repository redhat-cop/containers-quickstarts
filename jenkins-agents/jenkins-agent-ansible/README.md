# Jenkins Ansible Agent

This is a Jenkins Agent designed to run in OpenShift as described [here](https://docs.openshift.com/container-platform/3.11/using_images/other_images/jenkins.html#using-the-jenkins-kubernetes-plug-in). The agent should stay in sync with [the openshift applier image](https://github.com/redhat-cop/openshift-applier/tree/master/images/openshift-applier) in order to provide a common runtime environment.

Provides a docker image with ansible for use as a Jenkins agent.

## Build local
`docker build -t jenkins-agent-ansible .`

## Run local
For local running and experimentation run `docker run -i -t jenkins-agent-ansible /bin/bash` and have a play once inside the container.

## Build in OpenShift
```bash
oc process -f ../../.openshift/templates/jenkins-agent-generic-template.yml \
    -p NAME=jenkins-agent-ansible \
    -p SOURCE_CONTEXT_DIR=jenkins-agents/jenkins-agent-ansible \
    | oc create -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-agent-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-agent-generic-template.yml`.

## Jenkins
Add a new Kubernetes Container template called `jenkins-agent-ansible` (if you've build and pushed the container image locally) and specify this as the node when running builds. If you're using the template attached; the `role: jenkins-agent` is attached and Jenkins should automatically discover the agent for you. Further instructions can be found [here](https://docs.openshift.com/container-platform/3.10/using_images/other_images/jenkins.html#using-the-jenkins-kubernetes-plug-in). 

```
$ oc run ansible-agent -i -t --image=docker-registry.default.svc:5000/ansible-agent/jenkins-agent-ansible --command -- ansible --version
If you don't see a command prompt, try pressing enter.
  ansible 2.5.8
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/home/jenkins/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.5 (default, May 31 2018, 09:41:32) [GCC 4.8.5 20150623 (Red Hat 4.8.5-28)]
Session ended, resume using 'oc attach ansible-agent-1-wcbxv -c ansible-agent -i -t' command when the pod is running
```
