# jenkins-agent-mongodb
Provides a docker image of the mongodb cli for use as a Jenkins agent. This can be used to admin MongoDB collections, import seed data etc as part of Jenkins build / pipeline

## Build
`docker build -t jenkins-agent-mongodb .`

## Run
For local running and experimentation run `docker run -i -t  jenkins-agent-mongodb /bin/bash` and have a play once inside the container.

## Build in OpenShift
```bash
oc process -f ../../.openshift/templates/jenkins-agent-generic-template.yml \
    -p NAME=jenkins-agent-mongodb \
    -p SOURCE_CONTEXT_DIR=jenkins-agents/jenkins-agent-mongodb \
    | oc create -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-agent-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-agent-generic-template.yml`.

## Jenkins Running
Add a new Kubernetes Container template called `jenkins-agent-mongodb` and specify this as the node when running builds. Eg below for adding a new collection to a mongodb in OCP. NOTE: you may have to [connect the networks](https://docs.openshift.com/container-platform/3.11/admin_guide/managing_networking.html#joining-project-networks) if deploying to a namespace outside where the Agent container is running.
```
mongoimport --db ${PROJECT_NAMESPACE} --collection ${COLLECTION_NAME}  --drop --file ${COLLECTION_NAME}.json --jsonArray --username=${MONGODB_USERNAME} --password=${MONGODB_PASSWORD} --host=mongodb.${PROJECT_NAMESPACE}.svc.cluster.local:27017
```
