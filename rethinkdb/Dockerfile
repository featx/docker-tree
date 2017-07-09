#++++++++++++++++++++++++++++++++++++++#
# rethinkdb Docker container in Alpine #
#+++++++++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<palmtale@glad.so>

ENV RTHINKDB_VERSION 2.3.5 \
    RTHINKDB_HOME=/usr/local

COPY entry $RTHINKDB_HOME/bin/

RUN set -ex \
    && apk add -U make gcc g++ protobuf jemalloc ncurses boost python libcurl libcrypto1.0 openssl-dev \
		&& apk del make gcc g++ protobuf jemalloc ncurses boost python libcurl libcrypto1.0 openssl-dev \
		&& rm -rf /var/cache/apk/* 

EXPOSE 28015 29015 8080
VOLUME ["/data"]
WORKDIR /data
CMD ["rethinkdb", "--bind", "all"]
