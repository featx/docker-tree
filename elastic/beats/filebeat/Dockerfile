#++++++++++++++++++++++++++++++++++++++++++#
# Filebeat Docker container in Alpine      #
#++++++++++++++++++++++++++++++++++++++++++#

FROM java:8-jre-alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

# grab gosu for easy step-down from root
ENV GOSU_VERSION=1.7 \
    BEAT_VERSION=5.0.0 \
    BEAT_HOME=/usr/local \
    BEAT_USER=elasticsearch \
    BEAT_GROUP=elasticsearch \
    BEAT_DATA=/mnt 

COPY entry $BEAT_HOME/bin/

RUN set -ex \
    && addgroup -g 1000 $ELASTICSEARCH_GROUP && adduser -G $ELASTICSEARCH_GROUP -u 1000 -s /sbin/nologin -D -H $ELASTICSEARCH_USER \
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
	
	# Download artifact tgz.
    && wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$BEAT_VERSION-linux-x86_64.tar.gz \
    && wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$BEAT_VERSION-linux-x86_64.tar.gz.sha1 \
    
    # Verify artifact tgz.
    && grep filebeat-$BEAT_VERSION-linux-x86_64.tar.gz filebeat-$BEAT_VERSION-linux-x86_64.tar.gz.sha1 | sha256sum -c - \
    
    # Unzip & install artifact tgz.
    && tar -zxf filebeat-$BEAT_VERSION-linux-x86_64.tar.gz \
    && for path in \
        bin lib modules \
    ; do \
        mkdir -p $ELASTICSEARCH_HOME/$path; \
        mv elasticsearch-$ELASTICSEARCH_VERSION/$path/* $ELASTICSEARCH_HOME/$path/; \
        chown -R $ELASTICSEARCH_GROUP:$ELASTICSEARCH_USER $ELASTICSEARCH_HOME/$path; \
    done \
    && mkdir /tmp/elasticsearch \
    && mv elasticsearch-$ELASTICSEARCH_VERSION/config /tmp/elasticsearch/ \
    && chmod u+x $ELASTICSEARCH_HOME/bin/* \
    && sed -i '1s/bash/sh/g' $ELASTICSEARCH_HOME/bin/elasticsearch \
    # Disconstruct
    && apk del ca-certificates wget gnupg \
    && rm -rf elasticsearch-$ELASTICSEARCH_VERSION* /var/cache/apk/*

VOLUME $ELASTICSEARCH_DATA
EXPOSE 9200 9300
ENTRYPOINT ["entry"]
CMD ["filebeat"]