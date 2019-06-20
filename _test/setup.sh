#!/bin/bash
trap "exit 1" TERM
export TOP_PID=$$
NAMESPACE=containers-quickstarts-tests

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
  echo "${TRAVIS_BRANCH:=master}"
  echo "${TRAVIS_REPO_SLUG:=redhat-cop/containers-quickstarts}"
  ansible-galaxy install -r requirements.yml -p galaxy --force
  ansible-playbook -i .applier/ galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml -e namespace=containers-quickstarts-tests -e slave_repo_ref=${TRAVIS_BRANCH} -e repository_url=https://github.com/${TRAVIS_REPO_SLUG}.git
}

get_build_phases() {
  phase=$1
  oc get builds -o jsonpath{}="{.items[?(@.status.phase==\"${phase}\")].metadata.name}" -n $NAMESPACE || kill -s TERM $TOP_PID | wc -w
}

test() {
  #oc status || exit 1

  echo "Ensure all Builds are executed..."
  for pipeline in $(oc get bc -n ${NAMESPACE} -o jsonpath='{.items[*].metadata.name}'); do
    if [ "$(oc get build -n containers-quickstarts-tests -o jsonpath="{.items[?(@.metadata.annotations.openshift\.io/build-config\.name==\"${pipeline}\")].metadata.name}")" == "" ]; then
      oc start-build ${pipeline} -n ${NAMESPACE}
    fi
  done

  echo "Waiting for all builds to start..."
  while [[ $(get_build_phases "New") -ne 0 || $(get_build_phases "Pending") -ne 0 ]]; do
    echo -ne "New Builds: $(get_build_phases "New"), Pending Builds: $(get_build_phases "Pending")\r"
    sleep 1
  done

  echo "Waiting for all builds to complete..."
  while [ $(get_build_phases "Running") -ne 0 ]; do
    echo -ne "Running Builds: $(get_build_phases "Running")\r"
    sleep 1
  done

  echo "Check to see how many builds Failed"
  if [ $(get_build_phases "Failed") -ne 0 ]; then
    echo "Some builds failed. Printing Report"
    oc get builds -n $NAMESPACE -o custom-columns=NAME:.metadata.name,TYPE:.spec.strategy.type,FROM:.spec.source.type,STATUS:.status.phase,REASON:.status.reason
    exit 1
  fi

  echo "Tests Completed Successfully!"
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
    test
    ;;
  *)
    echo "Not an option"
    exit 1
esac
