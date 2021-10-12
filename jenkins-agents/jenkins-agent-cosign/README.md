# Jenkins Cosign Agent

This agent extends the base jenkins agent image and adds the cosign binary. We can use this agent image in a Jenkins pipeline to sign images we build through the pipeline.

## Build in OpenShift
```bash
oc process -f ../../.openshift/templates/jenkins-agent-generic-template.yml \
    -p NAME=jenkins-agent-cosign \
    -p SOURCE_CONTEXT_DIR=jenkins-agents/jenkins-agent-cosign \
    -p DOCKERFILE_PATH=Dockerfile \
    | oc create -n openshift -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-agent-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-agent-generic-template.yml`.