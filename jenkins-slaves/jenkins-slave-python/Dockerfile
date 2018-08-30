FROM openshift/jenkins-slave-base-centos7

ENV LANG C.UTF-8

RUN yum install -y --setopt=tsflags=nodocs gcc make openssl-devel wget zlib-devel libffi-devel && \
    mkdir tmp && \
    cd tmp && \
    wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz && \
    tar zxvf Python-3.7.0.tgz  && \
    cd Python-3.7.0  && \
    ./configure --prefix=$HOME/opt/python-3.7.0 && \
    make && \
    make install && \
    yum remove -y gcc make openssl-devel wget zlib-devel && \
    yum clean all

# Not removing `libffi-devel` after compilation due to bug: https://bugs.centos.org/view.php?id=10828

ENV PATH $HOME/opt/python-3.7.0/bin:$PATH

USER 1001
