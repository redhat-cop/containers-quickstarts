#!/bin/bash

echo "## === HOW THIS STACK HAS BEEN STARTED ==="

echo "## The following commands have been executed in order to run Pinpoint APM stack"
echo ""
echo "/pinpoint/quickstart/bin/start-hbase.sh"
echo "/pinpoint/quickstart/bin/init-hbase.sh"
echo "/pinpoint/quickstart/bin/start-collector.sh &> /pinpoint/logs/collector.out &"
echo "/pinpoint/quickstart/bin/start-web.sh &> /pinpoint/logs/webui.out &"
echo ""
echo "## TEST application is not started by default. You can start it running the following command:"
echo ""
echo "/pinpoint/quickstart/bin/start-testapp.sh &> /pinpoint/logs/testapp.out &"
echo ""

echo "## === EACH COMPONENT'S LOG FILE ==="
echo ""
echo "HBASE -------->  /pinpoint/logs/hbase.out"
echo "Collector ---->  /pinpoint/logs/collector.out"
echo "Web UI ------->  /pinpoint/logs/webui.out"
echo "Test App ----->  /pinpoint/logs/testapp.out"
