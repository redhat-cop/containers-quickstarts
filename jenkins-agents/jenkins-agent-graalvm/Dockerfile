FROM quay.io/openshift/origin-jenkins-agent-maven:4.8
ARG GRAAL_VERSION=20.3.3.0-Final
ENV GRAALVM_HOME=/opt/mandrelJDK
ENV GRAAL_CE_URL=https://github.com/graalvm/mandrel/releases/download/mandrel-${GRAAL_VERSION}/mandrel-java11-linux-amd64-${GRAAL_VERSION}.tar.gz
ARG HELM_VERSION=3.6.3
ARG JQ_VERSION=1.6
ARG OC_VERSION=4.8.2
ARG YQ_VERSION=4.11.2

ADD settings.xml $HOME/.m2/settings.xml
ADD ubi8.repo /tmp/ubi8.repo

USER root
RUN rm -f /etc/yum.repos.d/*.repo && \
    mv /tmp/ubi8.repo /etc/yum.repos.d/ubi8.repo && \
    dnf -y update && \
    dnf install -y gcc gcc-c++ glibc-static glibc-devel zlib-devel && \
    ### tools
    mkdir -p ${GRAALVM_HOME} && \
    cd ${GRAALVM_HOME} && \
    curl -fsSL $GRAAL_CE_URL | tar -xzC ${GRAALVM_HOME} --strip-components=1 && \
    curl -Lo /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x /usr/local/bin/jq && \
    curl -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar --strip-components=1 -C /usr/local/bin -xzf - linux-amd64/helm && \
    curl -Lo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq && \
    rm -f /usr/bin/oc && \
    curl -L https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz | tar -C /usr/local/bin -xzf - && \
    ### Cleanup
    dnf clean all && \
    rm -rf /var/cache/yum

USER 1001
WORKDIR ${USER_HOME_DIR}
ENV PATH ${PATH}:${GRAALVM_HOME}/bin
