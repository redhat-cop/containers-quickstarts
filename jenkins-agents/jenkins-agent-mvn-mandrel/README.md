# Jenkins Maven Agent with Mandrel

This agent extends [the Jenkins Maven Agent shipped with OpenShift](quay.io/openshift/origin-jenkins-agent-maven:latest). It adds the [Mandrel Drop in replacement for GraalVM](https://github.com/graalvm/mandrel/) which is licence permissive so you can build native quarkus images. The image contains multiple versions of openjdk which can be set using the standard environment variable e.g. `JAVA_HOME = "/usr/lib/jvm/java-11-openjdk"`. Common tools used in pipelines are also installed such as, Helm, jq, latest OpenShift client, yq, git, tar, bzip2, unzip.

## Build in OpenShift
```bash
oc process -f ../../.openshift/templates/jenkins-agent-generic-template.yml \
    -p NAME=jenkins-agent-mvn \
    -p SOURCE_CONTEXT_DIR=jenkins-agents/jenkins-agent-mvn-mandrel \
    -p DOCKERFILE_PATH=Dockerfile \
    | oc create -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-agent-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-agent-generic-template.yml`.

## Base image files

The files packaged in this image are sourced from the base agent image.
- https://github.com/openshift/jenkins/tree/master/slave-base

```bash
.
├── contrib
│   └── bin
│       ├── configure-agent
│       └── run-jnlp-client
├── go-init
│   └── main.go
```

This image uses UBI and so does not extend the RHEL base image above. Ideally this image would layer in a UBI base jenkins image at some point.
 