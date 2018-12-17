#++++++++++++++++++++++++++++++++++#
# Thrift Docker container in Alpine #
#++++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Featx
MAINTAINER Excepts <excepts@aliyun.com>

ARG TRFT_HOME=/usr/local
ARG TRFT_VERSION=0.10.0

RUN set -ex && mkdir -p $NGX_HOME/src \
    && apk add --no-cache --virtual .build-deps \
        autoconf automake bison build-base boost \
        libevent-dev zlib-dev openssl-dev git \
        libtool flex python \
    && mkdir -p $TRFT_HOME/src \
    && cd $TRFT_HOME/src \
    && git clone https://github.com/apache/thrift.git \
    && cd thrift && git checkout $TRFT_VERSION \
    && ./bootstrap.sh && ./configure && make && make install \
    && rm -rf /var/cache/apk/*

CMD ["thrift"]