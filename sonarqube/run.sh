#!/bin/bash

set -x
set -e

## If the mounted data volume is empty, populate it from the default data
cp -a /opt/sonarqube/data-init/* /opt/sonarqube/data/

## Link the plugins directory from the mounted volume
rm -rf /opt/sonarqube/extensions/plugins
ln -s /opt/sonarqube/data/plugins /opt/sonarqube/extensions/plugins

mkdir -p /opt/sonarqube/data/plugins
for I in $(ls /opt/sonarqube/extensions-init/plugins/*.jar);
do
  TARGET_PATH=$(echo ${I} | sed 's@extensions-init/plugins@data/plugins@g')
  if ! [[ -e ${TARGET_PATH} ]]; then
    cp ${I} ${TARGET_PATH}
  fi
done

if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

java -jar lib/sonar-application-$SONAR_VERSION.jar \
    -Dsonar.web.javaAdditionalOpts="-Djava.security.egd=file:/dev/./urandom ${SONARQUBE_WEB_JVM_OPTS}" \
    "$@"