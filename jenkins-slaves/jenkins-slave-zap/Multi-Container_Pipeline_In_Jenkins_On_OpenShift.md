# Overview
Sometimes it is useful to be able to leverage multiple containers in a Jenkins pipeline instead of modifying a specific container to include additional tools. One example would be using [OWASP ZAP](https://www.owasp.org/index.php/OWASP_Zed_Attack_Proxy_Project) to perform penetration testing against web applications and services. Instead of trying to add ZAP into Maven agents and NodeJS agents and whatever other Jenkins agents you might you, you can load a ZAP container as a [sidecar](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/).

# Background

In OpenShift, Jenkins will automatically detect container images which can be used as agents when it sees ImageStreams which are labeled as shown:

```
  labels:
    role: jenkins-slave
```

For automatically detected Jenkins agents, Jenkins will launch those Pods using the default `ENTRYPOINT` command and it will pass 2 arguments automatically:
- The Jenkins JNLP Secret token
- The name of the Pod

The default `ENTRYPOINT` for all Jenkins agents used in OpenShift should be the `/usr/local/bin/run-jnlp-client` script which is inherited from the `openshift3/jenkins-slave-base-rhel7` container image. It is **HIGHLY** recommended to base any Jenkins agents on this image as it implements certain requirements for running a Jenkins agent inside of OpenShift's more tighly secured environment.

# Multiple Containers Via A Jenkins PodTemplate

In [Jenkins declarative pipeline syntax](https://jenkins.io/doc/book/pipeline/syntax/), you can define your own configurations for launching a [Jenkins Pod](https://github.com/jenkinsci/kubernetes-plugin#declarative-pipeline) by defining a pod template. In a simple pipeline using a single container, the `agent` block of the pipeline script might look like:

```
pipeline {
  agent {
    label 'jenkins-slave-npm'
  }
  // ... SNIP
}
```

To override this, you can provide either a Pod template file OR an in-line YAML block to define the specifics of the Pod as shown below:

```
pipeline {
  // Use Jenkins Maven slave
  // Jenkins will dynamically provision this as OpenShift Pod
  // All the stages and steps of this Pipeline will be executed on this Pod
  // After Pipeline completes the Pod is killed so every run will have clean
  // workspace
  agent {
    kubernetes {
      cloud 'openshift'                               <1>
      defaultContainer 'jnlp'                         <2>
      label "zaproxy-maven-sidecars-${env.BUILD_ID}"  <3>
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    pod-template: jenkins-slave-sidecars
spec:
  serviceAccount: jenkins                             <4>
  serviceAccountName: jenkins                         <4>
  containers:
  - name: jnlp                                        <5>
    image: docker-registry.default.svc:5000/${env.NAMESPACE}/jenkins-slave-mvn:latest
    tty: true
    alwaysPull: true
    workingDir: /tmp                                  <6>
    env:
    - name: OPENSHIFT_JENKINS_JVM_ARCH
      value: x86_64
  - name: jenkins-slave-zap
    image: docker-registry.default.svc:5000/${env.NAMESPACE}/jenkins-slave-zap:latest
    tty: true
    alwaysPull: true
    workingDir: /tmp                                  <6>
    command:
    - run-jnlp-client                                 <7>
    - cat
    env:
    - name: ZAP_HOME
      value: /zap
    - name: OPENSHIFT_JENKINS_JVM_ARCH
      value: x86_64
"""
    }
  }
  // ... SNIP
}
```
1. By default, OpenShift configures the Jenkins master to use the name `openshift` for the cloud provider, and as such we need to specify that explicitly or it will default to the name `kubernetes`
1. The default container should ALWAYS be called `jnlp` in an OpenShift environment for reasons explained below.
1. The label is optional, but setting it to match the build ID makes it easier to relate a Pod to a particular Jenkins build
1. You MUST specify that the Pod is running with the privileges of the `jenkins` service account so that it will be able to interact properly with the OpenShift API
1. One (and **ONLY ONE**) container **MUST** be named `jnlp`, this name is used by Jenkins to determine which Pod is the Agent lead and is used to control the Pod from Jenkins perspective.
1. You **SHOULD** set the workDir so that the Jenkins workspace volume will not be mounted in an inconsistent location. Whatever the container (or the Pod template) define as the working directory is where the Jenkins workspace volume will be mounted. In the case of Maven or NPM agents, if the home directory for Jenkins (`/home/jenkins`) is overwritten by the volume mount, it will cause Maven or NPM to have problems because the default settings will not be present.
1. For all **OTHER** containers in the Pod, you **SHOULD** run the `run-jnlp-client` script because it initializes certain things about the container on start. Specifically, the `run-jnlp-client` will use the `update-alternatives` command to configure Java and also maps the randomly generated UID for the OpenShift user to a username in the `/etc/passwd` file.

>>>
# NOTE: You CANNOT provide arguments to the `jnlp` container as it will interfere with the Jenkins remote control process!!! So, the `jnlp` container cannot have a `command` section.
>>>

Once you have a pod template defined and you start a new build pipeline, all stages/steps are run inside of the default container. If you need to run a stage/step in an alternate container you can wrap it in a container block as shown below:

```
stage('Start ZAP') {
  options {
    timeout(time: 10, unit: 'MINUTES')
  }
  steps {
    container('jenkins-slave-zap') {    <1>
      dir('/tmp/workspace') {
        sh returnStatus: true, script: '/zap/zap.sh -daemon -host 0.0.0.0 -port 9080 -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true -config api.disablekey=true'
      }
    }
  }
}
```
1. Using the `container` block allows you to specify which container these steps will be executed on.

# FAQ

## Why must the default container be named `jnlp`?
The Jenkins Kubernetes Plugin will **ALWAYS** try to launch a container named `jnlp` and if you do not have one of your containers named `jnlp` it will default to pulling a `jnlp` container image from DockerHub. That DockerHub jnlp container is NOT compatible with OpenShift and will cause errors.