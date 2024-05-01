FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.14@sha256:6601534e6375831e6a090e862ee6e1e84d30da6d5ab2b3785ead48b2275d64d9

LABEL name="redhat-cop/jenkins-agent-python" \
      io.k8s.display-name="Jenkins Agent python" \
      io.k8s.description="The jenkins agent python." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-python"

USER root

COPY requirements.txt /requirements.txt
RUN dnf -y install --nodocs python3.11 python3.11-devel python3.11-pip nss_wrapper httpd httpd-devel mod_ssl mod_ldap mod_session atlas-devel gcc-gfortran libffi-devel libtool-ltdl enchant && \
    dnf clean all && \
    pip3.11 install --no-cache-dir -r /requirements.txt

USER 1001

RUN  python -V