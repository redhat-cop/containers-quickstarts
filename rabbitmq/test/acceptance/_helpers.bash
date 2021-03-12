name_prefix() {
  printf "rabbitmq"
}

chart_dir() {
  echo ${BATS_TEST_DIRNAME}/../../chart
}

# Create/Delete project
project_action() {
  ACTION=$1
  PROJECT="rabbitmq-acceptance-${2}"

  if [ "${ACTION}" == "create" ]; then
    oc new-project ${PROJECT}
  elif [ "${ACTION}" == "delete" ]; then
    oc delete pod -l app.kubernetes.io/name=$(name_prefix) --ignore-not-found=true
    oc delete pvc -l app.kubernetes.io/name=$(name_prefix) --ignore-not-found=true
    oc delete project ${PROJECT}
  fi
}

# If running inside a pod, authenticate to k8s/ocp
ocp_auth() {
  SA_PATH=/run/secrets/kubernetes.io/serviceaccount
  if [[ -f ${SA_PATH}/token && -n "${OCP_AUTH}" ]]; then
    export KUBECONFIG=/tmp/.kube/config
    oc login --token $(cat ${SA_PATH}/token) \
      --server https://kubernetes.default.svc \
      --certificate-authority ${SA_PATH}/ca.crt
  fi
}

# wait for a pod to be ready
wait_for_running() {
    POD_NAME=$1

    check() {
        # This requests the pod and checks whether the status is running
        # and the ready state is true. If so, it outputs the name. Otherwise
        # it outputs empty. Therefore, to check for success, check for nonzero
        # string length.
        oc get pods $1 -o json | \
            jq -r 'select(
                .status.phase == "Running" and
                ([ .status.conditions[] | select(.type == "Ready" and .status == "True") ] | length) == 1
            ) | .metadata.namespace + "/" + .metadata.name'
    }

    for i in $(seq 240); do
        if [ -n "$(check ${POD_NAME})" ]; then
            echo "${POD_NAME} is ready."
            sleep 5
            return
        fi

        echo "Waiting for ${POD_NAME} to be ready..."
        sleep 2
    done

    echo "${POD_NAME} never became ready."
    exit 1
}
