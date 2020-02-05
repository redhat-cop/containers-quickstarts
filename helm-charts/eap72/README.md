# EAP 7.2 Helm Chart
A Helm chart for deploying an EAP application to OpenShift.

## Installation
Users must provide a "sourceUri" value, which should point to a git repository containing a Java application. Run the installation with the following command.
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
TLS can be enabled with the "enableTls" value. Communication within the cluster will be encrypted when this value is set to "true". Traffic from outside of the cluster is encrypted regardless of this value's setting.

Users must provide a secret containing a JGroups keystore and a secret containing an keystore for client traffic. 

Create a JGroups traffic with the following command:
```bash
keytool -genseckey -keyalg AES -alias jgroups -keystore jgroups.jceks -validity 360 -keysize 256 -deststoretype pkcs12
oc create secret generic jgroups-keystore --from-file=jgroups.jceks=jgroups.jceks
```

Create a secret for HTTPS encryption with the following commands:
```bash
keytool -genkey -keyalg RSA -alias https -keystore keystore.jks -validity 360 -keysize 2048
oc create secret generic https-keystore --from-file=keystore.jks=keystore.jks
```

## Values
The below table describes the values supported for this Helm chart. For more information, see this chart's [values.yaml](./values.yaml) file.

| Value | Definition | Default |
| ----- | ---------- | ------- |
| `sourceContextDir` | Directory containing a java application | `.` |
| `sourceUri` | URI to a git repository containing a java application | `nil`, REQUIRED |
| `sourceRef` | Branch to reference from the git repository | `master` |
| `imageTag` | Tag to give the built image, and tag of the image to deploy | `latest` |
| `enableTls` | Determines if JGroups and client communication should be encrypted. Requires the creation of two OpenShift secrets containing keystores | `false` |
| `createRoute` | Determines if a route should be created to expose the application from outside the cluster | `true` |
| `routeHostname` | Hostname of the OpenShift Route | `""` |
| `updateStrategy` | DeploymentConfig update strategy (Available options: Rolling, Recreate) | `Rolling` |
| `resources.requests.memory` | Application memory request | `512Mi` |
| `resources.requests.cpu` | Application cpu request | `100m` |
| `resources.limits.memory` | Application memory limit | `1Gi` |
| `resources.limits.cpu` | Application cpu limit | `300m` |
| `replicas` | Number of pods to deploy | `1` |
| `jgroupsClusterPassword` | Password for cluster authentication. Required for EAP nodes to join a cluster | `testpass` |
| `jgroupsEncryptPassword` | Password to the JGroups keystore. Required if `enableTls` is true | `testpass` |
| `jgroupsEncryptName` | Name of the JGroups keystore. Required if `enableTls` is true | `jgroups` |
| `jgroupsEncryptKeystore` | Name of the JGroups keystore file. Required if `enableTls` is true | `jgroups.jceks` |
| `jgroupsEncryptSecret` | Name of the secret containing jgroups keystore. Required if `enableTls` is true | `jgroups-keystore` |
| `httpsName` | Name of the https keystore. Required if `enableTls` is true | `https` |
| `httpsPassword` | Password to the https keystore. Required if `enableTls` is true | `testpass` |
| `httpsKeystore` | Name of the https keystore file. Required if `enableTls` is true | `keystore.jks` |
