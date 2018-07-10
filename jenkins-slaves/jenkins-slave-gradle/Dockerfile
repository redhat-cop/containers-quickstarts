FROM openshift/jenkins-slave-base-centos7

ENV GRADLE_VERSION=4.8

RUN curl -skL -o /tmp/gradle-bin.zip https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip && \
    mkdir -p /opt/gradle && \
    unzip -q /tmp/gradle-bin.zip -d /opt/gradle && \
    ln -sf /opt/gradle/gradle-$GRADLE_VERSION/bin/gradle /usr/local/bin/gradle && \
    rm -f /tmp/gradle-bin.zip && \
    chown -R 1001:0 /opt/gradle && \
    chmod -R g+rw /opt/gradle

USER 1001
