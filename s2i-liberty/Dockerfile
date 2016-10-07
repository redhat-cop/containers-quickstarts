# This image provides a base for building and running WildFly applications.
# It builds using maven and runs the resulting artifacts on WildFly 10.1.0 Final

FROM websphere-liberty:webProfile7

MAINTAINER Raffaele Spazzoli <rspazzol@redhat.com>

LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i \
      io.s2i.scripts-url=image:///usr/local/s2i \
      io.k8s.description="Platform for building and running JEE applications on IBM WebSphere Liberty Profile" \
      io.k8s.display-name="Liberty 16.0.0_03" \
      io.openshift.expose-services="9080/http:http, 9443/https:https" \
      io.openshift.tags="runner,liberty" 

ENV STI_SCRIPTS_PATH="/usr/local/s2i" \ 
    WORKDIR="/usr/local/workdir" \
    WLP_DEBUG_ADDRESS="7777" \
    JOLOKIA_PORT="8778"

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

RUN useradd -u 1001 -r -g 0 -s /sbin/nologin \
      -c "Default Application User" default && \
    chown -R 1001:0 /config && \
    chown -R 1001:0 /opt/ibm/wlp/usr/servers/defaultServer && \
    chown -R 1001:0 /opt/ibm/wlp/output && \
    chown -R 1001:0 /logs && \
    mkdir -p $WORKDIR/artifacts && \
    mkdir -p $WORKDIR/config && \
    chown -R 1001:0 $WORKDIR && \
    ln $STI_SCRIPTS_PATH/assemble-runtime $STI_SCRIPTS_PATH/assemble &&\
    wget -L -o $WORDIR/jolokia.jar http://search.maven.org/remotecontent?filepath=org/jolokia/jolokia-jvm/1.3.5/jolokia-jvm-1.3.5-agent.jar
    
COPY ./placeholder.txt $WORKDIR/artifacts
COPY ./placeholder.txt $WORKDIR/config

WORKDIR $WORKDIR

EXPOSE $WLP_DEBUG_ADDRESS
EXPOSE $JOLOKIA_PORT

USER 1001

CMD ["/opt/ibm/wlp/bin/server", "run", "defaultServer"]