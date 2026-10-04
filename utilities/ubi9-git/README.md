# ubi9-git

A utility image with Git on UBI 9 minimal. The process runs as UID 1001.

## Purpose

Useful where Git is needed without a full operating system image:

* local development
* CI jobs that do not require a specialized runner image, such as GitLab CI

## Security

* Base image is `ubi9/ubi-minimal`, pinned by digest.
* Only the `git` package is installed, with weak dependencies disabled and the package cache removed.
* `USER 1001`. `/home/git` is group-owned by `0` and group-writable so OpenShift can run the container with an arbitrary UID in the root group.
* `HOME` and `TMPDIR` point at that directory so a read-only root filesystem can still run Git when `/home/git` is writable.
* This image does not set `safe.directory=*`. Set `safe.directory` to the specific workspace if Git reports dubious ownership.

Run it with a locked-down runtime when the cluster policy allows it:

```sh
podman run --rm \
  --user 1001 \
  --cap-drop=ALL \
  --security-opt=no-new-privileges \
  --read-only \
  --tmpfs /home/git:rw,nosuid,nodev \
  ubi9-git git --version
```

## Supply chain

The publish workflow builds `linux/amd64` and `linux/arm64`, writes an SPDX SBOM for each architecture, and signs the image with keyless Cosign. The workflow run checks that the signature and the SBOM attestation verify before it finishes.

It runs when the Dockerfile or `version.json` changes, when someone starts it manually, and every day at 01:20 UTC. The daily run rebuilds Git from the current UBI repositories. Renovate opens a pull request when Red Hat publishes a new UBI 9 minimal digest. Merging that pull request publishes again.

Verify a published image:

```sh
cosign verify \
  --certificate-identity "https://github.com/redhat-cop/containers-quickstarts/.github/workflows/ubi9-git-publish.yaml@refs/heads/main" \
  --certificate-oidc-issuer "https://token.actions.githubusercontent.com" \
  ghcr.io/redhat-cop/containers-quickstarts/ubi9-git@<digest>

cosign verify-attestation \
  --type spdxjson \
  --certificate-identity "https://github.com/redhat-cop/containers-quickstarts/.github/workflows/ubi9-git-publish.yaml@refs/heads/main" \
  --certificate-oidc-issuer "https://token.actions.githubusercontent.com" \
  ghcr.io/redhat-cop/containers-quickstarts/ubi9-git@<digest>
```

## Published

[https://quay.io/repository/redhat-cop/ubi9-git](https://quay.io/repository/redhat-cop/ubi9-git) via [GitHub Workflows](../../.github/workflows/ubi9-git-publish.yaml). Pull-request builds upload the SBOMs as workflow artifacts.
