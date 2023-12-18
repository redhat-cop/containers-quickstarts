#!/usr/bin/env bats

@test "bats: version" {
  run bats --version
  [ "${status}" -eq 0 ]
}

@test "helm: version" {
  run helm version
  [ "${status}" -eq 0 ]
}

@test "jq: version" {
  run jq --version
  [ "${status}" -eq 0 ]
}

@test "oc: version" {
  run oc version --client
  [ "${status}" -eq 0 ]
}

@test "yq: version" {
  run yq --version
  [ "${status}" -eq 0 ]
}
