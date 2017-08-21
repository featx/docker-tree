#+++++++++++++++++++++++++++++++++++++++#
#   Mongo Docker container in Alpine    #
#+++++++++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<palmtale@glad.so>

ENV GOSU_VERSION=1.7 \
    MONGO_MAJOR=3.4 \
    MONGO_VERSION=3.5.10 \
    MONGO_HOME=/usr/local

# Source Tar: https://fastdl.mongodb.org/src/mongodb-src-r$MONGO_VERSION.tar.gz
#              https://codeload.github.com/mongodb/mongo/tar.gz/r3.4.5
# Binary Tar: https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-$MONGO_VERSION.tgz

#src/third_party/asio-master/asio/include/asio/detail/socket_types.hpp
#src/mongo/util/net/socket_poll.h
#src/mongo/util/processinfo_linux.cpp
COPY entry $MONGO_HOME/bin/

RUN set -ex \
  && addgroup -g 1000 mongodb && adduser -G mongodb -u 1000 -s /sbin/nologin -D -H mongodb \
  && apk add -U --no-cache ca-certificates wget gnupg \

  # Grab gosu for easy step-down from root
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" \
  && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc" \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
  && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true \

  && mkdir -p $MONGO_HOME/bin \
  && wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-$MONGO_VERSION.tgz \
  && wget -o mongodb.sha256sum https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-$MONGO_VERSION.tgz.sha256 \
# && gpg --verify mongodb.tgz.sha256sum.asc \
# && grep mongodb-linux-x86_64-$MONGO_VERSION.tgz mongodb.sha256sum | sha256sum -c - \
  && tar -zxf mongodb-linux-x86_64-$MONGO_VERSION.tgz \
  && mv mongodb-linux-x86_64-$MONGO_VERSION/bin/* $MONGO_HOME/bin/ \

  && apk del ca-certificates wget gnupg \
  && rm -rf mongodb.sha256sum mongodb-linux-x86_64-$MONGO_VERSIO* /var/cache/apk/* \
  && chmod u+x -R $MONGO_HOME/bin

EXPOSE 27017
VOLUME /mnt
CMD ["mongod"]
