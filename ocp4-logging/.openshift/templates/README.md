# ClusterLogging Template

Below you can see the parameters that are available for the `ClusterLogging` template. This will show their name, a description and the defaults if applicable

## Parameters

| Name      | Description   | Default |
| ----------- | ----------- | ------- |
| ELASTICSEARCH_REDUNDANCY_POLICY | Sharding policy to be used with Elasticsearch (FullRedundancy, MultipleRedundancy, SingleRedundancy, ZeroRedundancy) | SingleRedundancy
| ELASTICSEARCH_NODE_COUNT | Number of Elasticsearch node to deploy        | 2 |
| ELASTICSEARCH_NODE_SELECTOR | Selector to use to place Elasticsearch nodes on the appropriate OCP nodes | node-role.kubernetes.io/worker |
| ELASTICSEARCH_MEMORY_LIMIT | The maximum amount of memory allowed to be used by an Elasticsearch pod | 2Gi |
| ELASTICSEARCH_MEMORY_REQUEST | The amount of memory to request for each Elasticsearch pod| 2Gi |
| ELASTICSEARCH_CPU_REQUEST | The amount of CPU to request for each Elasticsearch pod | 200m |
| ELASTICSEARCH_STORAGE_CLASS | Storage class to use to create persistent volume for Elasticsearch | N/A | 
| ELASTICSEARCH_VOLUME_CAPACITY | Size of the volume to create to store Elasticsearch data | 10Gi |
| KIBANA_MEMORY_LIMIT | The maximum amount of memory that can be used by a Kibana pod | 1Gi |
| KIBANA_MEMORY_REQUEST| The amount of memory to request for a Kibana pod| 1Gi |
| KIBANA_CPU_REQUEST | The amount of CPU to request for each Kibana pod  | 500m |
| KIBANA_PROXY_MEMORY_LIMIT | The maximum amount of memory that can be used by the Kibana proxy | 100Mi |
| KIBANA_PROXY_MEMORY_REQUEST | The amount of memory to request for the Kibana proxy | 100Mi |
| KIBANA_PROXY_CPU_REQUEST | The amount of CPU to request for the Kibana proxy | 100m |
| KIBANA_NODE_COUNT | Number of Kibana nodes to create | 2 |
| KIBANA_NODE_SELECTOR | Selector to use to place Kibana on the appropriate OCP nodes | node-role.kubernetes.io/worker |
| CURATOR_MEMORY_LIMIT | The maximum amount of memory that can be used by the Curator pod | 200Mi |
| CURATOR_MEMORY_REQUEST | The amount of memory to request for the Curator pod | 200Mi |
| CURATOR_CPU_REQUEST | The amount of CPU to request for the Curator pod | 200m |
| CURATOR_SCHEDULE | The cron schedule that the Curator cleanup job should run on | 30 3 * * * |
| CURATOR_NODE_SELECTOR | Selector to use to place the Curator on the appropriate OCP nodes | node-role.kubernetes.io/worker |
| FLUENTD_MEMORY_LIMIT | The maximum amount of memory that can be used by a Fluentd pod | 1Gi
| FLUENTD_MEMORY_REQUEST | The amount of memory to request for a Fluentd pod |1Gi |
| FLUENTD_CPU_REQUEST | The amount of CPU to request for a Fluentd pod | 200m |
