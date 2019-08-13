#++++++++++++++++++++++++++++++++++++++++++++#
#     Jenkins Docker container in Alpine     #
#++++++++++++++++++++++++++++++++++++++++++++#

FROM openjdk:8-jre-alpine
LABEL vendor=Featx
MAINTAINER Excepts <excepts@featx.org>

ENV JENKINS_HOME=/var/jenkins_home \
    JENKINS_VERSION=2.189 \
    JENKINS_UC=https://updates.jenkins.io \
    JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental \
    JENKINS_SHA=59a6476c7d02bb03bfac36920856a12268f35bdc9b40ef235b14f2f6504b67ea \
    JENKINS_HTTP_PORT=8080 \
    JENKINS_SLAVE_AGENT_PORT=50000

COPY jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY plugins.sh /usr/local/bin/plugins.sh
COPY install-plugins.sh /usr/local/bin/install-plugins.sh

RUN set -e \
    && export JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war \ 
    && export COPY_REFERENCE_FILE_LOG=$JENKINS_HOME/copy_reference_file.log \
    && addgroup -g 1000 jenkins && adduser -G jenkins -u 1000 -s /sbin/nologin -D -H jenkins \
    && apk add --no-cache git openssh-client curl unzip bash ttf-dejavu coreutils tini tzdata docker \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && mkdir -p /usr/share/jenkins/ref/init.groovy.d ${JENKINS_HOME} \
    && curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war \
    && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha256sum -c - \
    && chown -R jenkins:jenkins ${JENKINS_HOME} /usr/share/jenkins/ref \
    && chmod +x /usr/local/bin/*.sh \
    && apk del tzdata \
    && rm -rf /var/cache/apk/* 

USER jenkins
# http://mirrors.jenkins.io/war/2.189/jenkins.war.sha256
# see https://github.com/docker/docker/issues/8331  

WORKDIR ${JENKINS_HOME}
VOLUME ${JENKINS_HOME}
EXPOSE ${JENKINS_HTTP_PORT} ${JENKINS_SLAVE_AGENT_PORT}
HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD curl http://127.0.0.1:8080/
ENTRYPOINT ["tini", "--", "/usr/local/bin/jenkins.sh"]
