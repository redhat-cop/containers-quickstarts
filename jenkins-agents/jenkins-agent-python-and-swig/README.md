# jenkins-agent-python-and-swig
Provides a docker image of a runtime including both Python and C++ for use as a Jenkins agent.

## Build local
`docker build -t jenkins-agent-python-and-swig .`

## Run local
For local running and experimentation run `docker run -i -t jenkins-agent-python-and-swig /bin/bash` and have a play once inside the container.

## Build in OpenShift...
### ...from master:
```bash
oc process -f ../../.openshift/templates/jenkins-agent-generic-template.yml \
    -p NAME=jenkins-agent-python-and-swig \
    -p SOURCE_CONTEXT_DIR=jenkins-agents/jenkins-agent-python-and-swig \
    -p DOCKERFILE_PATH=Dockerfile \
    -p BUILDER_IMAGE_NAME=quay.io/openshift/origin-jenkins-agent-base:4.6 \
    | oc create -f -
```
### ...from another branch (to test it out):
```bash
oc process -f ../../.openshift/templates/jenkins-agent-generic-template.yml \
    -p NAME=jenkins-agent-python-and-swig \
    -p SOURCE_CONTEXT_DIR=jenkins-agents/jenkins-agent-python-and-swig \
    -p DOCKERFILE_PATH=Dockerfile \
    -p BUILDER_IMAGE_NAME=quay.io/openshift/origin-jenkins-agent-base:4.6 \
    -p SOURCE_REPOSITORY_REF=<your_branch_name> \
    | oc create -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-agent-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-agent-generic-template.yml`.

## Jenkins
Add a new Kubernetes Container template called `jenkins-agent-python-and-swig` (if you've build and pushed the container image locally) and specify this as the node when running builds. If you're using the template attached; the `role: jenkins-agent` is attached and Jenkins should automatically discover the agent for you. Further instructions can be found [here](https://docs.openshift.com/container-platform/3.7/using_images/other_images/jenkins.html#using-the-jenkins-kubernetes-plug-in-to-run-jobs). Python installation commands are slightly modified from the SCL versions, which can be found [here](https://github.com/sclorg/s2i-python-container/tree/master/3.6).
