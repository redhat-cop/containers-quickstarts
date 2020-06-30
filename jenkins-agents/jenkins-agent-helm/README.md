# Jenkins Helm Agent

This agent extends the base jenkins agent image and adds the helm binary. We can use this agent image in a Jenkins pipeline to perform helm operations in projects.

## Build in OpenShift
```bash
oc process -f ../../.openshift/templates/jenkins-agent-generic-template.yml \
    -p NAME=jenkins-agent-helm \
    -p SOURCE_CONTEXT_DIR=jenkins-agents/jenkins-agent-helm \
    -p DOCKERFILE_PATH=Dockerfile \
    | oc create -n openshift -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-agent-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-agent-generic-template.yml`.
