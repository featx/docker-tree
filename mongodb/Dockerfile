#++++++++++++++++++++++++++++++++++++++#
# Mongodb Docker container in Opensuse #
#++++++++++++++++++++++++++++++++++++++#

FROM opensuse
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV GOSU_VERSION=1.7 \
    MONGO_VERSION=3.3.15 \
    MONGO_HOME=/usr/local \
    MONGO_DATA=/mnt

# Source Tar: https://fastdl.mongodb.org/src/mongodb-src-r$MONGO_VERSION.tar.gz
#              https://codeload.github.com/mongodb/mongo/tar.gz/r3.3.15
# Binary Tar: https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-$MONGO_VERSION.tgz

COPY entry $MONGO_HOME/bin/
RUN set -ex \
    && groupadd -g 1000 mongodb && useradd -G mongodb -u 1000 -s /sbin/nologin -r -M mongodb \
    && zypper in -y tar wget make gcc5 gcc5-c++ scons glibc-devel-static \

    # Grab gosu for easy step-down from root
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \

    && mkdir -p $MONGO_HOME/bin \
    && wget -O mongodb-src-r$MONGO_VERSION.tar.gz https://fastdl.mongodb.org/src/mongodb-src-r$MONGO_VERSION.tar.gz \
    && wget -O mongodb.sha256sum https://fastdl.mongodb.org/src/mongodb-src-r$MONGO_VERSION.tar.gz.sha256 \
#   && gpg --verify mongodb.sha256sum \
    && grep mongodb-src-r$MONGO_VERSION.tar.gz mongodb.sha256sum | sha256sum -c - \
    && ln -s /usr/bin/gcc-5 /usr/bin/gcc \
    && ln -s /usr/bin/g++-5 /usr/bin/g++ \
    && tar -zxf mongodb-src-r$MONGO_VERSION.tar.gz \
    && cd mongodb-src-r$MONGO_VERSION && scons core \
    && mv build/opt/mongo/* $MONGO_HOME/ && mv $MONGO_HOME/mongo* $MONGO_HOME/bin/ \
    cd / \
    && zypper rm -y tar wget make gcc5 gcc5-c++ scons glibc-devel-static \
    && rm -rf /var/cache/zypp/* mongodb.sha256sum mongodb-src-r$MONGO_VERSION* \
    && chmod u+x -R $MONGO_HOME/bin/*

EXPOSE 27017
VOLUME /mnt
CMD ["mongod"]
