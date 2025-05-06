FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.18@sha256:c2993e422ddb0cf7b2b87bc84f5b7b66cf239c868e0e48e4638a0bab56475ee7

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