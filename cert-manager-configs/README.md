# cert-manager-openshift-install

This helm chart is meant to provide auto-renewing Let's Encrypt on your `api` and `*.apps` endpoints on Openshift. **This requires ClusterAdmin privileges** to an OCP 4.x cluster as you will be installing CRDs and touching critical networking pieces. You will also need to be able control your DNS to create the ACME challenges if using the dns01 provider.

It is recommended that you do not enable the `cluster.apiServer` and `cluster.ingressController` resources until you have successfully installed cert-manager and configured your issuers to generate valid certs.

In Openshift 3.x these certs live in the filesystem

## Install cert-manager and CRDs

Install cert-manager following the [installation instructions for Helm v3](https://cert-manager.io/docs/installation/kubernetes/#steps):

```bash
oc new-project cert-manager

helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v0.15.0 \
  --set installCRDs=true \
  --set 'extraArgs={--dns01-recursive-nameservers=8.8.8.8:53\,1.1.1.1:53}'
```

We are using v0.15.0 due to a bug in v0.15.1 at the moment. Future releases may install cert-manager from the OperatorHub cert-manager operator.

Note the dns01-recursive-nameservers option above is required in most cases for Route53. By default, cert-manager will check dns with /etc/resolv.conf before creating a CertificateRequest, which is undesirable if your node is not pointed to public DNS nameservers.

## Install ClusterIssuer/Issuer and Certificates

Once cert-manager is up and running, use helm to install to install your issuers, create certificates, and point your APIServer and IngressController to the automatically renewable certificates:

While the cert-manager install can be done with mostly default values, these configs require custom values, including DNS secrets in [values.yaml](./values.yaml) before you can apply the configs.


```bash
helm template cert-manager-configs -f charts/cert-manager-configs/values.yaml ./charts/cert-manager-configs | oc apply -f -
```
 
## Configuration

See comments in [values.yaml](./values.yaml) for more details on configuration

| Parameter                                        | Description                                                  | Default                               |
| ------------------------------------------------ | -------------------------------------------------------------| ------------------------------------- |
| `namespace` | Project name to install cert-manager | `cert-manager` |
| `issuer.provider` | Configure an Issuer or ClusterIssuer for cert-manager | `route53` |
| `issuer.dns.enabled` | Enable DNS provider | `true` |
| `issuer.acme.emailAddress` | Email address for ACME account | `admin@example.com` |
| `issuer.acme.selectorZones` | Limit DNS watch zones | `["subdomain.example.com]` |
| `issuer.acme.issuerKind` | Issuer or ClusterIssuer | `ClusterIssuer` |
| `aws.accessKeyId` | Configure AWS Access Key Id | `''` |
| `aws.secretAccessKey` | Configure AWS Secret Access Key | `''` |
| `aws.region` | Configure AWS Region | `us-east-1` |
| `rfc2136.dnsNameServer` | DNS server address | `''` |
| `rfc2136.tsigKeyAlgorithm` | TSIG Key Algorithm | `hmac256` |
| `rfc2136.tsigKeyName` | Key name used with dnssec-keygen | `''` |
| `certificates.apiServer.name` | Configure APIServer certficate secret name | `api-letsencrypt-cert` |
| `certificates.apiServer.namespace` | Configure APIServer certficate secret namespace | `openshift-config` |
| `certificates.apiServer.issuerRef` | Select APIServer issuer | `letsencrypt-staging` |
| `certificates.apiServer.issuerKind` | Select APIServer issuer kind | `ClusterIssuer` |
| `certificates.apiServer.dnsNames` | Configure APIServer DNS names | `["api.example.com"]` |
| `certificates.ingressController.name` | Configure IngressController certficate secret name | `ingress-letsencrypt-cert` |
| `certificates.ingressController.namespace` | Configure IngressController certficate secret namespace | `openshift-config` |
| `certificates.ingressController.issuerRef` |  Select IngressController issuer kind | `letsencrypt-staging` |
| `certificates.ingressController.issuerKind` | Select IngressController issuer kind | `ClusterIssuer` |
| `certificates.ingressController.dnsNames` | Configure IngressController DNS names | `["api.example.com"]` |
| `cluster.apiServer.enabled` | Enable APIServer ACME certificates | `false` |
| `cluster.apiServer.name` | Configure apiServer endpoint | `api.example.com` |
| `cluster.apiServer.tlsSecret` | APIServer secret name created in `certificates.apiServer.name` | `api-letsencrypt-cert` |
| `cluster.ingressController.enabled` | Enable ACME wildcard IngressController certificates | `false` |
| `cluster.caBundle` | Get latest Let's Encrypt CA and drop it here | `''` |
