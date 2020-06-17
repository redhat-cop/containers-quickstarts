# Jenkins Conftest Agent 🦇

This slave extends the base jenkins slave image and adds the following binaries to be able to execute [Open Policy Agent](https://openpolicyagent.org) conftests in a pipeline:
 - [conftest](https://conftest.dev/) 
 - [yq](https://pypi.org/project/yq/)
 - [bats](https://github.com/bats-core/bats-core)

## Build in OpenShift
```bash
oc process -f ../../.openshift/templates/jenkins-slave-generic-template.yml \
    -p NAME=jenkins-slave-rego \
    -p SOURCE_CONTEXT_DIR=jenkins-slaves/jenkins-slave-rego \
    -p DOCKERFILE_PATH=Dockerfile \
    | oc create -n openshift -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-slave-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-slave-generic-template.yml`.
