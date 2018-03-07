#invoke npm in jenkinsfile: sh "scl enable rh-nodejs6 'npm run build'" 
FROM openshift/jenkins-slave-nodejs-rhel7:latest
USER root
RUN yum remove -y rh-nodejs4 rh-nodejs4-npm rh-nodejs4-nodejs-nodemon; \
    yum repolist > /dev/null && \
    INSTALL_PKGS="rh-nodejs6 rh-nodejs6-npm rh-nodejs6-nodejs-nodemon nss_wrapper" && \
    yum install -y --setopt=tsflags=nodocs \
      --enablerepo=rhel-server-rhscl-7-rpms \
      --enablerepo=rhel-7-server-optional-rpms \
      --enablerepo=rhel-7-server-optional-rpms \
      $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    rm -rf /var/cache/yum
USER 1001
