FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.14@sha256:14b09366b07cf597e2af6ba9d8bde440b1ef7e180115664580335d2cbaea1062

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