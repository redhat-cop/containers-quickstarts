#!/bin/bash
trap "exit 1" TERM
export TOP_PID=$$
NAMESPACE="${2:-containers-quickstarts-tests}"
TRAVIS_REPO_SLUG="${3:-redhat-cop/containers-quickstarts}"
TRAVIS_BRANCH="${4:-master}"

TEST_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. ${TEST_DIR}/common.sh

cluster_up() {
  set +e
  built=false
  while true; do
    if [ -z $IP_ADDR ]; then
      DEV=$(ip link | awk '/state UP/{ gsub(":", ""); print $2}')
      IP_ADDR=$(ip addr show $DEV | awk '/inet /{ gsub("/.*", ""); print $2}')
    fi
    oc cluster up --public-hostname=${IP_ADDR} --routing-suffix=${IP_ADDR}.nip.io --base-dir=$HOME/ocp
    if [ "$?" -eq 0 ]; then
      built=true
      break
    fi
    echo "Retrying oc cluster up after failure"
    oc cluster down
    sleep 5
  done
  echo "OpenShift Cluster Running"
}

applier() {
  echo "${TRAVIS_BRANCH}"
  echo "${TRAVIS_REPO_SLUG}"
  ansible-galaxy install -r requirements.yml -p galaxy --force
  ansible-playbook -i .applier/ galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml -e namespace=${NAMESPACE} -e slave_repo_ref=${TRAVIS_BRANCH} -e repository_url=https://github.com/${TRAVIS_REPO_SLUG}.git
}

test() {
  build_type=$1

  # Make sure we're logged in, and we've found at least one build to test.
  oc status > /dev/null || echo "Please log in before running tests." || exit 1
  if [ $(oc get buildconfigs -n ${NAMESPACE} -o jsonpath="{.items[?(@.spec.strategy.type==\"${build_type}\")].metadata.name}" | wc -w) -lt 1 ]; then
    echo "Did not find any builds, make sure you've passed the proper arguments."
    exit 1
  fi

  echo "Ensure all ${build_type} Builds are executed..."
  for buildConfig in $(oc get buildconfig -n ${NAMESPACE} -o jsonpath="{.items[?(@.spec.strategy.type==\"${build_type}\")].metadata.name}"); do
    # Only start BuildConfigs which currently have 0 builds
    if [ "$(oc get build -n ${NAMESPACE} -o jsonpath="{.items[?(@.metadata.annotations.openshift\.io/build-config\.name==\"${buildConfig}\")].metadata.name}")" == "" ]; then
      oc start-build ${buildConfig} -n ${NAMESPACE}
    fi
  done

  echo "Waiting for all builds to start..."
  builds=$(oc get build -n ${NAMESPACE} -o jsonpath="{.items[?(@.spec.strategy.type==\"${build_type}\")].metadata.name}")
  while [[ "$(get_build_phases "New" ${builds})" -ne 0 || $(get_build_phases "Pending") -ne 0 ]]; do
    echo -ne "New Builds: $(get_build_phases "New"), Pending Builds: $(get_build_phases "Pending")$([ "$TRAVIS" != "true" ] && echo "\r" || echo "\n")"
    sleep 1
  done

  echo "Waiting for all builds to complete..."
  while [ $(get_build_phases "Running" ${builds}) -ne 0 ]; do
    echo -ne "Running Builds: $(get_build_phases "Running")$([ "$TRAVIS" != "true" ] && echo "\r" || echo "\n")"
    sleep 1
  done

  echo "Check to see how many builds Failed"
  if [ $(get_build_phases "Failed" ${builds}) -ne 0 ]; then
    echo "Some builds failed. Printing Report"
    retry 5 oc get builds -n $NAMESPACE -o custom-columns=NAME:.metadata.name,TYPE:.spec.strategy.type,FROM:.spec.source.type,STATUS:.status.phase,REASON:.status.reason

    failed_jobs=$(retry 5 oc get builds -o jsonpath="{.items[?(@.status.phase=='Failed')].metadata.annotations.openshift\.io/build-config\.name}" -n $NAMESPACE) || kill -s TERM $TOP_PID
    download_jenkins_logs_for_failed ${failed_jobs} "Complete"
    download_build_logs_for_failed ${failed_jobs} "Complete"

    exit 1
  fi

  echo "${build_type} build tests completed successfully!"
}

get_build_phases() {
  phase=$1
  shift
  targetted_builds=$@
  result=$(retry 5 oc get builds ${targetted_builds} -o jsonpath="{.items[?(@.status.phase==\"${phase}\")].metadata.name}" -n $NAMESPACE) || kill -s TERM $TOP_PID
  echo ${result} | wc -w
}

function retry {
  local retries=$1
  shift

  local count=0
  until "$@"; do
    exit=$?
    wait=$((2 ** $count))
    count=$(($count + 1))
    if [ $count -lt $retries ]; then
      echo "Retry $count/$retries exited $exit, retrying in $wait seconds..."
      sleep $wait
    else
      echo "Retry $count/$retries exited $exit, no more retries left."
      return $exit
    fi
  done
  return 0
}

# Process arguments
case $1 in
  cluster_up)
    cluster_up
    ;;
  applier)
    applier
    ;;
  test)
    test Docker || exit 1
    test JenkinsPipeline
    ;;
  *)
    echo "Not an option"
    exit 1
esac
