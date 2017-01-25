#!/usr/bin/groovy

////
// This pipeline requires the following plugins:
// Kubernetes Plugin 0.10
////

String ocpApiServer = env.OCP_API_SERVER ? "${env.OCP_API_SERVER}" : "https://openshift.default.svc.cluster.local"

node('master') {

  env.NAMESPACE = readFile('/var/run/secrets/kubernetes.io/serviceaccount/namespace').trim()
  env.TOKEN = readFile('/var/run/secrets/kubernetes.io/serviceaccount/token').trim()
  env.OC_CMD = "oc --token=${env.TOKEN} --server=${ocpApiServer} --certificate-authority=/run/secrets/kubernetes.io/serviceaccount/ca.crt --namespace=${env.NAMESPACE}"

  env.APP_NAME = "${env.JOB_NAME}".replaceAll(/-?pipeline-?/, '').replaceAll(/-?${env.NAMESPACE}-?/, '')
  def projectBase = "${env.NAMESPACE}".replaceAll(/-dev/, '')
  env.STAGE1 = "${projectBase}-dev"
  env.STAGE2 = "${projectBase}-stage"
  env.STAGE3 = "${projectBase}-prod"

  sh(returnStdout: true, script: "${env.OC_CMD} get is jenkins-slave-image-mgmt --template=\'{{ .status.dockerImageRepository }}\' -n openshift > /tmp/jenkins-slave-image-mgmt.out")
  env.SKOPEO_SLAVE_IMAGE = readFile('/tmp/jenkins-slave-image-mgmt.out').trim()
  println "${env.SKOPEO_SLAVE_IMAGE}"

}

node('maven') {
//  def artifactory = Artifactory.server(env.ARTIFACTORY_SERVER)
  // def artifactoryMaven = Artifactory.newMavenBuild()
  // def buildInfo = Artifactory.newBuildInfo()
  // def scannerHome = tool env.SONARQUBE_TOOL
  def mvnHome = "/usr/share/maven/"
  def mvnCmd = "${mvnHome}bin/mvn"
  String pomFileLocation = env.BUILD_CONTEXT_DIR ? "${env.BUILD_CONTEXT_DIR}/pom.xml" : "pom.xml"

  stage('SCM Checkout') {
    checkout scm
  }

  stage('Build') {

    // artifactoryMaven.tool = env.MAVEN_TOOL
    // artifactoryMaven.deployer releaseRepo: env.ARTIFACTORY_DEPLOY_RELEASE_REPO, snapshotRepo: env.ARTIFACTORY_DEPLOY_SNAPSHOT_REPO, server: artifactory
    // artifactoryMaven.resolver releaseRepo: env.ARTIFACTORY_RESOLVE_RELEASE_REPO, snapshotRepo:env.ARTIFACTORY_RESOLVE_SNAPSHOT_REPO, server: artifactory
    // buildInfo.env.capture = true
    // buildInfo.retention maxBuilds: 10, maxDays: 7, deleteBuildArtifacts: true
    //
    // artifactoryMaven.run pom: pomFileLocation , goals: 'clean install', buildInfo: buildInfo
    // artifactory.publishBuildInfo buildInfo
    sh "find / -name mvn || true"

    sh "${mvnCmd} clean install -DskipTests=true -f ${pomFileLocation}"

  }

  // stage('SonarQube scan') {
  //   withSonarQubeEnv {
  //       artifactoryMaven.run pom: pomFileLocation, goals: 'org.sonarsource.scanner.maven:sonar-maven-plugin:3.2:sonar'
  //   }
  // }
//             cp -rfv "${env.BUILD_CONTEXT_DIR}/target/*.\$t" oc-build/deployments/ 2> /dev/null || echo "No \$t files"


  stage('Build Image') {

    sh """
       set -e
       set -x

       echo "Environment Variables:"
       env

       echo "Current Directory:"
       pwd

       rm -rf oc-build && mkdir -p oc-build/deployments

       echo "Directory Contents Before:"
       find . -maxdepth 2

       for t in \$(echo "jar;war;ear" | tr ";" "\\n"); do
         cp -rfv ./target/*.\$t oc-build/deployments/ 2> /dev/null || echo "No \$t files"
       done

       echo "Directory Contents After:"
       find . -maxdepth 2

       set +e

       for i in oc-build/deployments/*.war; do
          mv -v oc-build/deployments/\$(basename \$i) oc-build/deployments/ROOT.war
          break
       done

       ${env.OC_CMD} start-build ${env.APP_NAME} --from-dir=oc-build --wait=true --follow=true || exit 1
       set +x
    """

    input "Promote Application to Stage?"
  }

  stage('Promote To Stage') {
    sh """
    ${env.OC_CMD} tag ${env.STAGE1}/${env.APP_NAME}:latest ${env.STAGE2}/${env.APP_NAME}:latest
    """

    input "Promote Application to Prod?"
  }

}

podTemplate(label: 'jenkins-slave-image-mgmt', cloud: 'openshift', containers: [
  containerTemplate(name: 'jenkins-slave-image-mgmt', image: "${env.SKOPEO_SLAVE_IMAGE}")
]) {

  node('jenkins-slave-image-mgmt') {

    stage('Promote To Prod') {
      sh """

      set +x
      imageRegistry=\$(${env.OC_CMD} get is ${env.APP_NAME} --template='{{ .status.dockerImageRepository }}' -n ${env.STAGE2} | cut -d/ -f1)

      strippedNamespace=\$(echo ${env.NAMESPACE} | cut -d/ -f1)

      echo "Promoting \${imageRegistry}/${env.STAGE2}/${env.APP_NAME} -> \${imageRegistry}/${env.STAGE3}/${env.APP_NAME}"
      skopeo --tls-verify=false copy --src-creds openshift:${env.TOKEN} --dest-creds openshift:${env.TOKEN} docker://\${imageRegistry}/${env.STAGE2}/${env.APP_NAME} docker://\${imageRegistry}/${env.STAGE3}/${env.APP_NAME}
      """
    }
  }
}
