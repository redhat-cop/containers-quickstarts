FROM openshift/jenkins-slave-base-centos7:latest
# FROM openshift/jenkins-slave-base-rhel7:latest

USER root
ADD https://dl.google.com/go/go1.9.3.linux-amd64.tar.gz /usr/
RUN mkdir -p /usr/src/go/src/redhat && \
    tar -xzf /usr/go1.9.3.linux-amd64.tar.gz && \
    mv $(pwd)/go /usr/local/ && \
    chown -R 1001 /usr/src/go && \
    chown -R 1001 /usr/local/go

USER 1001

ENV GOROOT /usr/local/go
ENV GOPATH /usr/src/go

ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH

# useful for verification of install
# RUN go version
# RUN go env
