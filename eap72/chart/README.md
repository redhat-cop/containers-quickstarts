# EAP 7.2 Helm Chart
A Helm chart for building and deploying an EAP application to OpenShift, inspired by the [OpenShift EAP templates](https://github.com/jboss-openshift/application-templates/tree/master/eap).

## Installation
Users must provide a "sourceUri" value, which should point to a git repository containing a Java application. This location will be used as the source location for the s2i build. Run the installation with the following command.
```bash
helm install my-eap-application . --set sourceUri=repository-uri
```

## Rolling out the Application
Users must first start a new build by running  the following command.
```bash
oc start-build $RELEASE_NAME
```

The appliction will be automatically rolled out when the build finishes.

## Enabling TLS
TLS can be enabled with the "tls.enabled" value. Communication within the cluster will be encrypted when this value is set to "true". Traffic from outside of the cluster is encrypted regardless of this value's setting.

Users must provide a secret containing a JGroups keystore and a secret containing an keystore for client traffic. 

Create a JGroups traffic secret by following the example below:
```bash
keytool -genseckey -keyalg AES -alias jgroups -keystore jgroups.jceks -validity 360 -keysize 256 -deststoretype jceks
oc create secret generic jgroups-keystore --from-file=jgroups.jceks=jgroups.jceks
```

Create a secret for HTTPS encryption by following the example below:
```bash
keytool -genkey -keyalg RSA -alias https -keystore keystore.jks -validity 360 -keysize 2048
oc create secret generic https-keystore --from-file=keystore.jks=keystore.jks
```

These instructions will also be displayed upon installing the chart with the "tls.enabled" value set to "true".

## Values
The below table describes the values supported for this Helm chart. When relevant, these values are given the same name as the DeploymentConfig environment variables that they configure. See the [values.yaml](./values.yaml) file for more information on this chart's values.

| Value | Definition | Default |
| ----- | ---------- | ------- |
| `sourceUri` | URI to a git repository containing a java application | `nil`, REQUIRED |
| `sourceRef` | Branch to reference from the git repository | `master` |
| `sourceContextDir` | Directory containing a java application | `.` |
| `imageTag` | Tag to give the built image, and tag of the image to deploy | `latest` |
| `createRoute` | Determines if a route should be created to expose the application from outside the cluster | `true` |
| `routeHostname` | Hostname of the OpenShift Route | `""` |
| `updateStrategy` | DeploymentConfig update strategy (Available options: Rolling, Recreate) | `Rolling` |
| `resources.requests.memory` | Application memory request | `512Mi` |
| `resources.requests.cpu` | Application cpu request | `100m` |
| `resources.limits.memory` | Application memory limit | `1Gi` |
| `resources.limits.cpu` | Application cpu limit | `300m` |
| `replicas` | Number of pods to deploy | `1` |
| `jgroupsClusterPassword` | Password for cluster authentication. Required for EAP nodes to join a cluster | `testpass` |
| `tls.enabled` | Determines if JGroups and client communication should be encrypted. Requires the creation of two OpenShift secrets containing keystores | `false` |
| `tls.jgroupsEncryptSecret` | Name of the secret containing jgroups keystore. Required if `tls.enabled` is true | `jgroups-keystore` |
| `tls.jgroupsEncryptKeystore` | Name of the JGroups keystore file. Required if `tls.enabled` is true | `jgroups.jceks` |
| `tls.jgroupsEncryptName` | Name of the JGroups keystore. Required if `tls.enabled` is true | `jgroups` |
| `tls.jgroupsEncryptPassword` | Password to the JGroups keystore. Required if `tls.enabled` is true | `changeit` |
| `tls.httpsSecret` | Name of the secret containing https keystore. Required if `tls.enabled` is true | `https-keystore` |
| `tls.httpsKeystore` | Name of the https keystore file. Required if `tls.enabled` is true | `keystore.jks` |
| `tls.httpsName` | Name of the https keystore. Required if `tls.enabled` is true | `https` |
| `tls.httpsPassword` | Password to the https keystore. Required if `tls.enabled` is true | `changeit` |
