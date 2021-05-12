# jenkins-agent-golang
Provides a docker image of the golang runtime for use as a Jenkins agent.

## Build local
```
docker build -t jenkins-agent-golang .
```
## Run local
For local running and experimentation run `docker run -it --entrypoint bash jenkins-agent-golang` and have a play once inside the container.

## Build in OpenShift
```bash
oc process -f ../../.openshift/templates/jenkins-agent-generic-template.yml \
    -p NAME=jenkins-agent-golang \
    -p SOURCE_CONTEXT_DIR=jenkins-agents/jenkins-agent-golang \
    | oc create -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-agent-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-agent-generic-template.yml`.

## Build with a custom Go version
A default Go version is specified in the [Dockerfile](Dockerfile). If desirable, a custom version of Go can be set at build time.

```
docker build --build-arg GO_VERSION=1.10.2 -t jenkins-agent-golang .
```
Or if you're using an Openshift buildconfig, the Go version can be set with [buildArgs](https://docs.openshift.com/container-platform/latest/builds/build-strategies.html#builds-strategy-docker-build-arguments_build-strategies)

## Jenkins
Add a new Kubernetes Container template called `jenkins-agent-golang` (if you've build and pushed the container image locally) and specify this as the node when running builds. If you're using the template attached; the `role: jenkins-agent` is attached and Jenkins should automatically discover the agent for you. Further instructions can be found [here](https://docs.openshift.com/container-platform/latest/openshift_images/using_images/images-other-jenkins.html#images-other-jenkins-kubernetes-plugin_images-other-jenkins). There are path issues with Jenkins permissions and Go when trying to run a build so easiest way to fix this is to setup the GOLANG path to be same as the WORKSPACE
```
export GOPATH=${WORKSPACE}
go get -v -t ./...
go build -v
# if there are Ginkgo tests then also run this!
$GOPATH/bin/ginkgo -r --cover -keepGoing
```
