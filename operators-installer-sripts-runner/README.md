# operators-installer-sripts-runner

A utility image that can be used with the [containers-installer helm chart](https://github.com/redhat-cop/helm-charts/tree/main/charts/operators-installer)

```yaml
```

## Purpose

Use with the [containers-installer helm chart](https://github.com/redhat-cop/helm-charts/tree/main/charts/operators-installer) to save time by not having to install python packages at runetime everytime an approver or validator job runs.

sample-vales.yaml
```yaml
installPlanApproverAndVerifyJobsImage: https://quay.io/repository/redhat-cop/operators-installer-sripts-runner
installRequiredPythonLibraries: false

...
```

## Published

[https://quay.io/repository/redhat-cop/operators-installer-sripts-runner](https://quay.io/repository/redhat-cop/operators-installer-sripts-runner) via [GitHub Workflows](../../.github/workflows/operators-installer-sripts-runner-publish.yaml).
