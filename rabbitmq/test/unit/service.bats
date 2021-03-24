
#!/usr/bin/env bats

load _helpers

@test "service: enabled by default" {
  cd $(chart_dir)
  local service=$(helm template -s templates/service.yaml \
  . | yq r - --length)
  [ ${service} -gt 0 ]
}

@test "service: name match release name" {
  cd $(chart_dir)
  local service_name=$(helm template "$(name_prefix)" -s templates/service.yaml \
  . | yq r - 'metadata.name')
  [ "${service_name}" == "$(name_prefix)" ]
}

# ports
@test "service: default ports" {
  cd $(chart_dir)
  local service_ports=$(helm template -s templates/service.yaml \
  . | yq r - --length 'spec.ports')
  [ ${service_ports} -eq 3 ]
}

@test "service: default port names" {
  cd $(chart_dir)
  local service_ports=$(helm template -s templates/service.yaml \
  . | yq r - 'spec.ports')

  local http_port=$(echo "${service_ports}" | yq r - '[0].name')
  [ "${http_port}" == "http" ]

  local amqp_port=$(echo "${service_ports}" | yq r - '[1].name')
  [ "${amqp_port}" == "amqp" ]

  local prom_port=$(echo "${service_ports}" | yq r - '[2].name')
  [ "${prom_port}" == "prometheus" ]
}

@test "service: custom port names" {
  cd $(chart_dir)
  local service_ports=$(helm template -s templates/service.yaml \
  --set 'service.ports[0].name=custom1' \
  --set 'service.ports[1].name=custom2' \
  --set 'service.ports[2].name=custom3' \
  . | yq r - 'spec.ports')

  local port1=$(echo "${service_ports}" | yq r - '[0].name')
  [ "${port1}" == "custom1" ]

  local port2=$(echo "${service_ports}" | yq r - '[1].name')
  [ "${port2}" == "custom2" ]

  local port3=$(echo "${service_ports}" | yq r - '[2].name')
  [ "${port3}" == "custom3" ]
}

@test "service: default port numbers" {
  cd $(chart_dir)
  local service_ports=$(helm template -s templates/service.yaml \
  . | yq r - 'spec.ports')

  local http_port=$(echo "${service_ports}" | yq r - '[0].port')
  [ "${http_port}" == "15672" ]

  local amqp_port=$(echo "${service_ports}" | yq r - '[1].port')
  [ "${amqp_port}" == "5672" ]

  local prom_port=$(echo "${service_ports}" | yq r - '[2].port')
  [ "${prom_port}" == "15692" ]
}

@test "service: custom port numbers" {
  cd $(chart_dir)
  local service_ports=$(helm template -s templates/service.yaml \
  --set 'service.ports[0].port=1' \
  --set 'service.ports[1].port=2' \
  --set 'service.ports[2].port=3' \
  . | yq r - 'spec.ports')

  local port1=$(echo "${service_ports}" | yq r - '[0].port')
  [ "${port1}" == "1" ]

  local port2=$(echo "${service_ports}" | yq r - '[1].port')
  [ "${port2}" == "2" ]

  local port3=$(echo "${service_ports}" | yq r - '[2].port')
  [ "${port3}" == "3" ]
}

# type
@test "service: default service type" {
  cd $(chart_dir)
  local service_type=$(helm template -s templates/service.yaml \
  . | yq r - 'spec.type')
  [ "${service_type}" == "ClusterIP" ]
}

@test "service: custom service type" {
  cd $(chart_dir)
  local service_type=$(helm template -s templates/service.yaml \
  --set 'service.type=NodePort' \
  . | yq r - 'spec.type')
  [ "${service_type}" == "NodePort" ]
}
