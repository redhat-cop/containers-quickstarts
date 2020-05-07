# ubi7-gitlab-runner

GitLab Runner based on ubi7 that does not require privilaged SSC (does not run as root) to run.

## Purpose

To be regestered as a [GitLab Runner](https://docs.gitlab.com/runner/) for a GitLab server.

## Use

### OpenShift with Helm Chart

1. Setup

Follow [GitLab Runner Helm Chart](https://docs.gitlab.com/runner/install/kubernetes.html) until [Installing GitLab Runner using the Helm Chart](https://docs.gitlab.com/runner/install/kubernetes.html#installing-gitlab-runner-using-the-helm-chart)

2. Update values.yaml to specify image

Add the following to the op of your values.yaml

```
## GitLab Runner Image
##
## By default it's using gitlab/gitlab-runner:alpine-v{VERSION}
## where {VERSION} is taken from Chart.yaml from appVersion field
##
## ref: https://hub.docker.com/r/gitlab/gitlab-runner/tags/
##
image: quay.io/redhat-cop/ubi7-gitlab-runner:latest
```

> NOTE: swap out the image value if built locally

3. Deploy the GitLab Runner

```bash
GITLAB_RUNNER_PROJECT_NAME=gitlab-runners-kmo-cer

oc new-project ${GITLAB_RUNNER_PROJECT_NAME}
oc project ${GITLAB_RUNNER_PROJECT_NAME}
oc create serviceaccount gitlab-runner
oc policy add-role-to-user edit system:serviceaccount:${GITLAB_RUNNER_PROJECT_NAME}:gitlab-runner
helm install --namespace ${GITLAB_RUNNER_PROJECT_NAME} gitlab-runner -f helm-kmo-cer-values.yml gitlab/gitlab-runner
oc patch deployment/gitlab-runner-gitlab-runner --type json --patch '[{ "op": "remove", "path": "/spec/template/spec/securityContext" }]'
```

## Tested With
* OpenShift Container Platform 3.11
* OpenShift Container Platform 4.2

## Published

[https://quay.io/repository/redhat-cop/ubi7-gitlab-runner](https://quay.io/repository/redhat-cop/ubi7-gitlab-runner) via [GitHub Workflows](.github/workflows/ubi7-gitlab-runner-publish.yaml).
