# Jenkins Ansible Slave

This is a Jenkins Slave designed to run in OpenShift as described [here](https://docs.openshift.com/container-platform/3.7/using_images/other_images/jenkins.html#using-the-jenkins-kubernetes-plug-in-to-run-jobs). The slave should stay in sync with [the openshift applier image](https://github.com/redhat-cop/casl-ansible/tree/master/images/openshift-applier) in order to provide a common runtime environment.

TODO At the moment, it is out of sync as CASL needs pre-release versions of ansible 2.5. Once ansible 2.5 is released, these images will align and this comment will be removed.