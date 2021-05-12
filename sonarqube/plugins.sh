#!/usr/bin/env bash

set -e
# set -x  ## Uncomment for debugging

printf 'Downloading plugin details\n'

## Extract sonarqube version
export SQ_VERSION=$(ls /opt/sonarqube/lib/sonar-application* | awk -F"-" '{print $3}' | sed 's@\.jar$@@g')
echo "SONARQUBE_VERSION: ${SQ_VERSION}"


curl -L -sS -o /tmp/pluginList.txt https://update.sonarsource.org/update-center.properties
printf "Downloading additional plugins\n"
for PLUGIN in "$@"
do
  printf '\tExtracting plugin download location - %s\n' ${PLUGIN}
  MATCH_STRING=$(cat /tmp/pluginList.txt | grep requiredSonarVersions | grep -E "[,=]${SQ_VERSION}(,|$)" | sed 's@\.requiredSonarVersions.*@@g' | sort -V | grep "^${PLUGIN}\." | tail -n 1 | sed 's@$@.downloadUrl@g')

  if ! [[ -z "${MATCH_STRING}" ]]; then
    DOWNLOAD_URL=$(cat /tmp/pluginList.txt | grep ${MATCH_STRING} | awk -F"=" '{print $2}' | sed 's@\\:@:@g')
    PLUGIN_FILE=$(echo ${DOWNLOAD_URL} | sed 's@.*/\(.*\)$@\1@g')
    BASENAME=$(echo ${PLUGIN_FILE} | sed 's/-[0-9].*//')

    ## Check to see if plugin exists, attempt to download the plugin if it does exist.
    if ! [[ -z "${DOWNLOAD_URL}" ]]; then
      RC=$(curl -L -sS -w %{http_code} -o /opt/sonarqube/extensions-init/plugins/${PLUGIN_FILE} ${DOWNLOAD_URL})
      if [[ "${RC}" == "200" ]]; then
        printf "\t\t%-35s%10s\n" "${PLUGIN_FILE}" "DONE"
        for f in /opt/sonarqube/extensions-init/plugins/${BASENAME}*.jar; do
          if [[ "${f}" != "/opt/sonarqube/extensions-init/plugins/${PLUGIN_FILE}" ]]; then
            rm -vf $f
          fi
        done
      else
        printf "\t\t%-35s%10s\n" "${PLUGIN_FILE}" "FAILED"
      fi
    else
      ## Plugin was not found in the plugin inventory
      printf "\t\t%-15s%10s\n" "${PLUGIN}" "NOT FOUND"
    fi
  else
    printf "\t\t%-15s%10s\n" $PLUGIN "NOT FOUND"
  fi
done

rm -f /tmp/pluginList.txt
