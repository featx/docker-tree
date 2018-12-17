#++++++++++++++++++++++++++++++++++#
#  SBT Docker container in Alpine  #
#++++++++++++++++++++++++++++++++++#

FROM openjdk:8-jre-alpine
#8u181-jre-alpine3.8
LABEL vendor=Featx
MAINTAINER Excepts <excepts@aliyun.com>

ENV SBT_HOME=/usr/local \
    SBT_VERSION=1.2.4

RUN set -ex \
    && apk add --no-cache --virtual .build-deps tar wget \
    && apk add -U bash \
    && wget -O- "https://sbt-downloads.cdnedge.bluemix.net/releases/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" \
    | tar xzf - -C ${SBT_HOME} --strip-components=1 \
    && sbt version \
    && apk del --no-cache .build-deps \
    && echo "/usr/bin/java -Dsbt.main.class=sbt.ScriptMain -Dsbt.boot.directory=/root/.sbt/boot -jar ${SBT_HOME}/bin/sbt-launch.jar \"\$@\"" \
       > ${SBT_HOME}/bin/scalas \
    && echo "/usr/bin/java -Dsbt.main.class=sbt.ConsoleMain -Dsbt.boot.directory=/root/.sbt/boot -jar ${SBT_HOME}/bin/sbt-launch.jar \"\$@\"" \
       > ${SBT_HOME}/bin/screpl \
    && chmod 775 ${SBT_HOME}/bin/* && chown -R 1000:1000 ${SBT_HOME}/bin
        
CMD ["sbt"]