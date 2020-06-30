# Jenkins ArgoCD Agent

This agent extends the base jenkins agent image and adds the argocd binary. We can use this agent image in a Jenkins pipeline to perform gitops actions and scaffold argocd projects.

Agent also includes `yq` for [yaml manipulation](https://github.com/mikefarah/yq). Ex use
```bash
cat << EOF | yq w - 'my_app.version' newest
---
my_app:
  version: latest
EOF
```

## Build in OpenShift
```bash
oc process -f ../../.openshift/templates/jenkins-agent-generic-template.yml \
    -p NAME=jenkins-agent-argocd \
    -p SOURCE_CONTEXT_DIR=jenkins-agents/jenkins-agent-argocd \
    -p DOCKERFILE_PATH=Dockerfile \
    | oc create -n openshift -f -
```
For all params see the list in the `../../.openshift/templates/jenkins-agent-generic-template.yml` or run `oc process --parameters -f ../../.openshift/templates/jenkins-agent-generic-template.yml`.
