## Notes

Registration is enabled until the following [issue](https://github.com/gogits/gogs/issues/3142) is solved, which is required to automate LDAP configuration. Using the registration utility you can set up a temporary user (it will have admin rights by default) to login in to the tool and configure LDAP integration.


## Example of LDAP Integration for other residences using IdM

| **Option**   |      **Value**    |  
|----------|:-------------:|
| **Authentication Type** |  LDAP (via BindDN) |
| **Authentication Name** |  IdM |
| **Security Protocol** | LDAPS |
| **Host** | idm.example.example.com |
| **Port** | 636 |
| **Bind DN** | uid=admin,cn=users,cn =accounts,dc=example,dc=example,dc=com |
| **User Search Base** | cn=users,cn=accounts,dc=example,dc=example,dc=com |
| **User Filter** | (&(objectClass=person)(\|(uid=%[1]s))) |
| **Admin Filter** | (memberOf=cn=gogs-admin,cn=groups,cn=accounts,dc=example,dc=example,dc=com) |
| **Username Attribute** | uid |
| **First Name Attribute** | givenName |
| **Surname Attribute** | sn |
| **Email Attribute** | mail |
| **Skip TLS Verify** | checked |
| **This authentication is activated** | checked |

### Deploy instructions

1- Create a new Project where to deploy Gogs

  ```
    $ oc new-project gogs
  ```

2- Add **gogs** Service Account to **anyuid** SCC

  ```
    $ oc adm policy add-scc-to-user anyuid system:serviceaccount:gogs:gogs
  ```

2- Process and apply the template. No mandatory parameters need to be specified. Check template for all supported parameters.

  ```
    $ oc process -f gogs-persistent-template.yaml | oc apply -f-
  ```
