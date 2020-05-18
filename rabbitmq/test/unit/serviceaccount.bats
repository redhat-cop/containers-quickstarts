
#!/usr/bin/env bats

load _helpers

@test "serviceaccount: enabled by default" {
  cd $(chart_dir)
  local service_account=$(helm template -s templates/serviceaccount.yaml \
  . | yq r - --length)
  [ ${service_account} -gt 0 ]
}

@test "serviceaccount: default annotations" {
  cd $(chart_dir)
  local annotations=$(helm template -s templates/serviceaccount.yaml \
  . | yq r - 'metadata.annotations')
  [ -z "${annotations}" ]
}

@test "serviceaccount: custom annotations" {
  cd $(chart_dir)
  local annotations=$(helm template -s templates/serviceaccount.yaml \
  --set 'serviceAccount.annotations.custom=true' \
  . | yq r - 'metadata.annotations.custom')
  [ "${annotations}" == "true" ]
}

@test "serviceaccount: default name" {
  cd $(chart_dir)
  local name=$(helm template "$(prefix_name)" -s templates/serviceaccount.yaml \
  . | yq r - 'metadata.name')
  [ "${name}" == "$(prefix_name)" ]
}

@test "serviceaccount: custom name" {
  cd $(chart_dir)
  local name=$(helm template "custom" -s templates/serviceaccount.yaml \
  --set 'serviceAccount.name=custom' \
  . | yq r - 'metadata.name')
  [ "${name}" == "custom" ]
}
