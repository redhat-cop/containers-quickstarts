##############################################
# Stage 1 : Build go-init
##############################################
FROM docker.io/openshift/origin-release:golang-1.12 AS builder
COPY go-init/main.go /go/src/go-init/
RUN go install go-init

##############################################
# Stage 2 : Build agent with go-init
##############################################
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
COPY --from=builder /go/bin/go-init /usr/bin/go-init
USER root

LABEL name="jenkins-agent-mvn-mandrel" \
      version="4" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins Agent Maven Mandrel" \
      io.k8s.description="The jenkins agent maven image has the maven tools on top of the jenkins agent base image." \
      io.openshift.tags="openshift,jenkins,agent,maven"

ARG USER_HOME_DIR="/home/jenkins"
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk
ENV MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Duser.home=$USER_HOME_DIR"

ARG MAVEN_VERSION=3.6.3
ARG MAVEN_URL=https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz
ARG GRAAL_VERSION=20.1.0.1.Final
ENV GRAALVM_HOME /opt/mandrelJDK
ENV GRAAL_CE_URL=https://github.com/graalvm/mandrel/releases/download/mandrel-${GRAAL_VERSION}/mandrel-java11-linux-amd64-${GRAAL_VERSION}.tar.gz
ARG HELM_VERSION=3.2.3
ARG JQ_VERSION=1.6
ARG OC_VERSION=4.6
ARG YQ_VERSION=3.3.2

ENV PATH=$PATH:$JAVA_HOME/bin

RUN microdnf -y update && \
    microdnf install -y bc gettext git tar unzip zip bzip2 tar gzip gcc gcc-c++.x86_64 glibc-devel zlib-devel curl shadow-utils java-11-openjdk-devel.x86_64 glibc-langpack-en libffi-devel && \
    ### Installation of Maven
    mkdir -p ${MAVEN_HOME} ${MAVEN_HOME}/ref && \
    curl -fsSL -o /tmp/apache-maven.tar.gz ${MAVEN_URL}  && \
    tar -xzf /tmp/apache-maven.tar.gz -C ${MAVEN_HOME} --strip-components=1 && \
    ln -s ${MAVEN_HOME}/bin/mvn /usr/bin/mvn && \
    ### tools
    mkdir -p ${GRAALVM_HOME} && \
    cd ${GRAALVM_HOME} && \
    curl -fsSL $GRAAL_CE_URL | tar -xzC ${GRAALVM_HOME} --strip-components=1 && \
    curl -Lo /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x /usr/local/bin/jq && \
    curl -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar --strip-components=1 -C /usr/local/bin -xzf - linux-amd64/helm && \
    curl -Lo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq && \
    rm -f /usr/bin/oc && \
    curl -L http://mirror.openshift.com/pub/openshift-v4/clients/oc/${OC_VERSION}/linux/oc.tar.gz | tar -C /usr/local/bin -xzf - && \
    ### User management
    adduser -u 1001 -g 0 jenkins --home-dir ${USER_HOME_DIR} && \
    mkdir -p ${MAVEN_CONFIG} && \
    chown -R 1001:0 ${USER_HOME_DIR} && \
    chmod -R ug+rwX ${USER_HOME_DIR}  && \
    ### Cleanup
    microdnf clean all && \
    rm -f /tmp/apache-maven.tar.gz && \
    rm -rf /var/cache/yum

# Copy the entrypoint
ADD contrib/bin/* /usr/local/bin/

ENV LC_ALL=en_US.UTF-8
USER 1001
WORKDIR ${USER_HOME_DIR}

# Run the Jenkins JNLP client
ENTRYPOINT ["/usr/bin/go-init", "-main", "/usr/local/bin/run-jnlp-client"]
