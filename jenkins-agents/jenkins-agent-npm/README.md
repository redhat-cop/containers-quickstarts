# jenkins-agent-npm
Provides a docker image of the nodejs v12 runtime with npm for use as a Jenkins agent.

## Build local
`docker build -t jenkins-agent-npm .`

## Run local
For local running and experimentation run `docker run -i -t jenkins-agent-npm /bin/bash` and have a play once inside the container.

## Note
It was decided to remove Chrome browser from this Jenkins Agent. This is to keep this one in line with the other agents being based of the most recent version of the `quay.io/openshift/origin-jenkins-agent-base` base which is now built using Universal Base Image. For those looking to do do browser testing, there are a few alternatives available
1. Use the `v1.25` tag of this repository which still contains Chrome in the image
2. Use the [Zalenium](https://github.com/redhat-cop/containers-quickstarts/tree/master/zalenium) deployment to execute browser tests against a Selenium grid built for Kubernetes including Chrome and Firefox

## Build in OpenShift
```bash
oc process -f ../../.openshift/templates/jenkins-agent-generic-template.yml \
    -p NAME=jenkins-agent-npm \
    -p SOURCE_CONTEXT_DIR=jenkins-agents/jenkins-agent-npm \
    | oc apply -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-agent-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-agent-generic-template.yml`.

## Jenkins
Add a new Kubernetes Container template called `jenkins-agent-npm` (if you've build and pushed the container image locally) and specify this as the node when running builds. If you're using the template attached; the `role: jenkins-agent` is attached and Jenkins should automatically discover the agent for you. Further instructions can be found [here](https://docs.openshift.com/container-platform/3.7/using_images/other_images/jenkins.html#using-the-jenkins-kubernetes-plug-in-to-run-jobs).

Add this new Kubernetes Container template and specify this as the node when running builds, for example in a Jenkinsfile below
```Groovy
pipeline {
    agent {
      label 'jenkins-agent-npm'
    }

    stages {
        stage ('Run Test') {
            steps {
              sh """
                npm install
                npm run build
              """
            }
        }

    }

}
```
