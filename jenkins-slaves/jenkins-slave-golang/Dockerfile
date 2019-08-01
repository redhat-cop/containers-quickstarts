FROM openshift/jenkins-slave-base-centos7:v3.11

ENV GO_VERSION_DEFAULT=1.10.2 \
    GOROOT=/usr/local/go \
    GOPATH=/usr/src/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

WORKDIR /opt
RUN curl -L -o /tmp/sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.3.0.1492.zip && \
    unzip /tmp/sonar-scanner.zip && \
    mv sonar-scanner-* sonar-scanner && \
    ln -s /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    chmod 755 /usr/local/bin/sonar-scanner
RUN if [ -z $GO_VERSION ] ; then GO_VERSION=${GO_VERSION_DEFAULT} ; fi && \
    curl -L -o /usr/go${GO_VERSION}.linux-amd64.tar.gz https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz && \
    mkdir -p /usr/src/go/src/redhat && \
    tar -xzf /usr/go${GO_VERSION}.linux-amd64.tar.gz && \
    mv $(pwd)/go /usr/local/ && \
    go get -u github.com/golang/dep/cmd/dep && \
    chown -R 1001 /usr/src/go && \
    chown -R 1001 /usr/local/go && \
    chown -R 1001 ${HOME}/.cache/go-build && \
    rm -f /usr/go${GO_VERSION}.linux-amd64.tar.gz

USER 1001

# useful for verification of install
# RUN go version
# RUN go env
