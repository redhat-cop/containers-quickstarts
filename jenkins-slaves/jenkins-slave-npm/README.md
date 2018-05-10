# jenkins-slave-npm
Provides a docker image of the nodejs v6 runtime with npm for use as a Jenkins slave.

## Build
`docker build -t jenkins-slave-npm .`

## Build in OpenShift
```bash
oc process -f ../templates/jenkins-slave-generic-template.yml \
    -p NAME=jenkins-slave-npm \
    -p SOURCE_CONTEXT_DIR=jenkins-slaves/jenkins-slave-npm \
    | oc create -f -
```
For all params see the list in the `../templates/jenkins-slave-generic-template.yml` or run `oc process --parameters -f ../templates/jenkins-slave-generic-template.yml`.

## Run
For local running and experimentation run `docker run -i -t --rm jenkins-slave-npm /bin/bash` and have a play once inside the container.

## Jenkins Running
Add a new Kubernetes Container template called `jenkins-slave-npm` and specify this as the node when running builds. 
```
scl enable rh-nodejs6 'npm install'
scl enable rh-nodejs6 'npm run build'
```
