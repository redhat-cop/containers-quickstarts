# cert-manager-openshift-install

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
| `namespace`                                      | Project name to install cert-manager                         | `cert-manager`                        |
| `issuer`                                         | Configure an Issuer or ClusterIssuer for cert-manager        | `{}`                                  |
| `aws`                                            | Configure AWS credentials                                    | `{}`                                  |
| `certificates`                                   | Configure APIServer, IngressController and custom certs      | `{}`                                  |
| `cluster`                                        | Enable APIServer and IngressController managed certificates  | `{}`                                  |
