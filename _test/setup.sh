NAMESPACE=containers-quickstarts-tests

cluster_up() {
  set +e
  built=false
  while true; do
    DEV=$(ip link | awk '/state UP/{ gsub(":", ""); print $2}')
    IP_ADDR=$(ip addr show $DEV | awk '/inet /{ gsub("/.*", ""); print $2}')
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

setup() {
  echo "${TRAVIS_BRANCH:=master}"
  echo "${TRAVIS_REPO_SLUG:=redhat-cop/containers-quickstarts}"
  ansible-galaxy install -r jenkins-slaves/requirements.yml -p galaxy
  ansible-playbook -i jenkins-slaves/.applier/ galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml -e namespace=containers-quickstarts-tests -e slave_repo_ref=${TRAVIS_BRANCH} -e repository_url=https://github.com/${TRAVIS_REPO_SLUG}.git
}

get_build_phases() {
  phase=$1
  oc get builds -o jsonpath="{.items[?(@.status.phase==\"${phase}\")]}" -n $NAMESPACE | wc -w
}

test() {
  # Wait for builds to start
  while [ $(get_build_phases "New") -ne 0 ]; do
    sleep 1
  done

  # Wait for all builds to complete
  while [ $(get_build_phases "Running") -ne 0 ]; do
    sleep 1
  done

  # Check to see how many builds Failed
  if [ $(get_build_phases "Failed") -ne 0 ]; then
    "Some builds failed. Printing Report"
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
  setup)
    setup
    ;;
  test)
    test
    ;;
  *)
    echo "Not an option"
    exit 1
esac
