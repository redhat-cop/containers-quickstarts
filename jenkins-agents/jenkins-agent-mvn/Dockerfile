FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.16

LABEL name="redhat-cop/jenkins-agent-mvn" \
      io.k8s.display-name="Jenkins Agent mvn" \
      io.k8s.description="The jenkins agent mvn." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-mvn"

# renovate: datasource=repology depName=ubi_8/maven
ARG MAVEN_VERSION=3.8.5

USER root

COPY settings.xml $HOME/.m2/settings.xml
RUN dnf module enable -y maven:${MAVEN_VERSION%.*} && \
    dnf install --nodocs -y maven && \
    dnf clean all

USER 1001

RUN mvn --version