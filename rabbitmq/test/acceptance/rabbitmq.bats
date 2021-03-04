#!/usr/bin/env bats

JOB_ID=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 5 | head -1)

load _helpers


setup_file() {
  ocp_auth

  cd $(chart_dir)

  project_action create $JOB_ID

  helm install "$(name_prefix)" . --namespace rabbitmq-acceptance-${JOB_ID}
  wait_for_running $(name_prefix)-2
}

@test "rabbitmq/ha: should have 'hostname' package installed" {
  # Test issue #311
  local hostname_installed=$(oc exec "$(name_prefix)-0" -- rpm -q hostname)
  [ "$?" == "0" ]
}

@test "rabbitmq/ha: should have \$LANG set to 'en_US.UTF-8'" {
  # Ensure locale is set to UTF-8
  lang_var=$(oc exec "$(name_prefix)-0" -- printenv LANG)
  [ "${lang_var}" == "en_US.UTF-8" ]
}

@test "rabbitmq/ha: should not have any alarms" {
  # RabbitMQ cluster status
  local cluster_alarms=$(oc exec "$(name_prefix)-0" -- rabbitmqctl cluster_status --formatter json | tail -1 | jq '.alarms|length')
  [ "${cluster_alarms}" == "0" ]
}

@test "rabbitmq/ha: fail if number of replicas aren't ready" {
  # RabbitMQ replicas
  local replicas=$(oc get statefulset "$(name_prefix)" -o jsonpath={.status.readyReplicas})
  [ "${replicas}" == "3" ]
}

@test "rabbitmq/ha: should run on different cluster nodes" {
  # RabbitMQ anti-affinity
  local cluster_nodes=$(oc get pod -l app.kubernetes.io/name=="$(name_prefix)" -o json | jq -r '[.items[].spec.nodeName]|unique|length')
  echo "${cluster_nodes}"
  [ "${cluster_nodes}" == "3" ]
}

@test "rabbitmq/ha: should have a three node cluster" {
  local cluster_replicas=$(oc exec "$(name_prefix)-0" -- rabbitmqctl cluster_status --formatter json | tail -1 | jq -r '.running_nodes|length')
  [ "${cluster_replicas}" == "3" ]
}

# Clean up
teardown_file() {
  if [[ ${CLEANUP:-true} == "true" ]]
  then
    echo "helm/pvc teardown"
    grace=$(oc get pod/rabbitmq-0 --template '{{.spec.terminationGracePeriodSeconds}}')
    helm uninstall "$(name_prefix)"
    sleep $grace
    project_action delete $JOB_ID
  fi
}
