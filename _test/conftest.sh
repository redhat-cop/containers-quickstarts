#!/usr/bin/env bats

load _helpers

@test ".openshift" {
  run conftest test .openshift --output tap

  [ "$status" -eq 0 ]
}

@test "build-docker-generic/.openshift" {
  run conftest test build-docker-generic/.openshift --output tap

  [ "$status" -eq 0 ]
}


@test "build-s2i-executable/.openshift" {
  run conftest test build-s2i-executable/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "build-s2i-gows/.openshift" {
  run conftest test build-s2i-gows/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "build-s2i-jekyll/.openshift" {
  run conftest test build-s2i-jekyll/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "build-s2i-liberty/.openshift" {
  run conftest test build-s2i-liberty/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "build-s2i-play/.openshift" {
  run conftest test build-s2i-play/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "eap/chart" {
  helm_template "eap/chart" "--set sourceUri=conftest"

  run conftest test /tmp/eap/chart/eap72/templates --output tap

  [ "$status" -eq 0 ]
}

@test "gitlab-ce/.openshift" {
  run conftest test gitlab-ce/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "gogs/.openshift" {
  run conftest test gogs/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "hoverfly/.openshift" {
  run conftest test hoverfly/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "hygieia/.openshift" {
  run conftest test hygieia/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "ipa-server/.openshift" {
  run conftest test ipa-server/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "jenkins-masters/hygieia-plugin/.openshift" {
  run conftest test jenkins-masters/hygieia-plugin/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "mongodb/.openshift" {
  run conftest test mongodb/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "motepair" {
  helm_template "motepair"

  run conftest test /tmp/motepair/motepair/templates --output tap

  [ "$status" -eq 0 ]
}

@test "nexus/chart/nexus" {
  helm_template "nexus/chart/nexus" "--dependency-update"

  run conftest test /tmp/nexus/chart/nexus/nexus/charts/sonatype-nexus --output tap

  [ "$status" -eq 0 ]
}

@test "ocp4-logging/.openshift" {
  run conftest test ocp4-logging/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "rabbitmq/.openshift" {
  run conftest test rabbitmq/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "rabbitmq/chart" {
  helm_template "rabbitmq/chart"

  run conftest test /tmp/rabbitmq/chart/RabbitMQ/templates --output tap

  [ "$status" -eq 0 ]
}

@test "sonarqube/.openshift" {
  run conftest test sonarqube/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "ubi7-gitlab-runner/.openshift" {
  run conftest test ubi7-gitlab-runner/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "utilities/ubi8-asciidoctor/.openshift" {
  run conftest test utilities/ubi8-asciidoctor/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "utilities/ubi8-git/.openshift" {
  run conftest test utilities/ubi8-git/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "utilities/ubi8-google-api-python-client/.openshift" {
  run conftest test utilities/ubi8-google-api-python-client/.openshift --output tap

  [ "$status" -eq 0 ]
}

@test "zalenium/.openshift" {
  run conftest test zalenium/.openshift --output tap

  [ "$status" -eq 0 ]
}