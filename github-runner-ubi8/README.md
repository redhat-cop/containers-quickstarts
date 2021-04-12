# github-runner-ubi8

Self hosted [GitHub Actions](https://docs.github.com/en/actions) runner based on UBI (Universal Base Image) 8.

## Overview

By default, GitHub Actions makes use of [runners](https://docs.github.com/en/actions/getting-started-with-github-actions/core-concepts-for-github-actions#runner) to execute jobs. Runners can either by managed by the GitHub hosting service of self hosted. The contents of this repository contains a [Self Hosted GitHub Actions Runner](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners) packaged as a container instance.

Self hosted runners can be scoped at a repository or account/organization level and is configured automatically based on the set of values provided to the container.

## Prerequisites

The following prerequisites must be met prior to using the content contained within this repository

1. Personal Account Token - A GitHub [Personal Account Token (PAT)](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) must be available for the runner to connect to GitHub. A runner token will be retrieved as the runner is started
2. GitHub Runner Token - Token retrieved either from a GitHub [Personal Account Token (PAT)](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) or a [GitHub App](https://docs.github.com/en/developers/apps/creating-a-github-app).

## Building and Deploying on OpenShift

OpenShift can be used to build and deploy the self hosted runner. A set of [OpenShift templates](.openshift/templates/github-runner.yaml) are available to streamline the generation of the necessary resources.

The following templates are available:

* [github-runner-ubi8-build.yaml](.openshift/templates/github-runner-ubi8-build.yaml) - Builds the GitHub Runner image
* [github-runner-ubi8-deployment.yaml](.openshift/templates/github-runner-ubi8-build.yaml) - Deploys the GitHub Runner image

### Instantiating the Templates

The provided templates which builds and deploys the self hosted running contains a number of parameters to fine tune the necessary configuration for operational use. While the majority of these parameters can be left at their default values, the following variables will most likely need to be defined:

#### github-runner-ubi8-deployment

| Name | Description | Required |
| ----- | -----------| -------- |
| `GITHUB_RUNNER_AUTH_TYPE` | Authentication method (Either `GITHUB_PAT` or `RUNNER_TOKEN`) | Yes |
| `GITHUB_RUNNER_AUTH_VALUE` | Authentication credential | Yes |
| `GITHUB_OWNER` | GitHub account or organization | Yes |
| `GITHUB_REPOSITORY` | GitHub repository | No |
| `RUNNER_LABELS` | Comma separated labels to apply to the runner | No |


#### Using the CLI

First, create a new project

```
$ oc new-project github-runner-ubi8
```

Change into the runner directory:

```
$ cd github-runner-ubi8
```

Execute the following command to instantiate the templates using the OpenShift CLI:

Instantiate the build template:

```
$ oc process -f .openshift/templates/github-runner-ubi8-build.yaml -p | oc apply -f-
```

Instantiate the deployment template:

```
$ oc process -f .openshift/templates/github-runner-ubi8-deployment.yaml -p GITHUB_OWNER=<github_owner> -p GITHUB_REPOSITORY=<github_repository> -p GITHUB_RUNNER_AUTH_TYPE=<github_runner_auth_type> -p GITHUB_RUNNER_AUTH_VALUE=<github_runner_auth_value> | oc apply -f-
```

#### Using the Web Console

Use the following steps to instantiate the templates using the OpenShift web console.

1. In your project, click `Add to Project` > `Import YAML / JSON` in the top right hand corner
2. The `Import YAML / JSON` window will appear. Copy the contents of the template and paste it into the window. Alternatively, select the `Browse` button to navigate to the file located on your machine. Once complete, click `Create`.
3. An option will appear to `Add a template`. By default, the option wil be selected to `Process this template`. Keep the defaults selected and press `Continue`.
4. First, the `github-runner-ubi8-build` template will appear. Click `Create` to instantiate the template.
5. Repeat steps 1-3 to process the `github-runner-ubi8-deployment` template. Update the desired values of your choosing and insert the required values as described previously. Click `Create` to instantiate the template.

Once both templates have been instantiated, an image build will begin and once complete, the runner will be deployed.

### Verification

Once the self hosted runner has been deployed, perform the following steps to confirm the runner is ready to take on jobs:

1. Validate container logs

Confirm the runner registration by viewing the logs from the running container

```
$ oc logs $(oc get pods -l=deploymentconfig=github-runner-ubi8 -o name --no-headers=true)
```

The following is the expected output

```
--------------------------------------------------------------------------------
|        ____ _ _   _   _       _          _        _   _                      |
|       / ___(_) |_| | | |_   _| |__      / \   ___| |_(_) ___  _ __  ___      |
|      | |  _| | __| |_| | | | | '_ \    / _ \ / __| __| |/ _ \| '_ \/ __|     |
|      | |_| | | |_|  _  | |_| | |_) |  / ___ \ (__| |_| | (_) | | | \__ \     |
|       \____|_|\__|_| |_|\__,_|_.__/  /_/   \_\___|\__|_|\___/|_| |_|___/     |
|                                                                              |
|                       Self-hosted runner registration                        |
|                                                                              |
--------------------------------------------------------------------------------

# Authentication


√ Connected to GitHub

# Runner Registration



√ Runner successfully added
√ Runner connection is good

# Runner settings


√ Settings Saved.


√ Connected to GitHub

2020-07-27 04:07:48Z: Listening for Jobs
```

2. Confirm the runner has been registered within repository

Browse to a repository that should be served by this runner. Runners are defined within the _Actions_ section of the repository settings

1. Click **Settings**
2. On the left hand navigation pane, select **Actions**. 

Locate the runner under the _Self-hosted runners_ section which contains the name of the pod. If no jobs are currently active, the runner will have a state of _Idle_ indicating that it is ready to serve the next job execution.

### Workflow Configuration

As part of the configuration of any GitHub actions workflow, the target runner instance must be specified. The `runs-on` field allows for the name of the GitHub hosted runner to be defined or a set of labels associated to a registered self hosted runner.

The follow is an example of how to define a hosted runner within a workflow:

```
...
jobs:
  build:
    runs-on: [self-hosted, linux]
    steps:
      - name: Checkout code
        uses: actions/checkout@v1
...
```

The labels associated with the self hosted runner can be specified by defining the template parameter `RUNNER_LABELS`.

To learn more about how to use a self hosted runner in a workflow, click [here](https://docs.github.com/en/actions/hosting-your-own-runners/using-self-hosted-runners-in-a-workflow). 