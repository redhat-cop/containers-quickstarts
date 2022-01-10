FROM quay.io/openshift/origin-jenkins-agent-maven:4.6
ADD settings.xml $HOME/.m2/settings.xml
WORKDIR $HOME
RUN mvn dependency:go-offline
COPY src/ src/
RUN mvn package
USER 1001