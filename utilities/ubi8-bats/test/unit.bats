#!/usr/bin/env bats

@test "bats: version" {
  run bats --version
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Bats 1.2.0" ]
}

@test "helm: version" {
  run helm version
  [ "${status}" -eq 0 ]
  [[ "${lines[0]}" =~ v3.2.1 ]]
}

@test "jq: version" {
  run jq --version
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "jq-1.6" ]
}

@test "oc: version" {
  run oc version
  [ "${status}" -eq 0 ]
  [[ "${lines[0]}" =~ 4.4 ]]
}

@test "yq: version" {
  run yq --version
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "yq version 3.3.0" ]
}
