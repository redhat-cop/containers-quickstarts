# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.5-1744101466@sha256:ea57285741f007e83f2ee20423c20b0cbcce0b59cc3da027c671692cc7efe4dd AS builder

# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=v4.45.1
# renovate: datasource=github-releases depName=stedolan/jq
ARG JQ_VERSION=1.6

RUN curl -L "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq && \
    yq --version

RUN curl -L "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64" -o /usr/local/bin/jq && \
    chmod +x /usr/local/bin/jq && \
    jq --version

# Runnable
FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.18

# renovate: datasource=repology depName=ubi_8/nodejs
ARG NODEJS_VERSION=20

LABEL name="redhat-cop/jenkins-agent-npm" \
      io.k8s.display-name="Jenkins Agent npm" \
      io.k8s.description="The jenkins agent npm." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-npm"

ENV NPM_CONFIG_PREFIX="$HOME/.npm-global" \
    PATH="$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH"

USER root

COPY package.json /tmp/package.json
RUN dnf module enable -y nodejs:${NODEJS_VERSION} && \
    dnf install --nodocs -y nodejs && \
    dnf clean all && \
    npm install -g /tmp

RUN chown -R 1001:0 "/home/jenkins/.npm" && \
    chmod -R 775 "/home/jenkins/.npm"

COPY --from=builder /usr/local/bin/yq /usr/local/bin/yq
COPY --from=builder /usr/local/bin/jq /usr/local/bin/jq

USER 1001

RUN yq --version && \
    jq --version && \
    npm -v && \
    node -v
