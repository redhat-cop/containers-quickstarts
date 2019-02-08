FROM openshift/jenkins-slave-base-centos7:v3.11

ENV BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable" \
    ANSIBLE_VERSION=2.7.0 \
    ANSIBLE_REVISION=1

RUN INSTALL_PKGS="java-1.8.0-openjdk-devel.x86_64 git tree vim unzip curl python2-pip scl-utils" && \
    x86_EXTRA_RPMS=$(if [ "$(uname -m)" == "x86_64" ]; then echo -n java-1.8.0-openjdk-devel.i686 ; fi) && \
    yum install -y epel-release && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS $x86_EXTRA_RPMS \
      https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-${ANSIBLE_VERSION}-${ANSIBLE_REVISION}.el7.ans.noarch.rpm && \
    rpm -V ansible && \
    yum clean all -y && \
    rm -rf /var/cache/yum

# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.
ADD contrib/bin/scl_enable /usr/local/bin/scl_enable
ADD contrib/bin/configure-slave /usr/local/bin/configure-slave

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001

