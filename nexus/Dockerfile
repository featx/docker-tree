#++++++++++++++++++++++++++++++++++++++#
# Nexus Docker container in Alpine     #
#++++++++++++++++++++++++++++++++++++++#

FROM java:8-jre-alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<palmtale@glad.so>

ENV GOSU_VERSION=1.7 \
    NEXUS_DATA=/mnt \
    NEXUS_HOME=/usr/local/nexus \
    NEXUS_VERSION=3.3.1-01 \
    NEXUS_GROUP=nexus \
    NEXUS_USER=nexus \
    CONTEXT_PATH=/

RUN set -ex \
    && addgroup -g 1000 $NEXUS_GROUP && adduser -G $NEXUS_GROUP -u 1000 -s /sbin/nologin -D -H $NEXUS_USER \
    && apk add -U wget gnupg \

    # Grab gosu for easy step-down from root
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \

    && mkdir -p $NEXUS_HOME \
    && wget -O nexus.tar.gz \
       https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-$NEXUS_VERSION-unix.tar.gz \
    && tar -zxvf nexus.tar.gz \
    && mv nexus-$NEXUS_VERSION/* $NEXUS_HOME/ && mv nexus-$NEXUS_VERSION/.install4j $NEXUS_HOME/ \
    && mv sonatype-work $NEXUS_HOME/../ \
    && sed \
    -e "s|karaf.home=.|karaf.home=$NEXUS_HOME|g" \
    -e "s|karaf.base=.|karaf.base=$NEXUS_HOME|g" \
    -e "s|karaf.etc=etc|karaf.etc=$NEXUS_DATA/etc|g" \
    -e "s|java.util.logging.config.file=etc|java.util.logging.config.file=$NEXUS_DATA/etc|g" \
    -e "s|karaf.data=data|karaf.data=$NEXUS_DATA/data|g" \
    -e "s|java.io.tmpdir=data/tmp|java.io.tmpdir=$NEXUS_DATA/tmp|g" \
    -i $NEXUS_HOME/bin/nexus.vmoptions \
    && apk del wget gnupg \
    && rm -rf /var/cache/apk/* nexus-$NEXUS_VERSION nexus.tar.gz \
    
    && echo -e '#!/bin/sh\n\
\n\
set -e\n\
\n\
if [ "${1:0:1}" = '-' ]; then\n\
    set -- nexus "$@"\n\
fi\n\
\n\
if [ ! -d $NEXUS_DATA/etc ]; then\n\
    mv $NEXUS_HOME/etc $NEXUS_DATA/\n\
        ln -s $NEXUS_DATA/etc $NEXUS_HOME/etc\n\
fi\n\
\n\
# mkdir -p $NEXUS_DATA/tmp $NEXUS_DATA/log\n\
chown -R $NEXUS_GROUP:$NEXUS_USER $NEXUS_DATA\n\
\n\
if [ "$1" = './bin/nexus' -a "$(id -u)" = '0' ]; then\n\
    exec gosu $NEXUS_USER "$@"\n\
else\n\
  exec "$@"\n\
fi' >> /usr/local/bin/entry \
    && chmod u+x /usr/local/bin/entry 

WORKDIR $NEXUS_HOME
VOLUME $NEXUS_DATA
EXPOSE 8081
ENTRYPOINT ["entry"]
CMD ./bin/nexus run
