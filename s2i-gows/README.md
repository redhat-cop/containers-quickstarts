# S2I Image for GoWS - A Tiny Web Server

[GoWS](https://github.com/redhat-cop/gows) is a golang based static content web server.

## Quickstart

```
oc new-app https://github.com/redhat-cop/containers-quickstarts.git --context-dir=s2i-gows/test-site --name=gows-test --docker-image=redhat-cop/s2i-gows
```
