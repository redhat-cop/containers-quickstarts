#!/bin/bash
trap "exit 1" TERM
export TOP_PID=$$
NAMESPACE="${2:-rabbitmq-tests}"
REPO="${3:-redhat-cop/containers-quickstarts}"
BRANCH="${4:-master}"

TEST_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. ${TEST_DIR}/common.sh

applier() {
  echo "${BRANCH}"
  echo "${REPO}"
  cd rabbitmq
  ansible-galaxy install -r requirements.yml -p galaxy --force
  ansible-playbook -i .applier/ galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml -e namespace=${NAMESPACE} -e repository_ref=${BRANCH} -e repository_url=https://github.com/${REPO}
}

test() {
  # Make sure we're logged in, and we've found at least one build to test.
  oc status > /dev/null || echo "Please log in before running tests." || exit 1

  echo "Ensure build is executed..."
  for bc in $(oc get bc -n ${NAMESPACE} -o jsonpath='{.items[*].metadata.name}'); do
    if [ "$(oc get build -n ${NAMESPACE} -o jsonpath="{.items[?(@.metadata.annotations.openshift\.io/build-config\.name==\"${bc}\")].metadata.name}")" == "" ]; then
      oc start-build ${bc} -n ${NAMESPACE}
    fi
  done

  echo "Waiting for all builds to start..."
  while [[ "$(get_build_phases "New")" -ne 0 || $(get_build_phases "Pending") -ne 0 ]]; do
    echo -ne "New Builds: $(get_build_phases "New"), Pending Builds: $(get_build_phases "Pending")\r"
    sleep 1
  done

  echo "Waiting for build to complete..."
  while [ $(get_build_phases "Running") -ne 0 ]; do
    echo -ne "Running Builds: $(get_build_phases "Running")\r"
    sleep 1
  done

  echo "Check to see if build failed"
  if [ $(get_build_phases "Failed") -ne 0 ]; then
    echo "Some builds failed. Printing Report"
    retry 5 oc get builds -n $NAMESPACE -o custom-columns=NAME:.metadata.name,TYPE:.spec.strategy.type,FROM:.spec.source.type,STATUS:.status.phase,REASON:.status.reason
    exit 1
  fi

  echo "Waiting for for all pods to start..."
  try_until 60 15 true "oc get sts/rabbitmq -n $NAMESPACE --template '{{ if .status.readyReplicas }}{{ eq .spec.replicas .status.readyReplicas }}{{ else }}false{{ end }}'" || kill -s TERM $TOP_PID

  # Tests for issue #311
  echo "Ensure 'hostname' package is installed"
  hostname_rpm=$(oc -n $NAMESPACE rsh rabbitmq-0 rpm -q hostname)
  if [ $? -eq 0 ]; then
    echo "OK: RPM package 'hostname' installed"
  else
    echo "NOK: RPM package 'hostname' not installed"
    exit 1
  fi

  echo "Ensure locale is set to UTF-8"
  lang_var=$(oc -n $NAMESPACE rsh rabbitmq-0 printenv LANG)
  if [[ "$lang_var" =~ "en_US.UTF-8" ]]; then
    echo "OK: Locale is set to 'en_US.UTF-8'"
  else
    echo "LANG: ===$lang_var==="
    echo "NOK: Locale is set to ${lang_var}, should be 'en_US.UTF-8'"
    exit 1
  fi

  echo "Check RabbitMQ cluster status..."
  sts_json=$(oc get sts/rabbitmq -n $NAMESPACE -o json)
  replicas=$(jq '.spec.replicas' <<< $(echo $sts_json))
  cluster_status=$(oc -n $NAMESPACE rsh rabbitmq-0 rabbitmqctl cluster_status --formatter json | tail -1)
  if [ $(jq '.alarms|length' <<< $(echo $cluster_status)) -eq 0 ]; then
    echo "OK: no RabbitMQ cluster alarms"
  else
    echo "NOK: there are RabbitMQ cluster alarms"
    exit 1
  fi

  if [ $(jq '.running_nodes|length' <<< $(echo $cluster_status)) -eq $replicas ]; then
    echo "OK: there are $replicas running nodes in the cluster"
  else
    echo "NOK: there are not $replicas running nodes in the cluster"
    exit 1
  fi

  echo "Tests Completed Successfully!"
}

# Process arguments
case $1 in
  applier)
    applier
    ;;
  test)
    test
    ;;
  *)
    echo "Not an option"
    exit 1
esac
