
#!/usr/bin/env bats

load _helpers

@test "rolebinding: default serviceaccount" {
  cd $(chart_dir)
  local service_account=$(helm template "$(name_prefix)" -s templates/rolebinding.yaml \
  . | yq r - 'subjects[0].name')
  [ "${service_account}" == "$(name_prefix)" ]
}

@test "rolebinding: custom serviceaccount" {
  cd $(chart_dir)
  local service_account=$(helm template -s templates/rolebinding.yaml \
  --set 'serviceAccount.name=custom' \
  . | yq r - 'subjects[0].name')
  [ "${service_account}" == "custom" ]
}
