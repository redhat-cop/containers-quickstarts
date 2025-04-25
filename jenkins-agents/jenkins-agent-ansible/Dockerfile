FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.18@sha256:ab01d7014770f49c91ee8e835d5dfa14c99f79db371ac0e005484e9d5ad5f0ef

LABEL name="redhat-cop/jenkins-agent-ansible" \
      io.k8s.display-name="Jenkins Agent Ansible" \
      io.k8s.description="The jenkins agent ansible image has ansible on top of the jenkins agent base image." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-ansible"

USER root

COPY requirements.txt /requirements.txt
RUN dnf -y install --nodocs python3.11 python3.11-pip && \
    dnf clean all && \
    pip3.11 install --no-cache-dir -r /requirements.txt

USER 1001

RUN ansible --version