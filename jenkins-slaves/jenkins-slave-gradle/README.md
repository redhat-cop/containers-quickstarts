# jenkins-slave-gradle
Provides a docker image of the gradle runtime for use as a Jenkins slave.

## Build
`docker build -t jenkins-slave-gradle .`

## Build in OpenShift
```bash
oc process -f ../../.openshift/templates/jenkins-slave-generic-template.yml \
    -p NAME=jenkins-slave-gradle \
    -p SOURCE_CONTEXT_DIR=jenkins-slaves/jenkins-slave-gradle \
    | oc create -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-slave-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-slave-generic-template.yml`.

## Run
For local running and experimentation run `docker run -i -t --rm jenkins-slave-gradle /bin/bash` and have a play once inside the container.

## Jenkins Running
Add a new Kubernetes Container template called `jenkins-slave-gradle` and specify this as the node when running builds. Set the version of Java you want to use and away you go!
```bash
export JAVA_HOME=/path/to/java/version
gradle clean build
```
