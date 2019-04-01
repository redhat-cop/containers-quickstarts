# Owasp Zap

This is a modified docker image based on the owasp-zap live [image](https://hub.docker.com/r/owasp/zap2docker-live).

## Deploy the Quickstart

Deploy the quickstart and get the image built in your cluster with the following commands

```
cd owasp-zap
ansible-galaxy install -r requirements.yml -p galaxy
ansible-playbook -i .applier/ galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml
```

## Deploy Locally

Deploy the zap image locally

```
cd owasp-zap
docker build -t owasp-zap .
docker run -d owasp-zap
```
