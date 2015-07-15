FROM jenkins
ENV MAVEN_HOME /usr/share/maven/bin/

USER root
RUN \
apt-get update -y && \
apt-get install -y maven && \
apt-get install -y git

COPY plugins.txt /usr/share/jenkins/ref/

RUN bash /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

USER jenkins
