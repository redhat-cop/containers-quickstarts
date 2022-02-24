#!/usr/bin/env bash

set -euo pipefail

AGENT=$1
JENKINS_CHART_VERSION=${2:-3.11.10}
AGENT_PATH="jenkins-agents/${AGENT}"
SCRIPT_DIR=$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}" || realpath "${BASH_SOURCE[0]}")")

if [[ -d ${AGENT_PATH} ]]
then
  # Create KinD cluster and load required container images
  kind create cluster --config ${SCRIPT_DIR}/kind-config.yaml
  for image in kiwigrid/k8s-sidecar:1.15.0 jenkins/jenkins:lts-jdk11 ${AGENT}:latest
  do
    if [[ "${image}" =~ "${AGENT}" ]]
    then
      podman save ${image} | docker load
      docker tag localhost/${image} ${image}
    else
      docker pull docker.io/${image}
    fi
    kind load docker-image ${image}
  done
  # Create Nginx Ingress controller
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
  echo "### Wait for Ingress controller to install ###"
  kubectl wait --namespace ingress-nginx \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=90s
  # Would like to find a cleaner approach to configure the podTemplate and Jenkins job below
  TPL_TEMP=$(mktemp -d)
  JENKINS_AGENT="${AGENT}" envsubst < ${SCRIPT_DIR}/jenkins-podtemplate.yaml > ${TPL_TEMP}/podtemplate.yaml
  JENKINS_AGENT="${AGENT}" JENKINSFILE=$(sed '2,$s/^/                      /' ${AGENT_PATH}/Jenkinsfile.test) envsubst < ${SCRIPT_DIR}/jenkins-casc-config-scripts-template.yaml > ${TPL_TEMP}/jenkins-casc-config-scripts.yaml
  # Use Helm to deploy and configure Jenkins
  helm repo add jenkinsci https://charts.jenkins.io --force-update
  helm repo update
  helm install jenkins \
    --version ${JENKINS_CHART_VERSION} \
    -n jenkins --create-namespace \
    -f ${SCRIPT_DIR}/jenkins-values.yaml \
    -f ${TPL_TEMP}/podtemplate.yaml \
    -f ${TPL_TEMP}/jenkins-casc-config-scripts.yaml \
    jenkinsci/jenkins
  # Make sure Jenkins is available 
  echo "### Wait for Jenkins instance to become ready ###"
  until [[ $(curl -s -w %{http_code} http://localhost/login -o /dev/null) == "200" ]]
  do
    sleep 5
  done

  # Create a Jenkins api token 
  secret=$(kubectl get secret -n jenkins jenkins -o jsonpath='{.data.jenkins-admin-password}' | base64 -d)
  crumb=$(curl -sk https://localhost/crumbIssuer/api/json --user admin:${secret} --cookie-jar /tmp/cookies | jq -r '.crumb')
  token=$(curl -sk https://localhost/me/descriptorByName/jenkins.security.ApiTokenProperty/generateNewToken --data 'newTokenName=foo' --user admin:${secret} -H "Jenkins-Crumb: ${crumb}" --cookie /tmp/cookies | jq -r '.data.tokenValue')

  # Start and monitor build
  echo "Starting build for ${AGENT}..."
  curl -s -XPOST http://localhost/job/containers-quickstarts/job/${AGENT}/build --user admin:${token}
  timeout=0
  until [[ $(curl -s http://localhost/job/containers-quickstarts/job/${AGENT}/lastBuild/api/json --user admin:${token} -w %{http_code} -o /dev/null) == "200" ]]
  do
    if [[ ${timeout} -gt 60 ]]
    then
      echo "Timed out waiting for build to be created..."
      exit 1
    fi
    sleep 2
    let "timeout += 2"
  done

  echo "Waiting for build to start..."
  timeout=0
  until [[ $(curl -s http://localhost/job/containers-quickstarts/job/${AGENT}/lastBuild/api/json --user admin:${token} | jq -r '.building') == "true" ]]
  do
    if [[ ${timeout} -gt 60 ]]
    then
      echo "Timed out waiting for build to start..."
      exit 1
    fi
    sleep 2
    let "timeout += 2"
  done 

  echo "Build in progress..."
  timeout=0
  while [[ $(curl -s http://localhost/job/containers-quickstarts/job/${AGENT}/lastBuild/api/json --user admin:${token} | jq -r '.building') == "true" ]]
  do
    if [[ ${timeout} -gt 300 ]]
    then
      echo "Timed out waiting for build to finish..."
      exit 1
    fi
    sleep 2
    let "timeout += 2"
  done
  curl -s http://localhost/job/containers-quickstarts/job/${AGENT}/lastBuild/logText/progressiveText --user admin:${token}
  JOB_STATUS=$(curl -s http://localhost/job/containers-quickstarts/job/${AGENT}/lastBuild/api/json --user admin:${token} | jq -r '.result')
  kind delete cluster --name kind
  if [[ ${JOB_STATUS} != "SUCCESS" ]]
  then
    echo "Test job for ${AGENT} finished with status: ${JOB_STATUS}, exiting..."
    exit 1
  fi
else
  echo "No such directory: ${AGENT_PATH}"
fi
