# Jenkins Maven Slave with Graal

This slave packages maven and graal together for use in building [Quarkus.io](https://quarkus.io) applications.

## Build this image in OpenShift
```bash
oc process -f ../.openshift/templates/jenkins-slave-generic-template.yml \
    -p NAME=jenkins-slave-mvn-graal \
    -p SOURCE_CONTEXT_DIR=jenkins-slaves/jenkins-slave-mvn-graal \
    -p DOCKERFILE_PATH=Dockerfile \
    | oc create -f -
```

For all params see the list in the `../templates/jenkins-slave-generic-template.yml` or run `oc process --parameters -f ../templates/jenkins-slave-generic-template.yml`.

## Use this image in a Jenkins pipeline

```
            agent {
              kubernetes {
                label 'jenkins-slave-mvn-graal'
                cloud 'openshift'
                serviceAccount 'jenkins'
                containerTemplate {
                  name 'jnlp'
                  image "docker-registry.default.svc:5000/openshift/jenkins-slave-mvn-graal:v3.11"
                  alwaysPullImage true
                  workingDir '/tmp'
                  args '${computer.jnlpmac} ${computer.name}'
                  command ''
                  ttyEnabled false
                }
              }
            }
```