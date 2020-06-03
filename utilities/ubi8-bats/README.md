# ubi8-bats

A utility image for the UBI8 image + Bats. 

Contains the primary used bats for running test scenarios

It's base is from https://github.com/bats-core/bats-core but now ubi based.

The image also includes the following applications:
 * Helm
 * jq
 * OpenShift client
 * yq

## Purpose

Useful for environments where these libraries/tools are needed such as:
* local development
* CI tools that do not require specific CI tooling configuraiton, such as GitLab Jobs.

## Limitations

The image does not support running parallel tests using the `-j, --jobs` option.

## Published

[https://quay.io/repository/redhat-cop/ubi8-bats](https://quay.io/repository/redhat-cop/ubi8-bats) via [GitHub Workflows](../../.github/workflows/ubi8-bats-publish.yaml).
