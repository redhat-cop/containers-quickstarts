#!/usr/bin/env bats

load _helpers

# image
@test "statefulset: image defaults to image.repository:Chart.AppVersion" {
  cd $(chart_dir)
  local image=$(helm template -s templates/deployment.yaml \
  . | yq r - 'spec.template.spec.containers[0].image')
  [ "${image}" == "quay.io/redhat-cop/rabbitmq:$(app_version)" ]
}

@test "statefulset: custom image repository" {
  cd $(chart_dir)
  local image=$(helm template -s templates/deployment.yaml --set 'image.repository=test' \
  . | yq r - 'spec.template.spec.containers[0].image')
  [ "${image}" == "test:$(app_version)" ]
}

# imagePullPolicy
@test "statefulset: default imagePullPolicy" {
  cd $(chart_dir)
  local pull_policy=$(helm template -s templates/deployment.yaml \
  . | yq r - 'spec.template.spec.containers[0].imagePullPolicy')
  [ "${pull_policy}" == "IfNotPresent" ]
}

@test "statefulset: custom imagePullPolicy" {
  cd $(chart_dir)
  local pull_policy=$(helm template -s templates/deployment.yaml --set 'image.pullPolicy=Always' \
  . | yq r - 'spec.template.spec.containers[0].imagePullPolicy')
  [ "${pull_policy}" == "Always" ]
}

# imagePullSecrets
@test "statefulset: default imagePullSecrets" {
  cd $(chart_dir)
  local pull_secrets=$(helm template -s templates/deployment.yaml \
  . | yq r - 'spec.template.spec.imagePullSecrets')
  [ -z "${pull_secrets}" ]
}

@test "statefulset: custom imagePullSecrets" {
  cd $(chart_dir)
  local pull_secrets=$(helm template -s templates/deployment.yaml \
  --set 'imagePullSecrets[0].name=one' \
  --set 'imagePullSecrets[1].name=two' \
  . | yq r - 'spec.template.spec.imagePullSecrets')

  local length=$(echo "${pull_secrets}" | yq r - --length)
  [ "${length}" == "2" ]

  local first=$(echo "${pull_secrets}" | yq r - '[0].name')
  [ "${first}" == "one" ]

  local second=$(echo "${pull_secrets}" | yq r - '[1].name')
  [ "${second}" == "two" ]
}

# replicas
@test "statefulset: default replicas" {
  cd $(chart_dir)
  local replicas=$(helm template -s templates/deployment.yaml \
  . | yq r - 'spec.replicas')
  [ "${replicas}" == "3" ]
}

@test "statefulset: custom replicas" {
  cd $(chart_dir)
  local replicas=$(helm template -s templates/deployment.yaml \
  --set 'replicaCount=5' \
  . | yq r - 'spec.replicas')
  [ "${replicas}" == "5" ]
}

# resources
@test "statefulset: default resources" {
  cd $(chart_dir)
  local resources=$(helm template -s templates/deployment.yaml \
  . | yq r - 'spec.template.spec.containers[0].resources')

  local limits_cpu=$(echo "${resources}" | yq r - 'limits.cpu')
  [ "${limits_cpu}" == "1000m" ]

  local limits_memory=$(echo "${resources}" | yq r - 'limits.memory')
  [ "${limits_memory}" == "2Gi" ]

  local requests_cpu=$(echo "${resources}" | yq r - 'requests.cpu')
  [ "${requests_cpu}" == "300m" ]

  local requests_memory=$(echo "${resources}" | yq r - 'requests.memory')
  [ "${requests_memory}" == "1Gi" ]
}

@test "statefulset: custom resources" {
  cd $(chart_dir)
  local resources=$(helm template -s templates/deployment.yaml \
  --set 'resources.limits.cpu=🐿️' \
  --set 'resources.limits.memory=🍌' \
  --set 'resources.requests.cpu=🦐' \
  --set 'resources.requests.memory=😻' \
  . | yq r - 'spec.template.spec.containers[0].resources')

  local limits_cpu=$(echo "${resources}" | yq r - 'limits.cpu')
  [ "${limits_cpu}" == "🐿️" ]

  local limits_memory=$(echo "${resources}" | yq r - 'limits.memory')
  [ "${limits_memory}" == "🍌" ]

  local requests_cpu=$(echo "${resources}" | yq r - 'requests.cpu')
  [ "${requests_cpu}" == "🦐" ]

  local requests_memory=$(echo "${resources}" | yq r - 'requests.memory')
  [ "${requests_memory}" == "😻" ]
}

# nodeSelector
@test "statefulset: default nodeselector" {
  cd $(chart_dir)
  local node_selector=$(helm template -s templates/deployment.yaml \
  . | yq r - 'spec.template.spec.nodeSelector')
  [ -z "${node_selector}" ]
}

@test "statefulset: custom nodeselector" {
  cd $(chart_dir)
  local node_selector=$(helm template -s templates/deployment.yaml \
  --set 'nodeSelector.name=one' \
  . | yq r - 'spec.template.spec.nodeSelector.name')
  [ "${node_selector}" == "one" ]
}

# affinity
@test "statefulset: default affinity" {
  cd $(chart_dir)
  local affinity=$(helm template -s templates/deployment.yaml \
  . | yq r - 'spec.template.spec.affinity')
  [ -n "${affinity}" ]

  local pod_anti_affinity=$(echo "${affinity}" | yq r - -p p 'podAntiAffinity.*')
  [ "${pod_anti_affinity}" == "podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution" ]

  local match_key=$(echo "${affinity}" | yq r - \
  "${pod_anti_affinity}[0].labelSelector.matchExpressions[0].key")
  [ "${match_key}" == "app.kubernetes.io/name" ]

  local match_values=$(echo "${affinity}" | yq r - \
  "${pod_anti_affinity}[0].labelSelector.matchExpressions[0].values[0]")
  [ "${match_values}" == "$(name_prefix)" ]

  local topology_key=$(echo "${affinity}" | yq r - "${pod_anti_affinity}[0].topologyKey")
  [ "${topology_key}" == "kubernetes.io/hostname" ]
}

@test "statefulset: custom affinity settings" {
  cd $(chart_dir)
  local affinity=$(helm template -s templates/deployment.yaml \
  --set 'ha.label.key=statefulset' \
  --set 'ha.label.value=custom' \
  --set 'ha.topologyKey=kubernetes.io/instance' \
  . | yq r - 'spec.template.spec.affinity')
  [ -n "${affinity}" ]

  local pod_anti_affinity=$(echo "${affinity}" | yq r - -p p 'podAntiAffinity.*')
  [ "${pod_anti_affinity}" == "podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution" ]

  local match_key=$(echo "${affinity}" | yq r - \
  "${pod_anti_affinity}[0].labelSelector.matchExpressions[0].key")
  [ "${match_key}" == "statefulset" ]

  local match_values=$(echo "${affinity}" | yq r - \
  "${pod_anti_affinity}[0].labelSelector.matchExpressions[0].values[0]")
  [ "${match_values}" == "custom" ]

  local topology_key=$(echo "${affinity}" | yq r - "${pod_anti_affinity}[0].topologyKey")
  [ "${topology_key}" == "kubernetes.io/instance" ]
}

# securityContext
@test "statefulset: default securitycontext" {
  cd $(chart_dir)
  local security_context=$(helm template -s templates/deployment.yaml \
  . | yq r - 'spec.template.spec.containers[0].securityContext')
  [ "${security_context}" == "{}" ]
}

@test "statefulset: custom securitycontext" {
  cd $(chart_dir)
  local security_context=$(helm template -s templates/deployment.yaml \
  --set 'securityContext.capabilities.drop[0]=ALL' \
  . | yq r - 'spec.template.spec.containers[0].securityContext.capabilities.drop[0]')
  [ "${security_context}" == "ALL" ]
}

# podSecurityContext
@test "statefulset: default podsecuritycontext" {
  cd $(chart_dir)
  local pod_security_context=$(helm template -s templates/deployment.yaml \
  . | yq r - 'spec.template.spec.securityContext')
  [ "${pod_security_context}" == "{}" ]
}

@test "statefulset: custom podsecuritycontext" {
  cd $(chart_dir)
  local pod_security_context=$(helm template -s templates/deployment.yaml \
  --set 'podSecurityContext.fsGroup=2000' \
  . | yq r - 'spec.template.spec.securityContext.fsGroup')
  [ "${pod_security_context}" == "2000" ]
}

# serviceAccount
@test "statefulset: default serviceaccountname" {
  cd $(chart_dir)
  local service_account=$(helm template -s templates/deployment.yaml \
  . | yq r - 'spec.template.spec.serviceAccountName')
  [ "${service_account}" == "RELEASE-NAME-$(name_prefix)" ]
}

@test "statefulset: custom serviceaccountname" {
  cd $(chart_dir)
  local service_account=$(helm template -s templates/deployment.yaml \
  --set 'serviceAccount.name=custom' \
  . | yq r - 'spec.template.spec.serviceAccountName')
  [ "${service_account}" == "custom" ]
}

@test "statefulset: default create serviceaccountname false" {
  cd $(chart_dir)
  local service_account=$(helm template -s templates/deployment.yaml \
  --set 'serviceAccount.create=false' \
  . | yq r - 'spec.template.spec.serviceAccountName')
  [ "${service_account}" == "default" ]
}

@test "statefulset: custom create serviceaccountname false" {
  cd $(chart_dir)
  local service_account=$(helm template -s templates/deployment.yaml \
  --set 'serviceAccount.create=false' \
  --set 'serviceAccount.name=custom' \
  . | yq r - 'spec.template.spec.serviceAccountName')
  [ "${service_account}" == "custom" ]
}

# tolerations
@test "statefulset: default tolerations" {
  cd $(chart_dir)
  local tolerations=$(helm template -s templates/deployment.yaml \
  . | yq r - 'spec.template.spec.tolerations')
  [ -z "${tolerations}" ]
}

@test "statefulset: custom tolerations" {
  cd $(chart_dir)
  local tolerations=$(helm template -s templates/deployment.yaml \
  --set 'tolerations[0].key=key1' \
  . | yq r - 'spec.template.spec.tolerations[0].key')
  [ "${tolerations}" == "key1" ]
}
