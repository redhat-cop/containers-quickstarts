# jenkins-slave-erlang
Provides a docker image of the erlang runtime for use as a Jenkins slave.

## Build local
`docker build -t jenkins-slave-erlang .`

## Run local
For local running and experimentation run `docker run -i -t jenkins-slave-erlang /bin/bash` and have a play once inside the container.

## Build in OpenShift
```bash
oc process -f ../../.openshift/templates/jenkins-slave-generic-template.yml \
    -p NAME=jenkins-slave-erlang \
    -p SOURCE_CONTEXT_DIR=jenkins-slaves/jenkins-slave-erlang \
    | oc create -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-slave-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-slave-generic-template.yml`.

## Jenkins
Add a new Kubernetes Container template called `jenkins-slave-erlang` (if you've build and pushed the container image locally) and specify this as the node when running builds. If you're using the template attached; the `role: jenkins-slave` is attached and Jenkins should automatically discover the slave for you. Further instructions can be found [here](https://docs.openshift.com/container-platform/3.7/using_images/other_images/jenkins.html#using-the-jenkins-kubernetes-plug-in-to-run-jobs).
