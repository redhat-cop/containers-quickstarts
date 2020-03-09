FROM registry.access.redhat.com/ubi8

MAINTAINER Aly Ibrahim<aly@redhat.com>

ENV OC_CLIENT_MIRROR https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.3.0/openshift-client-linux-4.3.0.tar.gz
ENV HOME /home/tool-box

RUN yum -y update && \
    INSTALL_PKGS="git vim unzip python36" && \
    yum -y install $INSTALL_PKGS && \
    yum clean all

RUN curl -o jq -sL https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
    chmod +x jq && \
    mv jq /usr/local/bin

RUN mkdir -m 775 $HOME && \
    chmod 775 /etc/passwd && \
    pip3 install git+https://github.com/ansible/ansible.git@stable-2.8

RUN curl -s https://get.helm.sh/helm-v3.1.1-linux-amd64.tar.gz | tar -xvz && \
    chmod u+x linux-amd64/helm && mv linux-amd64/helm /usr/local/bin/ && rm -rf linux-amd64 

RUN curl -sL https://github.com/tektoncd/cli/releases/download/v0.3.1/tkn_0.3.1_Linux_x86_64.tar.gz | tar --no-same-owner -xvz -C /usr/local/bin/ tkn

RUN curl $OC_CLIENT_MIRROR | tar -C /usr/local/bin/ -xzf -

RUN curl -sL https://github.com/openshift/odo/releases/latest/download/odo-linux-amd64 -o /usr/local/bin/odo && chmod +x /usr/local/bin/odo

WORKDIR $HOME

ADD ./root /

RUN chmod u+x /usr/local/bin/run

USER 1001

ENTRYPOINT ["/usr/local/bin/run"]
CMD ["sleep", "infinity"]
