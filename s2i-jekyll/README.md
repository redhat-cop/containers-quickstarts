# S2I Image for Building Jekyll Sites

This image builds sites using [Jekyll](https://jekyllrb.com/).

## Quickstart

To get started, we first need to build the image.

```
oc new-build https://github.com/redhat-cop/containers-quickstarts --strategy=docker --context-dir=s2i-jekyll --name='jekyll-builder'
```

Now we can use the image to build an app. Here, we will use the source code for the [Red Hat COP Containers & OpenShift Playbooks](http://playbooks-rhtconsulting.rhcloud.com/) site
```
oc new-app https://github.com/redhat-cop/openshift-playbooks --image-stream=jekyll-builder
```

Finally, we can expose the service that was just created.
```
oc expose service openshift-playbooks
```

Now we can `oc get routes` to get the hostname of the route that was just created, or click the link in the OpenShift Web Console, and test our newly published jekyll site.

>**_NOTE_**: This image is not intended to be used to serve the content provided by jekyll. It can do so, but is meant for testing purposes only. For hosting the html site produced by this image, consider using the [s2i-httpd image](/s2i-httpd/), or for someting even more light weight, check out our [Go Web Server](https://github.com/redhat-cop/gows).
