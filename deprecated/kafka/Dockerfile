FROM rhel:7.4

ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk \
    KAFKA_VERSION=1.0.0 \
    SCALA_VERSION=2.11 \
    KAFKA_HOME=/opt/kafka

COPY fix-permissions /usr/local/bin

RUN INSTALL_PKGS="gettext tar zip unzip hostname java-1.8.0-openjdk" && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all  && \
    mkdir -p $KAFKA_HOME && \
    curl -fsSL https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz | tar xzf - --strip 1 -C $KAFKA_HOME/ && \
    mkdir -p $KAFKA_HOME/logs && \
    /usr/local/bin/fix-permissions $KAFKA_HOME

WORKDIR "/opt/kafka"

EXPOSE 9092
