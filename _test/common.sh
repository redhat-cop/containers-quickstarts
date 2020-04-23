# This file contains common functions for other test scripts
#

get_build_phases() {
  phase=$1
  result=$(retry 5 oc get builds -o jsonpath="{.items[?(@.status.phase==\"${phase}\")].metadata.name}" -n $NAMESPACE) || kill -s TERM $TOP_PID
  echo ${result} | wc -w
}

get_build_phase_for() {
  name=$1
  result=$(retry 5 oc get builds ${name} -o jsonpath="{.status.phase}" -n $NAMESPACE) || kill -s TERM $TOP_PID
  echo ${result}
}

get_buildnumber_for() {
  name=$1
  result=$(retry 5 oc get buildconfigs ${name} -o jsonpath="{.status.lastVersion}" -n $NAMESPACE) || kill -s TERM $TOP_PID
  echo ${result}
}

download_jenkins_logs_for_failed() {
  jobs=$1
  expectedphase=$2

  echo
  echo "Checking jobs which should have an expected phase of ${expectedphase}..."

  jenkins_url=$(oc get route jenkins -n ${NAMESPACE} -o jsonpath='{ .spec.host }')
  token=$(oc whoami --show-token)

  for pipeline in ${jobs}; do
    build_number=$(get_buildnumber_for ${pipeline})
    build="${pipeline}-${build_number}"

    phase=$(get_build_phase_for ${build})
    if [[ "${expectedphase}" != "${phase}" ]]; then
      echo ""
      echo "Downloading Jenkins logs for ${build} as phase (${phase}) does not match expected (${expectedphase})..."
      curl -k -sS -H "Authorization: Bearer ${token}" "https://${jenkins_url}/blue/rest/organizations/jenkins/pipelines/${NAMESPACE}/pipelines/${NAMESPACE}-${pipeline}/runs/${build_number}/log/?start=0&download=true" -o "${pipeline}.log"

      echo "## START LOGS: ${build}"
      cat "${pipeline}.log"
      echo "## END LOGS: ${build}"
    fi
  done
}

download_build_logs_for_failed() {
  buildConfigs=$1
  expectedphase=$2

  echo
  echo "Checking jobs which should have an expected phase of ${expectedphase}..."

  for bc in ${buildConfigs}; do
    build_number=$(get_buildnumber_for ${bc})
    build="${bc}-${build_number}"

    phase=$(get_build_phase_for ${build})
    if [[ "${expectedphase}" != "${phase}" ]]; then
      echo "## START LOGS: ${build}"
      oc logs build/${build} -n ${NAMESPACE}
      echo "## END LOGS: ${build}"
    fi
  done
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

try_until() {
  local retries=$1
  local wait=$2
  local result=$3
  local statement=$4
  local count=0

  until [ $(eval $statement) == $result ]; do
    count=$((count + 1))
    if [ $count -lt $retries ]; then
      echo "Retry $count/$retries exited, retrying in $wait seconds..."
      sleep $wait
    else
      echo "Retry $count/$retries exited, no more retries left."
      exit 1
    fi
  done
}
