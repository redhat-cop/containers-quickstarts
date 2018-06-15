FROM debian:jessie

MAINTAINER Marcos Entenza (mak@redhat.com)

ENV GID 28000
ENV UID 28000
ENV DEBIAN_FRONTEND noninteractive

RUN groupadd --gid $GID grafana && useradd --uid $UID -m -g grafana grafana


RUN apt-get update && \
    apt-get -y --no-install-recommends install libfontconfig curl ca-certificates && \
    apt-get install -y wget && \
    apt-get install -y git && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y nodejs && \
    apt-get install -y build-essential && \
    apt-get clean && \
    curl https://s3-us-west-2.amazonaws.com/grafana-releases/master/grafana_latest_amd64.deb > /tmp/grafana.deb && \
    dpkg -i /tmp/grafana.deb && \
    rm /tmp/grafana.deb && \
    curl -L https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64 > /usr/sbin/gosu && \
    chmod +x /usr/sbin/gosu && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN cd /home/grafana && \
    git clone https://github.com/skydive-project/skydive-grafana-datasource.git && \
    cd skydive-grafana-datasource && \
    git checkout dev && \
    npm i && \
    ./node_modules/grunt-cli/bin/grunt && \
    mkdir -p /var/lib/grafana/plugins && \
    ln -s `pwd`/dist /var/lib/grafana/plugins/skydive-grafana-datasource

RUN chown -R 28000 /etc/grafana /var/lib/grafana /var/log/grafana /home/grafana


VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

EXPOSE 3000

COPY ./src/run.sh /run.sh

RUN chown 28000 /run.sh /etc/grafana/grafana.ini && \
    chmod +x /run.sh

USER 28000

CMD ["/run.sh"]
