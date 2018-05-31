# jenkins-slave-zap

Provides a docker image of the zap runtime for use as a Jenkins slave. The public docker registry version of OWASP's Zed Attack Proxy (ZAP) is not compatible with OpenShift without using privleged containers. This Docker image resolves that issue.

## Build local

`docker build -t jenkins-slave-zap .`

## Run local

For local running and experimentation run `docker run -i -t jenkins-slave-zap /bin/bash` and have a play once inside the container. To check the zap runtime run `/zap/zap-baseline -r index.html -t http//<url-to-test>`

## Build in OpenShift

```bash
oc process -f ../templates/jenkins-slave-generic-template.yml \
    -p NAME=jenkins-slave-zap \
    -p SOURCE_CONTEXT_DIR=jenkins-slaves/jenkins-slave-zap \
    -p BUILDER_IMAGE_NAME=centos:centos7 \
    | oc create -f -
```

For all params see the list in the `../templates/jenkins-slave-generic-template.yml` or run `oc process --parameters -f ../templates/jenkins-slave-generic-template.yml`.

## Jenkins

Add a new Kubernetes Container template called `jenkins-slave-zap` (if you've built and pushed the container image locally) and specify this as the node when running builds. If you're using the template attached; the `role: jenkins-slave` is attached and Jenkins should automatically discover the slave for you. Further instructions can be found [here](https://docs.openshift.com/container-platform/3.7/using_images/other_images/jenkins.html#using-the-jenkins-kubernetes-plug-in-to-run-jobs).

## Using it in your Jenkinsfile

```groovy
stage('Get a ZAP Pod') {
    node('zap') {
        stage('Scan Web Application') {
            dir('/zap') {
                def retVal = sh returnStatus: true, script: '/zap/zap-baseline.py -r baseline.html -t http://<some-web-site>'
                publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: true, reportDir: '/zap/wrk', reportFiles: 'baseline.html', reportName: 'ZAP Baseline Scan', reportTitles: 'ZAP Baseline Scan'])
                echo "Return value is: ${retVal}"
            }
        }
    }
}
```
