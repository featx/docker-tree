#++++++++++++++++++++++++++++++++++++++++++#
# Elasticsearch Docker container in Alpine #
#++++++++++++++++++++++++++++++++++++++++++#

FROM java:8-jre-alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

# grab gosu for easy step-down from root
ENV GOSU_VERSION=1.7 \
    ELASTICSEARCH_VERSION=5.0.0 \
    ELASTICSEARCH_HOME=/usr/local \
    ELASTICSEARCH_USER=elasticsearch \
    ELASTICSEARCH_GROUP=elasticsearch \
    ELASTICSEARCH_DATA=/mnt 

COPY entry $ELASTICSEARCH_HOME/bin/

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
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz.sha1 \
    
    # Verify artifact tgz.
    && grep elasticsearch-$ELASTICSEARCH_VERSION.tar.gz elasticsearch-$ELASTICSEARCH_VERSION.tar.gz.sha1 | sha256sum -c - \
    
    # Unzip & install artifact tgz.
    && tar -zxf elasticsearch-$ELASTICSEARCH_VERSION.tar.gz \
    && mv elasticsearch-$ELASTICSEARCH_VERSION/bin/* $ELASTICSEARCH_HOME/bin/ \
    && mv elasticsearch-$ELASTICSEARCH_VERSION/lib/* $ELASTICSEARCH_HOME/lib/ \
    && mv elasticsearch-$ELASTICSEARCH_VERSION/modules $ELASTICSEARCH_HOME/ \
    && mkdir -p $ELASTICSEARCH_DATA/config $ELASTICSEARCH_DATA/config/scripts \
                $ELASTICSEARCH_DATA/data $ELASTICSEARCH_HOME/logs \
    && mv elasticsearch-$ELASTICSEARCH_VERSION/config/* $ELASTICSEARCH_DATA/config/ \
    && ln -s $ELASTICSEARCH_DATA/config $ELASTICSEARCH_HOME/config \
    && ln -s $ELASTICSEARCH_DATA/data $ELASTICSEARCH_HOME/data \
    && ln -s $ELASTICSEARCH_DATA/logs $ELASTICSEARCH_HOME/logs \
    && chown -R $ELASTICSEARCH_GROUP:$ELASTICSEARCH_USER $ELASTICSEARCH_DATA \
    && chmod u+x $ELASTICSEARCH_HOME/bin/entry \

    # Disconstruct
    && apk del ca-certificates wget gnupg \
    && rm -rf elasticsearch-$ELASTICSEARCH_VERSION* /var/cache/apk/*

VOLUME $ELASTICSEARCH_DATA
EXPOSE 9200 9300
ENTRYPOINT ["entry"]
CMD ["elasticsearch"]