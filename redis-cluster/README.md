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

5. Check if the Cluster Nodes have been correctly joined.

        # oc get pods
        NAME                           READY     STATUS      RESTARTS   AGE
        redis-cluster-2-build          0/1       Completed   0          11m
        redis-cluster-node01-1-hm47o   1/1       Running     0          3m
        redis-cluster-node02-1-9jv0p   1/1       Running     0          3m
        redis-cluster-node03-1-9n2ce   1/1       Running     0          3m

        # oc rsh redis-cluster-node01-1-hm47o
        
        sh-4.2$ redis-cli cluster nodes
        671c165f57303c7fa667069b193b15af3f9978dc 10.1.5.24:6379 myself,master - 0 0 1 connected 0-5460
        89a2ee2010592767ad0e987b08431ed3898bae30 10.1.0.64:6379 master - 0 1486037307245 2 connected 5461-10922
        e5da819ddc98897d72a42f784d2f7100648b48ff 10.1.1.40:6379 master - 0 1486037307758 3 connected 10923-16383


#### Following these instructions a 3 Redis Cluster Node will automatically be created, properly shard Nodes so data is automatically sharded across multiple Redis nodes. In order to operate the Cluster (Adding Nodes, Removing Nodes, Resharding the Cluster) follow the [Offical Documentation](https://redis.io/topics/cluster-tutorial)
