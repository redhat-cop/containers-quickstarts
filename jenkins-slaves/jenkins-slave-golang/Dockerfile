FROM openshift/jenkins-slave-base-centos7

ENV GO_VERSION=1.10.2 \
    GOROOT=/usr/local/go \
    GOPATH=/usr/src/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

ADD https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz /usr/
RUN mkdir -p /usr/src/go/src/redhat && \
    tar -xzf /usr/go${GO_VERSION}.linux-amd64.tar.gz && \
    mv $(pwd)/go /usr/local/ && \
    chown -R 1001 /usr/src/go && \
    chown -R 1001 /usr/local/go && \
    rm -f /usr/go${GO_VERSION}.linux-amd64.tar.gz

USER 1001

# useful for verification of install
# RUN go version
# RUN go env
