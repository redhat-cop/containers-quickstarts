#!/bin/bash

NODE1_IP=$(/usr/bin/getent hosts redis-cluster-node01 | awk {' print $1 '})
NODE2_IP=$(/usr/bin/getent hosts redis-cluster-node02 | awk {' print $1 '})
NODE3_IP=$(/usr/bin/getent hosts redis-cluster-node03 | awk {' print $1 '})
NODE1=$NODE1_IP":6379"
NODE2=$NODE2_IP":6379"
NODE3=$NODE3_IP":6379"

sleep 10

/usr/local/bin/redis-trib.rb create $NODE1 $NODE2 $NODE3

exit 0
