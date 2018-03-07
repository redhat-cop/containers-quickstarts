#invoke npm in jenkinsfile: sh "scl enable rh-nodejs6 'npm run build'" 
FROM openshift/jenkins-slave-nodejs-rhel7:latest
USER root
RUN yum install -y yum-utils && \
    yum remove -y rh-nodejs4\*; \
    yum repolist > /dev/null && \
    INSTALL_PKGS="rh-nodejs8 rh-nodejs8-npm rh-nodejs8-nodejs-nodemon nss_wrapper" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs \
      --enablerepo=rhel-server-rhscl-7-rpms \
      --enablerepo=rhel-7-server-optional-rpms \
      --enablerepo=rhel-7-server-optional-rpms \
      $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    rm -rf /var/cache/yum
USER 1001