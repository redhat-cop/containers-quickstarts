FROM sonarqube:latest

USER root
ADD sonar.properties /opt/sonarqube/conf/sonar.properties
ADD run.sh /opt/sonarqube/bin/run.sh
CMD /opt/sonarqube/bin/run.sh
RUN cp -a /opt/sonarqube/data /opt/sonarqube/data-init && \
	cp -a /opt/sonarqube/extensions /opt/sonarqube/extensions-init && \
	chown 65534:0 /opt/sonarqube && chmod -R gu+rwX /opt/sonarqube
ADD plugins.sh /opt/sonarqube/bin/plugins.sh
RUN /opt/sonarqube/bin/plugins.sh pmd gitlab github ldap
RUN chown root:root /opt/sonarqube -R; \
    chmod 6775 /opt/sonarqube -R
USER 1001
