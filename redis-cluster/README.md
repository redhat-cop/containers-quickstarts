# Redis Cluster Integration for OpenShift Container Platform

The objetive for this repository is to deploy a Redis Cluster on top of Openshift Container Platform.

1. Create the *redis-cluster* namespace on your Cluster

        # oc new-project redis-cluster

2. Import the template from source

        # oc create -f https://raw.githubusercontent.com/redhat-cop/containers-quickstarts/redis-cluster/master/kube/redis-cluster-ephimeral.yaml

3. Create the new application from the imported template

        # oc new-app redis-cluster-ephemeral

      --> Deploying template "openshift/redis-cluster-ephemeral" to project redis-cluster

          redis-cluster-ephemeral
          ---------
          Redis 3 Cluster Node Ephemeral

          Redis 3 Cluster Node Ephemeral

      --> Creating resources

          serviceaccount "redis" created
          imagestream "redis-cluster-node" created
          service "redis-cluster-service" created
          service "redis-cluster-node01" created
          service "redis-cluster-node02" created
          service "redis-cluster-node03" created
          buildconfig "redis-cluster" created
          deploymentconfig "redis-cluster-node01" created
          deploymentconfig "redis-cluster-node02" created
          deploymentconfig "redis-cluster-node03" created

      --> Success


4. Add the redis service account to anyuid Security Context Constraint so redis user could start processes inside de image

        # oc adm policy add-scc-to-user anyuid system:serviceaccount:redis-cluster:redis

#### Following these instructions a 3 Redis Cluster Node will automatically be created, properly shard Nodes so data is automatically sharded across multiple Redis nodes. In order to operate the Cluster (Adding Nodes, Removing Nodes, Resharding the Cluster) follow the [Offical Documentation](https://redis.io/topics/cluster-tutorial)
