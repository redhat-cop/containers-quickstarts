# conftest image

[conftest](https://github.com/open-policy-agent/conftest) is a utility to help you write tests against structured configuration data. You can use `conftest` image to run your [OPA](https://www.openpolicyagent.org/docs/latest/) policies for Kubernetes configuration inside your Tekton pipelines.


```
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: k8s-bestpractices
spec:
  description: 'Check if manifests comply with k8s best practices'
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
    - image: 'quay.io/redhat-cop/conftest:0.22.0'
      name: k8s-check
      workingDir: /workspace/source/rego-policies
      script: |
        conftest test deployment.yaml --output tap 
```

_Conftest isn't specific to Kubernetes. You can also test any configuration files in a variety of different formats._

Update [VERSION](VERSION) file in order to change `conftest` version installed inside container.