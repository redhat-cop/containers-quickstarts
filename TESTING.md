# Testing this Repository

Containers-quickstarts is outfitted with a set of automated tests. This document deals with writing and running tests for your contributions.

## Tesing Architecture

We use Travis-CI to test this repo. You can start to examine how we set up and invoke tests by examining the [.travis.yml](/.travis.yml) file.

We have split the architect of the tests up into 4 phases:

1. Environment setup and prereqs
2. Launching an openshift test cluster, using `oc cluster up`
3. Running [openshift-applier](https://github.com/redhat-cop/openshift-applier) to deploy a set of builds
4. Checking `.status.phase` in each build to validate all builds end with in a `Completed` state.

The 3 phases of testing are captured in a [script](/_test/setup.sh) that is executed by travis, but can also be run locally in order to validate your changes before committing code.

## Writing Tests

Adding a new test to our CI is as simple as adding one or more `BuildConfig`s to the [global Applier inventory](/.applier). Currently we deploy all assets into a single namespace to make all builds "discoverable" by our test scripts.

Every build that gets created will then be executed, and the test script will wait until all builds complete, and ensure that none of them fail.

## Running the tests locally.

There are a number of ways to run the tests, but the easiest is to run all phases against a local cluster with `oc cluster up`:

```
oc cluster up --base-dir=$HOME/ocp && \
  ./_test/setup.sh applier && \
  ./_test/setup.sh test
```
