#+++++++++++++++++++++++++++++++++++++++#
#   Mongo Docker container in Alpine    #
#+++++++++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV GOSU_VERSION=1.7 \
    MONGO_MAJOR=3.3 \
    MONGO_VERSION=3.3.15 \
    MONGO_HOME=/usr/local

# Source Tar: https://fastdl.mongodb.org/src/mongodb-src-r$MONGO_VERSION.tar.gz
# Binary Tar: http://downloads.mongodb.org/linux/mongodb-linux-x86_64-$MONGO_VERSION.tgz

COPY entry $MONGO_HOME/bin/

RUN set -ex \
  && addgroup -g 1000 mongodb && adduser -G mongodb -u 1000 -s /sbin/nologin -D -H mongodb \
  && apk add -U --no-cache ca-certificates wget \

  # Grab gosu for easy step-down from root
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" \
  && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc" \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true \

  && mkdir -p $MONGO_HOME/bin \
  && wget -o mongodb.tgz http://downloads.mongodb.org/linux/mongodb-linux-x86_64-$MONGO_VERSION.tgz \
  && tar -zxf mongodb.tgz && mv mongodb-linux-x86_64-$MONGO_VERSION/bin/* $MONGO_HOME/bin/ \

  && apk del ca-certificates wget \
  && rm -rf mongodb.tgz mongodb-linux-x86_64-$MONGO_VERSION /var/cache/apk/* \
  && chmod u+x -R $MONGO_HOME/bin

EXPOSE 27017
VOLUME /mnt
CMD ["mongod"]
