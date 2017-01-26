#!/bin/bash

# For using as entrypoint command once Hbase is initialized - This is done during the Docker build process.

/pinpoint/quickstart/bin/start-hbase.sh &> /pinpoint/logs/hbase.out
/pinpoint/quickstart/bin/start-collector.sh &> /pinpoint/logs/collector.out &

# Prevent Web UI process to start before Collector is ready or container will exit

COUNTER=0
while [ $COUNTER -lt 100 ]; do
  collector=$(netstat -na | grep 28082 | wc -l)
	if [ $collector -gt 0 ];then
		COUNTER=100
	fi
  let COUNTER=COUNTER+1
	sleep 1
done

/pinpoint/quickstart/bin/start-web.sh &> /pinpoint/logs/webui.out

# Comment out the following line if you want Test App to automatically be started

#/pinpoint/quickstart/bin/start-testapp.sh &> /pinpoint/logs/testapp.out &
