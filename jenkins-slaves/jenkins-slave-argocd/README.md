# Jenkins ArgoCD Slave

This slave extends the base jenkins slave image and adds the argocd binary. We can use this slave image in a Jenkins pipeline to perform gitops actions and scaffold argocd projects.

## Build in OpenShift
```bash
oc process -f ../../.openshift/templates/jenkins-slave-generic-template.yml \
    -p NAME=jenkins-slave-argocd \
    -p SOURCE_CONTEXT_DIR=jenkins-slaves/jenkins-slave-argocd \
    -p DOCKERFILE_PATH=Dockerfile \
    | oc create -n openshift -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-slave-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-slave-generic-template.yml`.
