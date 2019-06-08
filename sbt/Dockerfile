#++++++++++++++++++++++++++++++++++#
#  SBT Docker container in Alpine  #
#++++++++++++++++++++++++++++++++++#

FROM openjdk:11-jdk-alpine
#8-jdk-alpine

LABEL vendor=Featx
MAINTAINER Excepts <excepts@featx.org

ENV SBT_HOME=/usr/local \
    SBT_VERSION=1.2.8

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends wget \
    && wget -O- "https://sbt-downloads.cdnedge.bluemix.net/releases/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" \
    | tar xzf - -C ${SBT_HOME} --strip-components=1 \
    && sbt version \
    && apt-get remove -y wget \
    && rm -rf /var/lib/apt/lists/* \
    && echo "/usr/bin/java -Dsbt.main.class=sbt.ScriptMain -Dsbt.boot.directory=/root/.sbt/boot -jar ${SBT_HOME}/bin/sbt-launch.jar \"\$@\"" \
       > ${SBT_HOME}/bin/scalas \
    && echo "/usr/bin/java -Dsbt.main.class=sbt.ConsoleMain -Dsbt.boot.directory=/root/.sbt/boot -jar ${SBT_HOME}/bin/sbt-launch.jar \"\$@\"" \
       > ${SBT_HOME}/bin/screpl \
    && chmod 775 ${SBT_HOME}/bin/* && chown -R 1000:1000 ${SBT_HOME}/bin
        
CMD ["sbt"]