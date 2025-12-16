#!/usr/bin/env bash

set -euo pipefail

AGENT=$1

# renovate: datasource=github-releases depName=jenkinsci/helm-charts
JENKINS_CHART_VERSION="5.8.114"
AGENT_PATH="jenkins-agents/${AGENT}"
SCRIPT_DIR=$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}" || realpath "${BASH_SOURCE[0]}")")

function do_until {
  local url=$1
  local token=${2:-}
  local http_code=$3
  local timesup=$4
  local msg=${5:-Timed out while waiting...}
  local timeout=0

  [[ -n ${token} ]] && auth="--user admin:${token}" || auth=""
  until [[ $(curl -sL -w %{http_code} ${url} ${auth} -o /dev/null) == ${http_code} ]]
  do
    if [[ ${timeout} -gt ${timesup} ]]
    then
      echo "${msg}"
      exit 1
    fi
    sleep 5
    let "timeout += 5"
  done
}

function do_until_json {
  local url=$1
  local token=${2:-}
  local json_expr=$3
  local json_value=$4
  local timesup=$5
  local msg=${6:-Timed out while waiting...}
  local timeout=0

  [[ -n ${token} ]] && auth="--user admin:${token}" || auth=""
  until [[ $(curl -sL ${url} ${auth} | jq -r ${json_expr}) == ${json_value} ]]
  do
    if [[ ${timeout} -gt ${timesup} ]]
    then
      echo "${msg}"
      exit 1
    fi
    sleep 2
    let "timeout += 2"
  done
}

function get_build_logs {
  curl -s http://localhost/job/containers-quickstarts/job/${AGENT}/lastBuild/logText/progressiveText --user admin:${token}
}

if [[ -d ${AGENT_PATH} ]]
then
  # Create KinD cluster and load required container images
  if [[ $(kind get clusters | head -1) != "kind" ]]
  then
    kind create cluster --config ${SCRIPT_DIR}/kind-config.yaml
  fi

  podman save ${AGENT}:latest | docker load
  docker tag localhost/${AGENT}:latest ${AGENT}:latest
  kind load docker-image ${AGENT}:latest

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

  echo "### Jenkins content will look like... ###"
  helm template jenkins \
      --version ${JENKINS_CHART_VERSION} \
      -n jenkins --create-namespace \
      -f ${SCRIPT_DIR}/jenkins-values.yaml \
      -f ${TPL_TEMP}/podtemplate.yaml \
      -f ${TPL_TEMP}/jenkins-casc-config-scripts.yaml \
      jenkinsci/jenkins

  echo "### Jenkins install ###"
  helm install jenkins \
    --version ${JENKINS_CHART_VERSION} \
    -n jenkins --create-namespace \
    -f ${SCRIPT_DIR}/jenkins-values.yaml \
    -f ${TPL_TEMP}/podtemplate.yaml \
    -f ${TPL_TEMP}/jenkins-casc-config-scripts.yaml \
    jenkinsci/jenkins

  echo "### Checking statefulset config ###"
  sleep 60

  kubectl get statefulsets -n jenkins
  kubectl describe statefulsets/jenkins -n jenkins

  echo "### Checking pod logs... ###"
  echo "### config-reload-init ###"
  kubectl logs statefulsets/jenkins -c config-reload-init -n jenkins

  echo "### init ###"
  kubectl logs statefulsets/jenkins -c init -n jenkins

  sleep 60
  echo "### jenkins ###"
  kubectl logs statefulsets/jenkins -c jenkins -n jenkins

  echo "### Waiting for deployment... ###"
  kubectl rollout status statefulsets/jenkins --watch=true --timeout=5m -n jenkins

  # Make sure Jenkins is available
  echo "### Wait for Jenkins instance to become ready ###"
  do_until "http://localhost/login" "" 200 300 "Timed out waiting for Jenkins to become ready..."

  # Create a Jenkins api token 
  secret=$(kubectl get secret -n jenkins jenkins -o jsonpath='{.data.jenkins-admin-password}' | base64 -d)
  crumb=$(curl -s http://localhost/crumbIssuer/api/json --user admin:${secret} --cookie-jar /tmp/cookies | jq -r '.crumb')
  if [ -z ${crumb} ]
  then
    echo "Failed to create Jenkins Crumb, exiting..."
    exit 2
  fi

  token=$(curl -s http://localhost/me/descriptorByName/jenkins.security.ApiTokenProperty/generateNewToken --data 'newTokenName=foo' --user admin:${secret} -H "Jenkins-Crumb: ${crumb}" --cookie /tmp/cookies | jq -r '.data.tokenValue')
  if [ -z ${token} ]
  then
    echo "Failed to create Jenkins Token, exiting..."
    exit 2
  fi

  # Start and monitor build
  echo "Starting build for ${AGENT}..."
  timeout=0
  do_until "http://localhost/job/containers-quickstarts/job/${AGENT}" ${token} 200 60 "Timed out waiting for build to start..."
  curl -s -XPOST http://localhost/job/containers-quickstarts/job/${AGENT}/build --user admin:${token}
  do_until "http://localhost/job/containers-quickstarts/job/${AGENT}/lastBuild/api/json" ${token} 200 60 "Timed out waiting for build to be created..."

  echo "Waiting for build to start..."
  do_until_json "http://localhost/job/containers-quickstarts/job/${AGENT}/lastBuild/api/json" ${token} ".building" "true" 60 "Timed out waiting for build to start..."

  echo "Build in progress..."
  timeout=0
  while [[ $(curl -s http://localhost/job/containers-quickstarts/job/${AGENT}/lastBuild/api/json --user admin:${token} | jq -r '.building') == "true" ]]
  do
    if [[ ${timeout} -eq 60 ]]
    then
      echo "## Things are taking a while... lets check on the logs..."
      kubectl logs --tail=-1 -l app.kubernetes.io/component=jenkins-controller -n jenkins
    fi

    if [[ ${timeout} -gt 300 ]]
    then
      echo "Timed out waiting for build to finish..."
      echo "## Build logs"
      get_build_logs

      echo "## Pods"
      kubectl get pods -n jenkins
      kubectl get events -n jenkins

      echo "## Controller logs"
      kubectl logs --tail=-1 -l app.kubernetes.io/component=jenkins-controller -n jenkins

      echo "## Agent logs"
      kubectl logs --tail=-1 -l jenkins/jenkins-jenkins-agent=true -n jenkins
      exit 1
    fi

    sleep 2
    let "timeout += 2"
  done

  get_build_logs

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
