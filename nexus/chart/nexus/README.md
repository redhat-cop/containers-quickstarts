# Sonatype Nexus

This is an extension of the upstream Sonatype Nexus chart maintained at https://github.com/oteemo/charts. While we work with them to upstream our changes, we are just pulling in their chart as a dependency.

The values file contained in this repository allows us to deploy the following:

- Nexus at a given version  (currently default of 3.19.1)
- Deploys the Nexus Kubernetes plugin which allows us to configure Nexus with a series of ConfigMaps
- By default, configures Nexus with the Red Hat and JBoss Maven repositories

Any of these values can be changed or extended by adding or removing values from the provided values.yaml

To use this chart for installation, you can run the following from this directory:

```sh
> helm dep up
> oc project <my-nexus-project>
> helm install <my-release-name> .
```

After this has been run, you can retrieve your route and login with the default nexus credentials of `admin:admin123`
