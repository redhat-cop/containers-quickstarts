# jenkins-slave-golang
Provides a docker image of the golang runtime for use as a Jenkins slave.

## Build local
`docker build -t jenkins-slave-golang .`

## Run local
For local running and experimentation run `docker run -i -t jenkins-slave-golang /bin/bash` and have a play once inside the container.

## Build in OpenShift
```bash
oc process -f ../../.openshift/templates/jenkins-slave-generic-template.yml \
    -p NAME=jenkins-slave-golang \
    -p SOURCE_CONTEXT_DIR=jenkins-slaves/jenkins-slave-golang \
    | oc create -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-slave-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-slave-generic-template.yml`.

## Jenkins
Add a new Kubernetes Container template called `jenkins-slave-golang` (if you've build and pushed the container image locally) and specify this as the node when running builds. If you're using the template attached; the `role: jenkins-slave` is attached and Jenkins should automatically discover the slave for you. Further instructions can be found [here](https://docs.openshift.com/container-platform/4.4/openshift_images/using_images/images-other-jenkins.html#images-other-jenkins-config-kubernetes_images-other-jenkins).

## Modules
Given that Golang has decided to move towards modules for dependency management, [dep](https://github.com/golang/dep) has been removed in favor of native module functionality, available since Go v1.11. Visit the [Go blog](https://blog.golang.org/using-go-modules) to learn how you can get started with modules.