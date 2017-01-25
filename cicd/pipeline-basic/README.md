# A Sample OpenShift Pipeline

This example demonstrates how to implement a full end-to-end Jenkins Pipeline for a Java application in OpenShift Container Platform. This sample demonstrates the following capabilities:

* Deploying an integrated Jenkins server inside of OpenShift
* Running both custom and oob Jenkins slaves as pods in OpenShift
* "One Click" instantiation of a Jenkins Pipeline using OpenShift's Jenkins Pipeline Strategy feature
* Promotion of an application's container image within an OpenShift Cluster (using `oc tag`)
* Promotion of an application's container image to a separate OpenShift Cluster (using `skopeo`)

## Architecture

### OpenShift Templates

The components of this pipeline are divided into two templates.

The first, `generic-java-jenkins-pipeline` contains:

* A `jenkinsPipelineStrategy` BuildConfig
* An `s2i` BuildConfig
* An ImageStream for the s2i build config to push to

The second, `jws30-tomcat8-deployment` contains:

* A tomcat8 DeploymentConfig
* A Service definition
* A Route

The idea behind the split between the templates is that I can deploy the build template only once (to my dev project) and that the pipeline will promote my image through all of the various stages of my application's lifecycle. The deployment template gets deployed once to each of the stages of the application lifecycle (once per OpenShift project).

### Pipeline Scipt

This project includes a sample `pipeline.groovy` Jenkins Pipeline script that could be included with a Java project in order to implement a basic CI/CD pipeline for that project, under the following assumptions:

* The project is build with Maven
* The `pipeline.groovy` script is placed in the same directory as the `pom.xml` file in the git source.
* The OpenShift projects that represent the Application's lifecycle stages are of the naming format: `<app-name>-dev`, `<app-name>-stage`, `<app-name>-prod`.

For convenience, this pipeline script is already included in the following git repository, based on the [JBoss Developers Ticket Monster](https://github.com/jboss-developer/ticket-monster) app.

https://github.com/etsauer/ticket-monster

## Bill of Materials

* One or Two OpenShift Container Platform Clusters
  * Either OCP 3.4, or OCP 3.3 with the Pipelines tech preview feature enabled.

## Implementation Instructions

### 0. Pre-Work

This pipeline has some dependencies that we need to provide it in our OpenShift cluster in order to work properly. They are:

* The `jenkins-slave-image-mgmt` image from this repository
* A slightly customized `jenkins2` image

Both images can be built and provided to your cluster as follows:

```
oc process -f jenkins-slaves/templates/jenkins-slave-image-mgmt-template.json | oc create -f - -n openshift
oc process -f cicd/jenkins/jenkins-s2i.yml -v JENKINS_GIT_URL=https://github.com/redhat-cop/containers-quickstarts.git -v JENKINS_GIT_CONTEXT_DIR=cicd/jenkins | oc create -f - -n openshift
```

### 1. Create Lifecycle Stages

For the purposes of this demo, we are going to create three stages for our application to be promoted through.

```
oc new-project myapp-dev
oc new-project myapp-stage
```

If you have a separate production cluster, create the prod project in the other cluster. Otherwise create it in the same cluster as the first two.

```
oc new-project myapp-prod
```

Additionally, you'll need to give access to Jenkins to be able to push images to your stage and prod projects. We can provide that access with the following:

```
oc adm policy add-role-to-user edit system:serviceaccount:myapp-dev:jenkins -n myapp-stage
oc adm policy add-role-to-user edit system:serviceaccount:myapp-dev:jenkins -n myapp-prod
```

### 2. Stand up Jenkins master in dev

```
oc new-app --template=jenkins-ephemeral -n myapp-dev
```

### 3. Create the Templates

The Pipeline templates in this project are intended to be instantiated multiple times. As such, we recommend making them a parmanent offering in your OCP clusters. Create both the `*-pipeline` and `*-deployment` templates in your project.

```
oc create -f generic-java-jenkins-pipeline.yml
oc create -f jws30-tomcat8-deployment.yml
```

Or, if you'd like the templates to be available for the entire cluster, you can create the templates in your `openshift` project.

```
oc create -f generic-java-jenkins-pipeline.yml -n openshift
oc create -f jws30-tomcat8-deployment.yml -n openshift
```
### 4. Instantiate Pipeline

Here are the steps to instantiate the pipeline.

1. Deploy the deployment template to all three projects.
```
oc new-app --template=jws30-tomcat8-deployment -p APPLICATION_NAME=myapp -n myapp-dev
oc new-app --template=jws30-tomcat8-deployment -p APPLICATION_NAME=myapp -n myapp-stage
oc new-app --template=jws30-tomcat8-deployment -p APPLICATION_NAME=myapp -n myapp-prod
```
2. Deploy the pipeline template in dev only
```
oc new-app --template=generic-java-jenkins-pipeline -p APPLICATION_NAME=myapp -n myapp-dev
```

At this point you should be able to go to the Web Console and following the pipeline by clicking in your `myapp-dev` project, and going to *Builds* -> *Pipelines*. At several points you will be prompted for input on the pipeline. You can interact with it by clicking on the _input required_ link, which takes you to Jenkins, where you can click the *Proceed* button. By the time you get through the end of the pipeline you should be able to visit the Route for your app deployed to the `myapp-prod` project to confirm that your image has been promoted through all stages.
