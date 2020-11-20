#!/bin/bash
container="android-docker-agent"
image="jenkins-android-docker-agent"
jenkinsDiscovery="jenkins.example.com:50000"
jenkinsUrl="http://jenkins-ui.example.com"
secretToken="longsecretalphanumericaltokenfromjenkins"

docker build --no-cache -t $image https://raw.githubusercontent.com/AckeeDevOps/jenkins-android-docker-slave/master/Dockerfile
docker stop $container
docker rm $container
docker -- run --restart=always -d \
  --name $container \
  -v /var/run/docker.sock:/var/run/docker.sock \
  $image \
  -headless -tunnel $jenkinsDiscovery -url $jenkinsUrl $secretToken $container
