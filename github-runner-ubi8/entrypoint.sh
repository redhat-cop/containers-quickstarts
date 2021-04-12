#!/bin/sh

set -e

if [ -z "${RUNNER_TOKEN}" ] && [ -z "${GITHUB_PAT}" ]; then
    echo "RUNNER_TOKEN or GITHUB_PAT variable must be defined!"
    exit 255
fi

export NAME="${RUNNER_NAME:-$(hostname)}"

GITHUB_ENDPOINT="${GITHUB_ENDPOINT:-github.com}"
GITHUB_OWNER="${GITHUB_OWNER:-default}"
GITHUB_REPOSITORY="${GITHUB_REPOSITORY}"
RUNNER_WORKDIR="${RUNNER_WORKDIR:-_work}"
RUNNER_LABELS="${RUNNER_LABELS:-self-hosted,Linux,X64}"

REGISTRATION_URL="https://${GITHUB_ENDPOINT}/${GITHUB_OWNER}"
if [ -z "${GITHUB_REPOSITORY}" ]; then
    TOKEN_URL="https://api.${GITHUB_ENDPOINT}/orgs/${GITHUB_OWNER}/actions/runners/registration-token"
else
    TOKEN_URL="https://api.${GITHUB_ENDPOINT}/repos/${GITHUB_OWNER}/${GITHUB_REPOSITORY}/actions/runners/registration-token"
    REGISTRATION_URL="${REGISTRATION_URL}/${GITHUB_REPOSITORY}"
fi

if [ ! -z "${GITHUB_PAT}" ]; then
    payload=$(curl -sX POST -H "Authorization: token ${GITHUB_PAT}" ${TOKEN_URL})
    export RUNNER_TOKEN=$(echo $payload | jq .token --raw-output)
fi

echo "Starting GitHub Runner '${NAME}'"

./config.sh --name "${NAME}" --work "${RUNNER_WORKDIR}" --labels "${RUNNER_LABELS}" --unattended --replace --url "${REGISTRATION_URL}" --token "${RUNNER_TOKEN}"

unregister() {

    echo "Stopping GitHub runner.."

    if [ -z "${SKIP_UNREGISTER}" ]; then

        echo "Unregistering GitHub runner.."

        if [ ! -z "${GITHUB_PAT}" ]; then
            REMOVE_TOKEN_URL="${TOKEN_URL}/remove-token"
            payload=$(curl -sX POST -H "Authorization: token ${GITHUB_PAT}" "$REMOVE_TOKEN_URL")

            export RUNNER_TOKEN=${RUNNER_TOKEN:-$(echo "$payload" | jq .token --raw-output)}
        fi

        ./config.sh remove --unattended --token "${RUNNER_TOKEN}"
    fi
    
}

trap unregister EXIT HUP INT QUIT PIPE TERM

./run.sh "$*" &

wait $!
