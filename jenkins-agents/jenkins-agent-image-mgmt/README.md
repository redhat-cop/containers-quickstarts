Jenkins Agent for Container and Image Management
=============================

Jenkins [Agent](https://wiki.jenkins-ci.org/display/JENKINS/Distributed+builds) that enables various container and image management capabilities and is optimized for deployment to a Jenkins instance running in the OpenShift Container Platform.

## Primary Components

[Skopeo](https://github.com/containers/skopeo/) - A command utility for various operations on container images and image repositories.

>**NOTE:** Skopeo is built with DISABLE_CGO=1 and thus lack support for devicemapper, btrfs and gpgme. See [skopeo documentation](https://github.com/containers/skopeo/blob/master/install.md#building-in-a-container) for more information.

## Build local
`docker build -t jenkins-agent-image-mgmt .`

## Run local
For local running and experimentation run `docker run -it --entrypoint=bash jenkins-agent-image-mgmt` and have a play once inside the container.

## Build in OpenShift
```bash
oc process -f ../../.openshift/templates/jenkins-agent-generic-template.yml \
  -p NAME=jenkins-agent-image-mgmt \
  -p SOURCE_CONTEXT_DIR=jenkins-agents/jenkins-agent-image-mgmt \
  | oc create -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-agent-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-agent-generic-template.yml`.

## Jenkins
Add a new Kubernetes Container template called `jenkins-agent-image-mgmt` (if you've build and pushed the container image locally) and specify this as the node when running builds. If you're using the template attached; the `role: jenkins-agent` is attached and Jenkins should automatically discover the agent for you. Further instructions can be found [here](https://docs.openshift.com/container-platform/4.4/openshift_images/using_images/images-other-jenkins.html#images-other-jenkins-kubernetes-plugin_images-other-jenkins). 

```
$ oc run jenkins-agent-image-mgmt -i -t --image=docker-registry.default.svc:5000/jenkins-agent-image-mgmt/jenkins-agent-image-mgmt --command -- skopeo --version
If you don't see a command prompt, try pressing enter.
skopeo version 1.0.0
Session ended, resume using 'oc attach jenkins-agent-image-mgmt-1-wcbxv -c jenkins-agent-image-mgmt -i -t' command when the pod is running
```

## Use within Jenkins Pipeline Script

The following provides an example of how to make use of the image within a Jenkins [pipeline](https://jenkins.io/doc/book/pipeline/) script to execute the *inspect* function of the *skopeo* command line tool:

```
node('jenkins-agent-image-mgmt') { 

  stage('Inspect Image') {
    sh """

    set +x
        
    skopeo inspect docker://docker.io/fedora

    """
  }
}
```
