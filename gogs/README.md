## Notes

Registration is enabled until the following [issue](https://github.com/gogits/gogs/issues/3142) is solved, which is required to automate LDAP configuration. Using the registration utility you can set up a temporary user (it will have admin rights by default) to login in to the tool and configure LDAP integration.


## Example of LDAP Integration using IdM

| **Option**   |      **Value**    |  
|----------|:-------------:|
| **Authentication Type** |  LDAP (via BindDN) |
| **Authentication Name** |  IdM |
| **Security Protocol** | LDAPS |
| **Host** | idm.example.example.com |
| **Port** | 636 |
| **Bind DN** | uid=admin,cn=users,cn=accounts,dc=example,dc=example,dc=com |
| **User Search Base** | cn=users,cn=accounts,dc=example,dc=example,dc=com |
| **User Filter** | (&(objectClass=person)(\|(uid=%[1]s))) |
| **Admin Filter** | (memberOf=cn=gogs-admin,cn=groups,cn=accounts,dc=example,dc=example,dc=com) |
| **Username Attribute** | uid |
| **First Name Attribute** | givenName |
| **Surname Attribute** | sn |
| **Email Attribute** | mail |
| **Skip TLS Verify** | checked |
| **This authentication is activated** | checked |

## Prerequisites

The following prerequisites must be met prior to beginning to deploy Gogs

* 2 [Persistent Volumes](https://docs.openshift.com/container-platform/3.11/architecture/additional_concepts/storage.html). 1 for Gogs repositories data (pvc named `gogs-data`) and 1 for PostgreSQL data (pvc named `gogs-postgres-data`) or a cluster that supports [dynamic provisioning with a default StorageClass](https://docs.openshift.com/container-platform/3.11/install_config/storage_examples/storage_classes_dynamic_provisioning.html)
* OpenShift Command Line Tool
* [Openshift Applier](https://github.com/redhat-cop/openshift-applier/) to deploy Gogs. As a result you'll need to have [ansible installed](http://docs.ansible.com/ansible/latest/intro_installation.html)


### Environment Setup

1. Clone this repository: `git clone https://github.com/redhat-cop/containers-quickstarts`
2. `cd containers-quickstarts/gogs`
3. Run `ansible-galaxy install -r requirements.yml --roles-path=galaxy`
4. Login to OpenShift: `oc login -u <username> https://master.example.com:8443`

:heavy_exclamation_mark: Gogs container will run under `anyuid` SCC. Ensure you are logged into the Cluster (step 4) with an user with privileges to modify existing SecurityContextConstraints

### Deploy Gogs

Run the openshift-applier to create the `gogs` project and deploy required objects
```
ansible-playbook -i ./inventory galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml
```

### Cleaning up

```
oc delete project gogs
```
