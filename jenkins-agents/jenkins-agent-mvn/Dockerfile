FROM quay.io/openshift/origin-jenkins-agent-maven:4.9
RUN git config --global http.sslVerify false
ADD settings.xml $HOME/.m2/settings.xml
