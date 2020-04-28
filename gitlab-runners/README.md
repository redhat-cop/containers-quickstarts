# Gitlab Runners by Red Hat's Community of Practice

## What's here?

This directory contains Gitlab Runner images that can be easily consumed.

## Quay published Gitlab Runner images

Some of the images kept here are also [published to Quay](https://quay.io/organization/redhat-cop) through the use of [Github Workflows](/.github/workflows).

You can test out the workflows and publish the image to your own image registry by forking this repository. You'll also need to enable GH workflows under your fork's settings.
Lastly you'll need to create the following secrets in your forked repo to push to an image registry of your choice.

| Secret              | Description                               |
|---------------------| ------------------------------------------|
| REGISTRY_URI        | The URI for the registry (quay.io)        |
| REGISTRY_REPOSITORY | The registry repository name (redhat-cop) |
| REGISTRY_USERNAME   | The registry repository username          |
| REGISTRY_PASSWORD   | The registry repository password          |
