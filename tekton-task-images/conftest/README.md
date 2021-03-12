# conftest image

[conftest](https://github.com/open-policy-agent/conftest) is a utility to help you write tests against structured configuration data. You can use `conftest` image to run your [OPA](https://www.openpolicyagent.org/docs/latest/) policies for Kubernetes configuration inside your Tekton pipelines.

_Conftest isn't specific to Kubernetes. You can also test any configuration files in a variety of different formats._

Update [VERSION](VERSION) file in order to change `conftest` version installed inside container.