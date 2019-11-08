# This file contains common functions for other test scripts
#

get_build_phases() {
  phase=$1
  result=$(retry 5 oc get builds -o jsonpath="{.items[?(@.status.phase==\"${phase}\")].metadata.name}" -n $NAMESPACE) || kill -s TERM $TOP_PID
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
