#++++++++++++++++++++++++++++++++++#
#  SBT Docker container in Alpine  #
#++++++++++++++++++++++++++++++++++#

FROM openjdk:8u151-jdk-alpine3.7
LABEL vendor=Glad.so
MAINTAINER Excepts <excepts@glad.so>

ARG SBT_HOME=/usr/local
ARG SBT_VERSION=1.1.6

RUN set -ex \
    && apk add --no-cache --virtual .build-deps tar wget \
    && apk add -U bash \
    && wget -O- "https://sbt-downloads.cdnedge.bluemix.net/releases/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" \
    | tar xzf - -C ${SBT_HOME} --strip-components=1 \
    && sbt version \
    && apk del --no-cache .build-deps

CMD ["sbt"]