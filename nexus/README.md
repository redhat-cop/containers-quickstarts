# Container Quickstart for Sonatype Nexus which integrates the OpenShift/Kubernetes Config Plugin

## Testing
1. Install Ansible on your local machine
1. Log on to the OpenShift cluster with the CLI
1. Clone this repository and open a terminal in the root of the project
1. Change directory to `./nexus/test`
1. Install the OpenShift Applier role(s)
   1. `ansible-galaxy install -r requirements.yml -p ./roles`
1. Run the applier playbook
   1. `ansible-playbook -i inventory test.yml`
1. Wait for the Nexus application to become available
1. Open the Nexus page and attempt to log on as `admin` with password `thisismytestpassword`
   1. If this works, the container is correct.


## What is needed to make Nexus with the OpenShift/Kubernetes plugin work

* A pull secret for accessing `registry.connect.redhat.com` as explained [HERE](https://access.redhat.com/containers/?tab=images&get-method=registry-tokens#/registry.connect.redhat.com/sonatype/nexus-repository-manager)
* A persistent volume used for storing the Nexus repository data
* A service account named `nexus`
  * This service account must be linked using `imagePullSecrets` to the `nexus` secret
    ```
    kind: ServiceAccount
    apiVersion: v1
    metadata:
      name: nexus
    imagePullSecrets:
      - name: nexus
    ```
* A secret named `nexus` containing a `password` field which is used for the default admin password
* A service named `nexus` which exposes port 9000 of the Nexus pod
* A route named `nexus` which exposes the `nexus` service
* [OPTIONAL] Any number of `configmap` objects containing definitions for `blobstores` and `repositories` as described [HERE](https://github.com/sonatype-nexus-community/nexus-kubernetes-openshift/tree/master/src/test/resources/exampleConfigMaps)
