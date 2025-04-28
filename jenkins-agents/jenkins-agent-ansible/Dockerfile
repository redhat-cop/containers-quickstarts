FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.18@sha256:44fdf156ad69a0801c151ca9b4f5271aa81e2508a7fd1de14109006bcf33fa6f

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