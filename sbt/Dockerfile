#++++++++++++++++++++++++++++++++++#
#  SBT Docker container in Alpine  #
#++++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Glad.so
MAINTAINER Excepts <excepts@glad.so>

ARG SBT_HOME=/usr/local
ARG SBT_VERSION=1.1.5

RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
               tar wget \
    && wget -O- "https://sbt-downloads.cdnedge.bluemix.net/releases/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" \
    | tar xzf - -C ${SBT_HOME} --strip-components=1 \
    && sbt \
    && apk del --no-cache .build-deps
