FROM quay.io/openshift/origin-jenkins-agent-base:4.5

#env vars
ENV ANDROID_SLAVE_SDK_BUILDER=1.0.0 \
    NODEJS_DEFAULT_VERSION=6.9.1 \
    CORDOVA_DEFAULT_VERSION=7.0.1 \
    IONIC_DEFAULT_VERSION=3.20.0 \
    GRUNT_DEFAULT_VERSION=1.0.1 \
    FASTLANE_DEFAULT_VERSION=2.60.1 \
    GRADLE_VERSION=3.5 \
    ANDROID_HOME=/opt/android-sdk-linux \
    NVM_DIR=/opt/nvm \
    PROFILE=/etc/profile \
    CI=Y \
    BASH_ENV=/etc/profile \
    JAVA_HOME=/etc/alternatives/java_sdk_1.8.0 \
    RUBY_VERSION=2.4.2

#update PATH env var
ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$NVM_DIR:/opt/gradle/gradle-$GRADLE_VERSION/bin:$JAVA_HOME/bin

LABEL io.k8s.description="Platform for building slave android sdk image" \
      io.k8s.display-name="jenkins android sdk slave builder" \
      io.openshift.tags="jenkins-android-slave builder"

#system pakcages
RUN yum install -y \
  zlib.i686 \
  ncurses-libs.i686 \
  bzip2-libs.i686 \
  java-1.8.0-openjdk-devel \
  java-1.8.0-openjdk \
  nodejs \
  rubygems \
  gcc-c++ \
  make \
  ant \
  which\
  wget \
  expect \
  yum groupinstall -y "Development Tools" && \
  yum clean all && \
  rm -rf /var/cache/yum

RUN wget https://rvm.io/binaries/centos/7/x86_64/ruby-${RUBY_VERSION}.tar.bz2 && \
bunzip2 -dk ruby-${RUBY_VERSION}.tar.bz2 && \
tar -xvpf ruby-${RUBY_VERSION}.tar && \
(cd ruby-${RUBY_VERSION}; cp -R * /usr/local) && \
#gem install fastlane -v ${FASTLANE_DEFAULT_VERSION} --no-rdoc --no-ri && \
rm -rf ruby-${RUBY_VERSION}.tar.bz2 ruby-${RUBY_VERSION}.tar ruby-${RUBY_VERSION}

#install nvm and nodejs
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash && \
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
    echo 'export NVM_DIR=${NVM_DIR}' >> ${HOME}/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> ${HOME}/.bashrc && \
    echo 'CI=Y' >> ${HOME}/.bashrc && \
    nvm install ${NODEJS_DEFAULT_VERSION} && \
    chmod -R 777 ${NVM_DIR} && \
    npm install -g cordova@${CORDOVA_DEFAULT_VERSION} && \
    npm install -g ionic@${IONIC_DEFAULT_VERSION} && \
    npm install -g grunt@${GRUNT_DEFAULT_VERSION}

#install gradle
RUN mkdir -p /opt/gradle && \
    wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip -d /opt/gradle gradle-${GRADLE_VERSION}-bin.zip && \
    rm gradle-${GRADLE_VERSION}-bin.zip

#install jq
RUN wget -O jq  https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && \
    chmod +x ./jq &&\
    cp jq /usr/bin

#fix permissions
RUN mkdir -p $HOME/.android && \
    touch $HOME/.android/analytics.settings && \
    touch $HOME/.android/reposiories.cfg && \
    # create a symlink for the debug.keystore (source: $ANDROID_HOME/android.debug, target: $HOME/.android/debug.keystore)
    # $ANDROID_HOME/android.debug file currently doesn't exist in this image.
    # it will be there once the android-sdk volume is mounted (later in OpenShift).
    # the good thing about symlinks are that they can be created even when the source doesn't exist.
    # when the source becomes existent, it will just work.
    chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

COPY scripts/run-jnlp.sh /usr/local/bin/run-jnlp.sh

USER 1001
WORKDIR /tmp

ENTRYPOINT ["/usr/local/bin/run-jnlp.sh"]
