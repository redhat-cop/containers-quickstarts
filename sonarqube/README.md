# SonarQube 
This is a modified Docker image based on the [public sonarqube:latestimage](https://hub.docker.com/_/sonarqube/), 
but it has been modified to allow permissions to be run in an OpenShift environment.

## Enhancements On Top of the Base SonarQube Image 

* ability to define plugins to be installed the first time the container is run. 
* supports for persistent volumes for configuration, plugins & elastic indices
* additional configuration options

## Usage

### Database

By default, SonarQube will use H2 embedded, which is only for demo usage. To use a proper database, set `JDBC_USER`, `JDBC_PASSWORD` and `JDBC_URL` per [the docs](https://docs.sonarqube.org/display/SONAR/Installing+the+Server#InstallingtheServer-installingDatabaseInstallingtheDatabase).


### Plugin Installation

TODO

When the container image is built, the environment variable "SONAR_PLUGINS_LIST" should contain a space separated list 
of plugins which should be installed. More plugins can always be installed later as well.

### Configuration
Some configuration settings are well defined, but you can always pass additional configuration using the catchall
`SONARQUBE_WEB_JVM_OPTS`. Any Java properties placed in this environment variable will be passed to the SonarQube 
application. The format of the Java properties is like `-Dsome.java.property=someValue`, so you can add an environment
variable like `SONARQUBE_WEB_JVM_OPTS="-Dsonar.auth.google.allowUsersToSignUp=false -Dsonar.auth.google.enabled=true"`

### Pre-defined Configuration Variables


* Variable: SONAR_PLUGINS_LIST
  * displayName: SonarQube Plugins List
  * Description: "Space separated list of plugins (See: https://docs.sonarqube.org/display/PLUG/Plugin+Version+Matrix)"
  * Default Value: findbugs pmd ldap buildbreaker github gitlab
* Variable: SONARQUBE_WEB_JVM_OPTS
  * displayName: Extra SonarQube startup properties
  * Description: Extra startup properties for SonarQube (in the form of "-Dsonar.someProperty=someValue")
  * Default Value:
* Variable: JDBC_USER
  * Description: Username for database user that will be used for accessing the database.
  * displayName: database Connection Username
  * from: user[A-Z0-9]{3}
  * generate: expression
  * Required: true
* Variable: JDBC_PASSWORD
  * Description: Password for the database connection user.
  * displayName: database Connection Password
  * from: '[a-zA-Z0-9]{16}'
  * generate: expression
  * Required: true
* Variable: JDBC_URL
  * displayName: JDBC URL for connecting to the SonarQube database
  * Description: Password used for SonarQube database authentication (leave blank to use ephemeral database)
  * Default Value: "jdbc:postgresql://postgresql:5432/sonar"
* Variable: LDAP_BINDDN
  * displayName: LDPA bind Distinguished Name
  * Description: Bind DN for LDAP authentication (leave blank for local authentication)
  * Default Value:
* Variable: LDAP_BINDPASSWD
  * displayName: LDAP bind password
  * Description: Bind password for LDAP authentication (leave blank for local authentication)
  * Default Value:
* Variable: LDAP_URL
  * displayName: LDAP server URL
  * Description: LDAP URL for authentication (leave blank for local authentication)
  * Default Value:
* Variable: LDAP_REALM
  * displayName: LDAP realm
  * Description: "A realm defines the namespace from which the authentication entity (the value of the Context.SECURITY_PRINCIPAL property) is selected. (See: http://docs.oracle.com/javase/jndi/tutorial/ldap/security/digest.html)"
  * Default Value:
* Variable: LDAP_CONTEXTFACTORY
  * displayName: JNDI ContextFactory to be used
  * Description: The context factory is a Java class which is used for creating bindings to LDAP servers. The default value should work with most LDAP servers.
  * Default Value: com.sun.jndi.ldap.LdapCtxFactory
* Variable: LDAP_STARTTLS
  * displayName: Enable StartTLS
  * Description: Tells the LDAP plugin to use TLS for connections to the LDAP server
  * Default Value: "false"
* Variable: LDAP_AUTHENTICATION
  * displayName: LDAP authentication method
  * Description:  "Typical values include: simple | CRAM-MD5 | DIGEST-MD5 | GSSAPI"
  * Default Value: simple
* Variable: LDAP_USER_BASEDN
  * displayName: LDAP user base Distinguished Name
  * Description: LDAP BaseDN under which to search for user objects
  * Default Value:
* Variable: LDAP_USER_REQUEST
  * displayName: LDAP user object filter
  * Description: A filter definition which will cause the LDAP server to only return user objects
  * Default Value: (&(objectClass=inetOrgPerson)(uid={login}))
* Variable: LDAP_USER_REAL_NAME_ATTR
  * displayName: LDAP user's real name atrribute
  * Description: LDAP attribute on the user object which will be used to get the user's full name
  * Default Value: cn
* Variable: LDAP_USER_EMAIL_ATTR
  * displayName: LDAP user e-mail attribute
  * Description: LDAP attribute which holds the user's e-mail address
  * Default Value: mail
* Variable: LDAP_GROUP_BASEDN
  * displayName: LDAP group base Distinguished Name
  * Description: LDAP BaseDN under which to search for group objects
  * Default Value:
* Variable: LDAP_GROUP_REQUEST
  * displayName: LDAP group object filter
  * Description: A filter definition which will cause the LDAP server to only return group objects
  * Default Value: (&(objectClass=groupOfUniqueNames)(uniqueMember={dn}))
* Variable: LDAP_GROUP_ID_ATTR
  * displayName: LDAP group ID attribute
  * Description: LDAP attribute from the group object which holds the group's ID
  * Default Value: cn
* Variable: SONARQUBE_BUILDBREAKER_MAX_ATTEMPTS
  * displayName: Max BuildBreaker attempts
  * Description: Build Breaker plugin - Max number of poll attempts before failing to get analysis results
  * Default Value: "30"
* Variable: SONARQUBE_BUILDBREAKER_INTERVAL
  * displayName: Poll Interval
  * Description: Build Breaker plugin - Interval to wait between poll requests to get analysis results
  * Default Value: "20000"
* Variable: SONARQUBE_BUILDBREAKER_THRESHOLD
  * displayName: Failure threshold
  * Description: Build Breaker plugin - Threshold of an issue at which a build will instantly break regardless of all other analysis results
  * Default Value: "CRITICAL"
* Variable: SONAR_BUILDBREAKER_DISABLE
  * displayName: Disable Build Breaker plugin
  * Description: Build Breaker plugin - Disable the build breaker plugin for all builds
  * Default Value: "true"
* Variable: FORCE_AUTHENTICATION
  * displayName: Require Authentication
  * Description: Require authentication for all requests to sonarqube
  * Default Value: "true"