# Zed Attack Proxy

Provides Docker images of the zap runtime for use as a Jenkins slave or as a persistent service. The public docker registry version of OWASP's Zed Attack Proxy (ZAP) is not compatible with OpenShift without using privileged containers. These Docker images resolve that issue.

## Use cases

1. ZAP as a Jenkins Agent, which can run as part of a [Multi-Container Pod](Multi-Container_Pipeline_In_Jenkins_On_OpenShift.md)
2. ZAP as a service running in OpenShift, and it can be used by any pipeline
   - ZAP session management requires that there is only a single user at any given time or the results will get mixed up. In your Jenkinsfile, you will need to use `lock('zap-daemon') {}` to wrap your stages/steps for using ZAP.

## Build local

`docker build -t jenkins-slave-zap .`

## Run local baseline scan

For local running and experimentation run `docker run -i -t jenkins-slave-zap /bin/bash` and have a play once inside the container. To check the zap runtime run `/zap/zap-baseline.py -r index.html -t http//<url-to-test>`

## Build ZAP Agent in OpenShift

```bash
oc process -f ../templates/jenkins-slave-generic-template.yml \
    -p NAME=jenkins-slave-zap \
    -p SOURCE_CONTEXT_DIR=jenkins-slaves/jenkins-slave-zap \
    -p BUILDER_IMAGE_NAME=registry.access.redhat.com/openshift3/jenkins-slave-base-rhel7:latest \
    -p DOCKERFILE_PATH=Dockerfile.rhel7 \
    | oc create -f -
```

## Build ZAP Daemon in OpenShift

```bash
oc process -f .openshift/templates/s2i-dockerfile-imagestream-build.yml --param-file=.openshift/params/rhel7-daemon | oc create -f -
```

For all params see the list in the `../templates/jenkins-slave-generic-template.yml` or run `oc process --parameters -f ../templates/jenkins-slave-generic-template.yml`.

## Jenkins

Add a new Kubernetes Container template called `jenkins-slave-zap` (if you've built and pushed the container image locally) and specify this as the node when running builds. If you're using the template attached; the `role: jenkins-slave` is attached and Jenkins should automatically discover the slave for you. Further instructions can be found [here](https://docs.openshift.com/container-platform/3.7/using_images/other_images/jenkins.html#using-the-jenkins-kubernetes-plug-in-to-run-jobs).

## Using the ZAP Jenkins Agent Container (Dockerfile.rhel7) in a Jenkinsfile

1. Start by reading [Multi-Container Pipeline In Jenkins On OpenShift](Multi-Container_Pipeline_In_Jenkins_On_OpenShift.md)
   - This will explain how to configure a multi-container pod for Jenkins
2. In your pipeline, depending on what your platform and language are, you will need to set up your integration tests to use ZAP:
   ```groovy
    stage('Integration And Penetration Testing') {
      parallel {
        stage('Start ZAP Daemon') {
          options {
            timeout(time: 10, unit: 'MINUTES')
          }
          steps {
            container('jenkins-slave-zap') {        // Tell Jenkins that these steps should be performed in the ZAP container instead of the default container.
              dir('/tmp/workspace') {
                sh returnStatus: true, script: '/zap/zap.sh -daemon -host 0.0.0.0 -port 9080 -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true -config api.disablekey=true'
              }
            }
          }
        }

        // Implement stage to run Integration Tests Here
        stage('Integration/Acceptance Tests') {
          steps {
            script {
              def testApiHost = ""
              openshift.withCluster() {
                openshift.withProject(env.TEST) {
                  def routeDef = openshift.selector("route", env.APP_NAME).object()
                  testApiHost = "${routeDef.spec.host}"
                }
              }
              retry(10) {  // Wait for the ZAP Proxy to be started
                sleep 5
                sh 'curl -s http://127.0.0.1:9080/JSON/core/view/mode'
              }
              def jsonReport = "{}"
              withEnv([ "INTEGRATION_TEST_HOST=http://${testApiHost}/v1"]) {
                try {
                  sh 'mvn -T 1.5C -Pintegration-testing failsafe:integration-test failsafe:verify'
                  retry(10) { // Poll the ZAP API and wait for reports to be generated from existing records
                    sleep 20
                    def result = sh returnStdout: true, script: 'curl -s -k http://127.0.0.1:9080/JSON/pscan/view/recordsToScan'
                    echo result
                    if (result.trim() != '{"recordsToScan":"0"}') {
                      error "ZAP Analysis incomplete"
                    }
                  }
                  sh 'mkdir zap-report'
                  sh 'curl -v -o ./zap-report/zap-report.html http://127.0.0.1:9080/OTHER/core/other/htmlreport'
                  jsonReport = sh(returnStdout: true, script: 'curl http://127.0.0.1:9080/OTHER/core/other/jsonreport')
                } catch (Exception e) {
                  throw e
                } finally {
                  // Shut down ZAP
                  sh 'curl http://127.0.0.1:9080/JSON/core/action/shutdown'
                }
              }

              // Process the JSON report and check for issues exceeding the defined threshold.
              def jsonData = new JsonSlurper().parseText(jsonReport)
              def highCriticalRisks = jsonData.site.each { site ->
                site.alerts.each { alert ->
                  def alertValue = alert.riskcode as Integer
                  if (alertValue >= 3) {
                    error 'High/Critical Risks Detected By Zed Attack Proxy'
                  }
                }
              }
            }
          }
        }
      }
    }
   ```