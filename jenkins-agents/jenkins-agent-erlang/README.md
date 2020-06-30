# jenkins-agent-erlang
Provides a docker image of the erlang runtime for use as a Jenkins agent.

## Build local
`docker build -t jenkins-agent-erlang .`

## Run local
For local running and experimentation run `docker run -i -t jenkins-agent-erlang /bin/bash` and have a play once inside the container.

## Build in OpenShift
```bash
oc process -f ../../.openshift/templates/jenkins-agent-generic-template.yml \
    -p NAME=jenkins-agent-erlang \
    -p SOURCE_CONTEXT_DIR=jenkins-agents/jenkins-agent-erlang \
    | oc create -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-agent-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-agent-generic-template.yml`.

## Jenkins
Add a new Kubernetes Container template called `jenkins-agent-erlang` (if you've build and pushed the container image locally) and specify this as the node when running builds. If you're using the template attached; the `role: jenkins-agent` is attached and Jenkins should automatically discover the agent for you. Further instructions can be found [here](https://docs.openshift.com/container-platform/3.7/using_images/other_images/jenkins.html#using-the-jenkins-kubernetes-plug-in-to-run-jobs).
