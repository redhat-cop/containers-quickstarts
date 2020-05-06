FROM registry.access.redhat.com/ubi7

LABEL maintainer="Red Hat Services"

ENV HOME /home/gitlab-runner
WORKDIR /home/gitlab-runner

ARG DUMB_INIT_VERSION=1.0.2

# add user
RUN adduser --create-home --user-group gitlab-runner \
  && chgrp -Rf root $HOME \
  && chmod -Rf g+w $HOME \
  && chmod g+w /etc/passwd

RUN update-ca-trust

# Update image
RUN yum update -y && rm -rf /var/cache/yum

# Add GitLab’s official repository
RUN curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | bash

# Install packages
RUN yum install -y \
  gitlab-runner \
  wget \
  && yum clean all

# install dumb-init
RUN wget -nv https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64 -O /usr/bin/dumb-init && \
    chmod +x /usr/bin/dumb-init && \
    dumb-init --version

# install entrypoint
COPY entrypoint /
RUN chmod +x /entrypoint \
    && chown gitlab-runner /entrypoint

USER gitlab-runner

STOPSIGNAL SIGQUIT
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
