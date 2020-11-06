FROM registry.access.redhat.com/ubi8/ubi:latest

USER root

COPY ubi.repo /etc/yum.repos.d/

#  ADD some useful things to UBI
RUN DISABLE_REPOS=--disablerepo='rhel-*' && \
  yum $DISABLE_REPOS --setopt=tsflags=nodocs install -y openssl && \
  yum clean all -y && \
  rm -rf /var/cache/yum

# Install some clever things 
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
  chmod 700 get_helm.sh && \
  ./get_helm.sh

USER 1001