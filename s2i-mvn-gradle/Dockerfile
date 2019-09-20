# openjdk-gradle
FROM registry.access.redhat.com/rhel 

# TODO: Put the maintainer name in the image metadata
LABEL maintainer="Abhishek Singh <abhishek@linux.com>" \
      io.k8s.description="Builder Image for building Java applications with Maven 3.5.3 or Gradle 4.8 on RHEL 7" \
      io.k8s.display-name="S2I builder 1.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,maven-3.5.3,gradle-4.8,java,openjdk-gradle"


# TODO: Rename the builder environment variable to inform users about application you provide them
ENV BUILDER_VERSION 1.0
ENV MAVEN_VERSION 3.5.3
ENV GRADLE_VERSION 4.8

# TODO: Install required packages here:
# Install Java
RUN INSTALL_PKGS="tar unzip which lsof java-1.8.0-openjdk java-1.8.0-openjdk-devel" && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    mkdir -p /opt/openshift && \
    mkdir -p /opt/app-root/source && chmod -R a+rwX /opt/app-root/source && \
    mkdir -p /opt/s2i/destination && chmod -R a+rwX /opt/s2i/destination && \
    mkdir -p /opt/app-root/src && chmod -R a+rwX /opt/app-root/src

# Install Maven 3.5.3
RUN curl -O http://apache.mirrors.tds.net/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    tar -C /usr/local -zxf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    rm -rf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    mv /usr/local/apache-maven-$MAVEN_VERSION /usr/local/maven && \
    ln -sf /usr/local/maven/bin/mvn /usr/local/bin/mvn && \
    mkdir -p $HOME/.m2 && chmod -R a+rwX $HOME/.m2 

#Install Gradle
RUN curl -O https://downloads.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip && \
    unzip gradle-$GRADLE_VERSION-bin.zip -d /usr/local && \
    rm -rf gradle-$GRADLE_VERSION-bin.zip && \
    mv /usr/local/gradle-${GRADLE_VERSION} /usr/local/gradle && \
    ln -sf /usr/local/gradle/bin/gradle /usr/local/bin/gradle

ENV PATH=/opt/maven/bin/:/opt/gradle/bin/:$PATH

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY /s2i/bin/ /usr/local/s2i
LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/openshift

# This default user is created in the registry.access.redhat.com/rhel image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080

# TODO: Set the default CMD for the image
CMD ["/usr/local/s2i/usage"]
