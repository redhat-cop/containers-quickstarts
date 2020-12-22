FROM quay.io/openshift/origin-jenkins-agent-base:4.6

ARG GO_VERSION=1.15.6
ARG SONAR_SCANNER_VERSION=4.5.0.2216
ENV GOROOT=/usr/local/go \
    GOPATH=/usr/src/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

WORKDIR /opt
RUN curl -L -o /tmp/sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip && \
    unzip /tmp/sonar-scanner.zip && \
    rm /tmp/sonar-scanner.zip && \
    mv sonar-scanner-* sonar-scanner && \
    ln -s /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    chmod 755 /usr/local/bin/sonar-scanner
RUN curl -L https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz \
    | tar zxf - -C /usr/local/ && \
    mkdir -p /usr/src/go/src/redhat && \
    go get -u github.com/golang/dep/cmd/dep && \
    chown -R 1001 /usr/src/go && \
    chown -R 1001 /usr/local/go && \
    chown -R 1001 ${HOME}/.cache/go-build && \
    rm -f /usr/go${GO_VERSION}.linux-amd64.tar.gz

USER 1001

# useful for verification of install
# RUN go version
# RUN go env
