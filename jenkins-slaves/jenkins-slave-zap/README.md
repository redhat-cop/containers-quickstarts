# jenkins-slave-zap

Provides a docker image of the zap runtime for use as a Jenkins slave. The public docker registry version of OWASP's Zed Attack Proxy (ZAP) is not compatible with OpenShift without using privleged containers. This Docker image resolves that issue.

## Build local

`docker build -t jenkins-slave-zap .`

## Run local

For local running and experimentation run `docker run -i -t jenkins-slave-zap /bin/bash` and have a play once inside the container. To check the zap runtime run `/zap/zap-baseline.py -r index.html -t http//<url-to-test>`

## Build in OpenShift

```bash
oc process -f ../../.openshift/templates/jenkins-slave-generic-template.yml \
    -p NAME=jenkins-slave-zap \
    -p SOURCE_CONTEXT_DIR=jenkins-slaves/jenkins-slave-zap \
    -p BUILDER_IMAGE_NAME=centos:centos7 \
    -p DOCKERFILE_PATH=Dockerfile \
    | oc create -f -
```

For all params see the list in the `../../.openshift/templates/jenkins-slave-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-slave-generic-template.yml`.

## Jenkins

Add a new Kubernetes Container template called `jenkins-slave-zap` (if you've built and pushed the container image locally) and specify this as the node when running builds. If you're using the template attached; the `role: jenkins-slave` is attached and Jenkins should automatically discover the slave for you. Further instructions can be found [here](https://docs.openshift.com/container-platform/3.7/using_images/other_images/jenkins.html#using-the-jenkins-kubernetes-plug-in-to-run-jobs).

## Using it in your Jenkinsfile

```groovy
stage('OWASP Scan') {
  agent {
      node {
          label "jenkins-slave-zap"
      }
  }
  steps {
      sh '''
          /zap/zap-baseline.py -r index.html -t http://<some website url> || return_code=$?
          echo "exit value was  - " $return_code
      '''
  }
  post {
    always {
      // publish html
      publishHTML target: [
          allowMissing: false,
          alwaysLinkToLastBuild: false,
          keepAll: true,
          reportDir: '/zap/wrk',
          reportFiles: 'index.html',
          reportName: 'OWASP Zed Attack Proxy'
        ]
    }
  }
}
```
