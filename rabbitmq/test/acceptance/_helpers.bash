name_prefix() {
  printf "rabbitmq"
}

chart_dir() {
  echo ${BATS_TEST_DIRNAME}/../../chart
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
