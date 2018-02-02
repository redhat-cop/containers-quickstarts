#
# Zookeeper
#

DESCRIPTION := Zookeeper on OpenShift
LICENCE := Apache 2.0
NAME := Zookeeper
REPOSITORY_TYPE := git
REPOSITORY_URL := https://github.com/redhat-cop/containers-quickstarts
VENDOR := Red Hat COP

BUILD_DATE := $(strip $(shell date -u +"%Y-%m-%dT%H:%M:%SZ"))

#
# Targets
#

.PHONY: all
all:	## Install dependencies, build and deploy Zookeeper
	$(MAKE) install-deps
	$(MAKE) prepare
	$(MAKE) deploy

.PHONY: build
build:	## Build Zookeeper image
	oc start-build Zookeeper --follow

.PHONY: clean
clean:	## Clean up (delete project)
	@echo "### Deleting project zookeeper ###"
	oc delete project zookeeper

.PHONY: deploy
deploy:
	@echo "### Deploy Zookeeper StatefulSet ###"
	ansible-playbook -i inventory/hosts roles/casl-ansible/playbooks/openshift-cluster-seed.yml -e filter_tags=deploy
	@echo "### Wait for deploy to complete ###"
	timeout 300 bash -c 'until [ `oc get pod --no-headers|grep -v build|grep -c Running` -eq 3 ];do sleep 1;done' >/dev/null 2>/dev/null
	@echo "### Get pods ###"
	oc get pod
	@echo "### Get Zookeeper cluster status ###"
	sleep 5
	oc rsh zookeeper-0 sh -c 'echo stat | nc 127.0.0.1 2181'

.PHONY: install-deps
install-deps:	## Install dependencies
	@echo "### Install ansible dependencies ###"
	ansible-galaxy install -r requirements.yml --roles-path=roles

.PHONY: prepare
prepare:	## Create project, imagestreams and build Zookeeper image if it doesn't already exist
	@echo "### Create project, imagestreams and buildconfig ###"
	ansible-playbook -i inventory/hosts roles/casl-ansible/playbooks/openshift-cluster-seed.yml -e filter_tags=prepare
	@echo "### Wait for Zookeeper image to build ###"
	timeout 300 bash -c 'until [ `oc get pod --no-headers|grep build|grep -c Completed` -eq 1 ];do sleep 1;done' >/dev/null 2>/dev/null

.PHONY: help
help:	## Help for building and deploying Zookeeper on OpenShift
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

# @echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"
