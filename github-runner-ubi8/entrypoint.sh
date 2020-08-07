#!/bin/sh

export NAME="${RUNNER_NAME:-$(hostname)}"

registration_url="https://${GITHUB_ENDPOINT}/${GITHUB_OWNER}"
if [ -z "${GITHUB_REPOSITORY}" ]; then
    token_url="https://api.${GITHUB_ENDPOINT}/orgs/${GITHUB_OWNER}/actions/runners/registration-token"
else
    token_url="https://api.${GITHUB_ENDPOINT}/repos/${GITHUB_OWNER}/${GITHUB_REPOSITORY}/actions/runners/registration-token"
    registration_url="${registration_url}/${GITHUB_REPOSITORY}"
fi

payload=$(curl -sX POST -H "Authorization: token ${GITHUB_PAT}" ${token_url})
export RUNNER_TOKEN=$(echo $payload | jq .token --raw-output)

echo "Starting GitHub Runner '${NAME}'"

./config.sh \
    --name ${NAME} \
    --token ${RUNNER_TOKEN} \
    --url ${registration_url} \
    --work ${RUNNER_WORKDIR} \
    --labels ${RUNNER_LABELS} \
    --unattended \
    --replace

remove() {
    ./config.sh remove --unattended --token "${RUNNER_TOKEN}"
}

trap 'remove; exit 130' INT
trap 'remove; exit 143' TERM

./run.sh "$*" &

wait $!
