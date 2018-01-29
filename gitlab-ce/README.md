### Deploy instructions

1- Create a new Project where to deploy GitLab CE

  ```
    $ oc new-project gitlab-ce
  ```

2- Add **gitlab-ce-user** Service Account to **anyuid** SCC

  ```
    $ oc adm policy add-scc-to-user anyuid system:serviceaccount:gitlab-ce:gitlab-ce-user
  ```

2- Process the template with **at least** the following parameters

  ```
    $ oc process -f gitlab-ssl.yml \
      -p LDAP_HOST=<ldap host url> \
      -p LDAP_BIND_DN=<user DN for LDAP bind> \
      -p LDAP_PASSWORD=<previuos user's password> \
      -p LDAP_BASE=<ldap base where to start querying> \
      -p APPLICATION_HOSTNAME=<gitlab exposed url> \
      | oc create -f-
  ```
