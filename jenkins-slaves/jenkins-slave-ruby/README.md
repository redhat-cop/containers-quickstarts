# Jenkins slave image for building Ruby applications

Jenkins [Slave](https://wiki.jenkins-ci.org/display/JENKINS/Distributed+builds) that enables building of Ruby source code and optimized for deployment to a Jenkins instance running in the OpenShift Container Platform.

## Primary Components

* Ruby 2.4.0 runtime, including:
  ** Bundler
  ** RubyGems
* Nodejs 6

## Instantiate Template

A [template](../templates/jenkins-slave-ruby-template.json) is available providing the necessary OpenShift components to build and make the slave image available to be referenced by Jenkins.

Execute the following command to instantiate the template:

```
oc process -f ../templates/jenkins-slave-ruby-template.json | oc apply -f-
```

A new image build will be started automatically

## Use within Jenkins

The template contains an *ImageStream* that has been configured with the appropriate labels that will be picked up by newly deployed Jenkins instances.

For existing Jenkins servers, the slave can be added by using the following steps.

1. Login to Jenkins
2. Click on **Manage Jenkins** and then **Configure System**
3. Under the *Cloud* section, locate the *Kubernetes* Plugin. Click the *Add Pod Template* dropdown and select **
4. Enter the following details
	1. Name: jenkins-slave-ruby
	2. Labels: jenkins-slave-ruby
	3. Docker image
		1. Using the `oc` command line, run `oc get is jenkins-slave-ruby --template='{{ .status.dockerImageRepository }}'`. A value similar to *docker-registry.default.svc:5000/jenkins/jenkins-slave-ruby* should be used
	4. Jenkins slave root directory: `/tmp`
5. Click **Save** to apply the changes


## Use within Jenkins Pipeline Script

The following provides an example of how to make use of the image within a Jenkins [pipeline](https://jenkins.io/doc/book/pipeline/) script to execute a simple install of dependencies:

```
node('jenkins-slave-ruby') {

  stage('Build Code') {

    sh """
      bundle install
      gem env
    """
  }
}
```
