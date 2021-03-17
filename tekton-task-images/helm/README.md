# helm image

[helm](https://helm.sh/) is the k8s equivalent of yum or apt which allows us to describe the application structure through helm-charts and managing it with its commands. You can use `helm` image to run helm cli commands inside your Tekton pipelines.

Update [VERSION](VERSION) file in order to change `helm cli` version installed inside container.