### OpenShift S2I Builder for Java

This Source-to-Image Builder based on RHEL 7, let's you create projects targetting Java OpenJDK 8 and built with:

##### Maven or Gradle

NOTE: If a project has a `pom.xml` and a `build.gradle`, maven will take precedence

This s2i builder image can be used with `SpringBoot`, `Vert.X`, `Wildfly Swarm`, `DropWizard` and many other microservices frameworks. 


##### BUILD ENV Options
* *APP_SUFFIX*: Jar file suffix to use to locate the generated artifact to use `(e.g. xxxxx${APP_SUFFIX}.jar)`
* *BUILDER_ARGS*: Allows you to specify options to pass to `maven` or `gradle`


##### RUN ENV Options
* *APP_OPTIONS*: Options to pass to `*java -jar app.jar ${APP_OPTIONS}*`


##### Defaults
If you do not specify any `BUILDER_ARGS`, by default the s2i image will use the following:

#### Maven Args
`-Popenshift -DskipTests -Dcom.redhat.xpaas.repo.redhatga package`

#### Gradle Args
`build -x test`

#### To test the image locally
`$ make test`
