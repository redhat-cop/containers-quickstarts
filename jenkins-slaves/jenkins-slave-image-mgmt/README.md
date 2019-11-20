Jenkins Slave for Container and Image Management
=============================

Jenkins [Slave](https://wiki.jenkins-ci.org/display/JENKINS/Distributed+builds) that enables various container and image management capabilities and is optimized for deployment to a Jenkins instance running in the OpenShift Container Platform.

## Primary Components

[Skopeo](https://github.com/projectatomic/skopeo/) - A command utility for various operations on container images and image repositories.


## Instantiate Template

A [template](../../.openshift/templates/jenkins-slave-image-mgmt-template.yml) is available providing the necessary OpenShift components to build and make the slave image available to be referenced by Jenkins.

Execute the following command to instantiate the template:

```
oc process -f ../../.openshift/templates/jenkins-slave-image-mgmt-template.yml | oc apply -f-
```

A new image build will be started automatically

## Use within Jenkins

The template contains an *ImageStream* that has been configured with the appropriate labels that will be picked up by newly deployed Jenkins instances. 

For existing Jenkins servers, the slave can be added by using the following steps.

1. Login to Jenkins
2. Click on **Manage Jenkins** and then **Configure System**
3. Under the *Cloud* section, locate the *Kubernetes* Plugin. Click the *Add Pod Template* dropdown and select **
4. Enter the following details
	1. Name: jenkins-slave-image-mgmt
	2. Labels: jenkins-slave-image-mgmt 
	3. Docker image
		1. Using the `oc` command line, run `oc get is jenkins-slave-image-mgmt --template='{{ .status.dockerImageRepository }}'`. A value similar to *172.30.186.87:5000/jenkins/jenkins-slave-image-mgmt* should be used
	4. Jenkins slave root directory: `/tmp`
5. Click **Save** to apply the changes
	

## Use within Jenkins Pipeline Script

The following provides an example of how to make use of the image within a Jenkins [pipeline](https://jenkins.io/doc/book/pipeline/) script to execute the *inspect* function of the *skopeo* command line tool:

```
node('jenkins-slave-image-mgmt') { 

  stage('Inspect Image') {
    sh """

    set +x
        
    skopeo inspect docker://docker.io/fedora

    """
  }
}
```
