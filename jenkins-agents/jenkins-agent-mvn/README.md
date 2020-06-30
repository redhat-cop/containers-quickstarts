# Jenkins Maven Agent

This agent extends [the Jenkins Maven Agent shipped with OpenShift](https://access.redhat.com/containers/?tab=overview#/registry.access.redhat.com/openshift3/jenkins-agent-maven-rhel7) to provide a settings.xml that proxies all dependencies through a nexus server deployed to the same namespace. This type of setup makes sense in a Lab setting, such as [Open Innovation Labs CI/CD](https://github.com/rht-labs/labs-ci-cd) environment. For most customer engagements, you'll to update this proxy/password to use an central, enterprise artifact repo which is unlikely to be deployed in the same namespace. Or simply use the OpenShift supplied base image directly and provide artifact repository info in the application build.

## Build in OpenShift
```bash
oc process -f ../../.openshift/templates/jenkins-agent-generic-template.yml \
    -p NAME=jenkins-agent-mvn \
    -p SOURCE_CONTEXT_DIR=jenkins-agents/jenkins-agent-mvn \
    -p DOCKERFILE_PATH=Dockerfile \
    | oc create -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-agent-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-agent-generic-template.yml`.
