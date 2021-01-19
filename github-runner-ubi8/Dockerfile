FROM registry.access.redhat.com/ubi8/ubi:latest  

ARG GITHUB_RUNNER_VERSION="2.275.1"

LABEL summary="Supports running a GitHub self-hosted runner." \
    description="Self-hosted GitHub runner" \
    io.k8s.display-name="GitHub Runner" \
    io.openshift.expose-services=""  \
    io.openshift.tags="rhel8,cicd"

RUN dnf update -y && \
    dnf install -y git hostname && \ 
    export JQ_VERSION=1.6 && \
    curl -s -Lo /tmp/jq-linux64 https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x /tmp/jq-linux64 && \
    ln -s /tmp/jq-linux64 /usr/local/bin/jq && \
    jq --version && \
    useradd -m github -u 1001

WORKDIR /home/github

RUN curl -Ls https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz | tar xz \
    && ./bin/installdependencies.sh && \
    dnf clean all

COPY entrypoint.sh ./entrypoint.sh
RUN chmod u+x ./entrypoint.sh && \
    chmod -R g=u /home/github && \
    chown -R 1001:0 /home/github

ENTRYPOINT ["/home/github/entrypoint.sh"]

USER 1001
