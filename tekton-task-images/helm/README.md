# helm image

[helm](https://helm.sh/) is the K8s equivalent of yum or apt which allows us to describe the application structure through helm-charts and managing it with its commands. You can use `helm` image to run helm cli commands inside your Tekton pipelines.

```
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: helm-linting
spec:
  description: 'Run linting for helm chart'
  params:
    - description: The git revision of the feature branch
      name: git-revision
      type: string
    - description: The name of the repo URL that relates to the push event.
      name: git-repository-url
      type: string
  resources:
    inputs:
      - name: source
        type: git
  steps:
    - image: 'quay.io/redhat-cop/helm:3.3.3'
      name: helm-linting
      script: |
        helm lint chart 
```