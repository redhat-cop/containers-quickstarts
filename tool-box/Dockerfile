FROM fedora:latest

ENV OC_CLIENT_MIRROR https://mirror.openshift.com/pub/openshift-v3/clients/3.9.14/linux/oc.tar.gz
ENV HOME /home/tool-box

RUN dnf -y update && \
    INSTALL_PKGS="git tree vim unzip python-pip" && \
    dnf -y install $INSTALL_PKGS && \
    dnf clean all && \
    curl $OC_CLIENT_MIRROR | tar -C /usr/local/bin/ -xzf - && \
    mkdir -m 775 $HOME && \
    chmod 775 /etc/passwd && \
    pip install git+https://github.com/ansible/ansible.git@stable-2.5
    
WORKDIR $HOME

ADD ./s2i /usr/libexec/s2i

RUN chmod u+x /usr/libexec/s2i/run

USER 1001

CMD ["/usr/libexec/s2i/run"]
