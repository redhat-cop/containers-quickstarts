# Testing this Repository

Containers-quickstarts is outfitted with a set of automated tests. This document deals with writing and running tests for your contributions.

## Tesing Architecture

We use Travis-CI to test this repo. You can start to examine how we set up and invoke tests by examining the [.travis.yml](.travis.yml) file.

We have split the architect of the tests up into 4 phases:

1. Environment setup and prereqs
2. Launching an openshift test cluster, using `oc cluster up`
3. Running [openshift-applier](https://github.com/redhat-cop/openshift-applier) to deploy a set of builds
4. Checking `.status.phase` in each build to validate all builds end with in a `Completed` state.

The 3 phases of testing are captured in a [script](_test/setup.sh) that is executed by travis, but can also be run locally in order to validate your changes before committing code.

## Writing Tests

Adding a new test to our CI is as simple as adding one or more `BuildConfig`s to the [global Applier inventory](.applier). Currently we deploy all assets into a single namespace to make all builds "discoverable" by our test scripts.

Every build that gets created will then be executed, and the test script will wait until all builds complete, and ensure that none of them fail.

## Running the tests locally.

For convenience, a script is provided that allows users to run tests locally. The script usage is as follows:

```
./_test/setup.sh <applier|test> [project name] [repo slug] [branch name]
```

For example, to test against master:

```
oc login ... && \
  ./_test/setup.sh applier && \
  ./_test/setup.sh test
```

To test against an alternate fork/branch:

```
oc login ... && \
  ./_test/setup.sh applier etsauer-feature123 etsauer/containers-quickstarts feature123 && \
  ./_test/setup.sh test etsauer-feature123 etsauer/containers-quickstarts feature123
```

Or, to test against the branch you are currently working on:

```
oc login ... && \
  FORK=$(git remote get-url origin | sed -e 's/^.*:\(.*\)\/.*.git$/\1/')
  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  ./_test/setup.sh applier ${FORK}-${BRANCH} ${FORK}/containers-quickstarts ${BRANCH} && \
  ./_test/setup.sh test ${FORK}-${BRANCH} ${FORK}/containers-quickstarts ${BRANCH}
```
