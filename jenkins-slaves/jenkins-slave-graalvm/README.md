# Jenkins Maven Slave

This slave extends [the Jenkins Maven Slave shipped with OpenShift](https://access.redhat.com/containers/?tab=overview#/registry.access.redhat.com/openshift3/jenkins-slave-maven-rhel7) to provide a settings.xml that proxies all dependencies through a nexus server deployed to the same namespace. This type of setup makes sense in a Lab setting, such as [Open Innovation Labs CI/CD](https://github.com/rht-labs/labs-ci-cd) environment. For most customer engagements, you'll to update this proxy/password to use an central, enterprise artifact repo which is unlikely to be deployed in the same namespace. Or simply use the OpenShift supplied base image directly and provide artifact repository info in the application build.

It also goes a little further and adds [GraalVM](https://www.graalvm.org/) and allows it to be used for creating Native Images from Maven projects

## Build in OpenShift
```bash
oc process -f ../../.openshift/templates/jenkins-slave-generic-template.yml \
    -p NAME=jenkins-slave-graal \
    -p SOURCE_CONTEXT_DIR=jenkins-slaves/jenkins-slave-graal \
    -p DOCKERFILE_PATH=Dockerfile \
    | oc create -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-slave-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-slave-generic-template.yml`.
