#!/usr/bin/env bats

load _helpers

@test "configmap: three config files defined" {
  cd $(chart_dir)
  local config_files=$(helm template -s templates/configmap.yaml . | yq r - --collect --length 'data.*')
  [ "${config_files}" == "3" ]
}
