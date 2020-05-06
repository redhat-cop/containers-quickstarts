# ubi8-asciidoctor

A utility image for the UBI8 image + asciidoctor. 

Contains the primary used asciidoctor-pdf for generating reports.

It's base is from https://github.com/asciidoctor/docker-asciidoctor but now ubi based.

## Purpose

Useful for environments where these libraries/tools are needed such as:
* local development
* CI tools that do not require specific CI tooling configuraiton, such as GiLab Jobs.

## Published

[https://quay.io/repository/redhat-cop/ubi8-asciidoctor](https://quay.io/repository/redhat-cop/ubi8-asciidoctor) via [GitHub Workflows](.github/workflows/ubi8-asciidoctor-publish.yaml).
