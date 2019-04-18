FROM docker.io/sonarqube:latest

USER root
ARG sonar_plugins="pmd gitlab github ldap"
ADD sonar.properties /opt/sonarqube/conf/sonar.properties
ADD run.sh /opt/sonarqube/bin/run.sh
CMD /opt/sonarqube/bin/run.sh
RUN cp -a /opt/sonarqube/data /opt/sonarqube/data-init && \
	cp -a /opt/sonarqube/extensions /opt/sonarqube/extensions-init && \
	chown root:root /opt/sonarqube && chmod -R gu+rwX /opt/sonarqube
ADD plugins.sh /opt/sonarqube/bin/plugins.sh
RUN /opt/sonarqube/bin/plugins.sh $sonar_plugins
RUN chown root:root /opt/sonarqube -R; \
    chmod 6775 /opt/sonarqube -R
USER 1001
