FROM openshift/jenkins-slave-base-centos7:v3.11

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
	yum install -y \
	make \
	automake \
	autoconf \
	gcc-c++ \
	wget \
	curl \
	xmlstarlet \
	unzip \
	git-core \
	openbox \
	xterm \
	net-tools \
	python27.x86_64 \
	python27-python-libs.x86_64 \
	python27-python-pip.noarch \
	python27-python-devel.x86_64 \
	firefox \
	xorg-x11-server-Xvfb \
	x11vnc && \
	yum clean all

RUN echo "source scl_source enable python27" >> /etc/bashrc 
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/rh/python27/root/lib64
RUN /opt/rh/python27/root/usr/bin/pip install zapcli python-owasp-zap-v2.4


RUN useradd -d /home/zap -m -s /bin/bash zap
RUN echo zap:zap | chpasswd
RUN mkdir /zap && chown zap:zap /zap

WORKDIR /zap

#Change to the zap user so things get done as the right person (apart from copy)
USER zap

RUN mkdir /home/zap/.vnc

# Download and expand the latest stable release 
RUN curl -s https://raw.githubusercontent.com/zaproxy/zap-admin/master/ZapVersions.xml | xmlstarlet sel -t -v //url |grep -i Linux | wget -nv --content-disposition -i - -O - | tar zxv && \
	cp -R ZAP*/* . &&  \
	rm -R ZAP* && \
	# Setup Webswing
	curl -s -L https://bitbucket.org/meszarv/webswing/downloads/webswing-2.5.10.zip > webswing.zip && \
	unzip webswing.zip && \
	rm webswing.zip && \
	mv webswing-* webswing && \
	# Remove Webswing demos
	rm -R webswing/demo/ && \
	# Accept ZAP license
	touch AcceptedLicense


ENV PATH $JAVA_HOME/bin:/zap/:$PATH
ENV ZAP_PATH /zap/zap.sh

# Default port for use with zapcli
ENV ZAP_PORT 8080
ENV HOME /home/zap/

COPY zap* CHANGELOG.md /zap/
COPY webswing.config /zap/webswing/
COPY policies /home/zap/.ZAP/policies/
# The scan script loads the scripts from dev home dir.
COPY scripts /home/zap/.ZAP_D/scripts/
COPY .xinitrc /home/zap/

#Copy doesn't respect USER directives so we need to chown and to do that we need to be root
USER root

RUN chown zap:zap /zap/* && \
	chown zap:zap /zap/webswing/webswing.config && \
	chown zap:zap -R /home/zap/.ZAP/ && \
	chown zap:zap /home/zap/.xinitrc && \
	chmod a+x /home/zap/.xinitrc

RUN cat /zap/CHANGELOG.md
# RUN ln -sf /opt/rh/rh-python27/root/bin/python3 /bin/python
#Change back to zap at the end
USER 1001