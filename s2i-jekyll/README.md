# S2I Image for Building Jekyll Sites

This image builds sites using [Jekyll](https://jekyllrb.com/).

## Quickstart

```
oc new-build https://github.com/etsauer/containers-quickstarts#s2i-jekyll --strategy=docker --context-dir=s2i-jekyll --name='jekyll-builder'
oc new-app https://github.com/redhat-cop/openshift-playbooks --image-stream=jekyll-builder
```
