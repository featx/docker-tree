#++++++++++++++++++++++++++++++++++++++++++#
#    Kibana Docker container in Alpine     #
#++++++++++++++++++++++++++++++++++++++++++#

FROM soglad/node
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

# grab gosu for easy step-down from root
ENV GOSU_VERSION=1.7 \
    KIBANA_VERSION=5.0.0 \
    KIBANA_HOME=/usr/local \
    KIBANA_USER=elasticsearch \
    KIBANA_GROUP=elasticsearch \
    KIBANA_DATA=/mnt 

COPY entry $KIBANA_HOME/bin/

RUN set -ex \
    && addgroup -g 1000 $KIBANA_GROUP && adduser -G $KIBANA_GROUP -u 1000 -s /sbin/nologin -D -H $KIBANA_USER \
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
    && wget https://artifacts.elastic.co/downloads/kibana/kibana-$KIBANA_VERSION-linux-x86_64.tar.gz \
    && wget https://artifacts.elastic.co/downloads/kibana/kibana-$KIBANA_VERSION-linux-x86_64.tar.gz.sha1 \
    
    # Verify artifact tgz.
    && grep kibana-$KIBANA_VERSION-linux-x86_64.tar.gz kibana-$KIBANA_VERSION-linux-x86_64.tar.gz.sha1 | sha256sum -c - \
    
    # Unzip & install artifact tgz.
    && tar -zxf kibana-$KIBANA_VERSION-linux-x86_64.tar.gz \
    && for path in \
        src optimize node_modules webpackShims \
    ; do \
        mkdir -p $KIBANA_HOME/$path; \
        mv kibana-$KIBANA_VERSION/$path/* $KIBANA_HOME/$path/; \
        chown -R $KIBANA_GROUP:$KIBANA_USER $KIBANA_HOME/$path; \
    done \
    && mkdir /tmp/kibana \
    && mv kibana-$KIBANA_VERSION/config /tmp/kibana/ \
    && chmod u+x $KIBANA_HOME/bin/* \

    # Disconstruct
    && apk del ca-certificates wget gnupg \
    && rm -rf kibana-$KIBANA_VERSION* /var/cache/apk/*

WORKDIR $KIBANA_HOME
VOLUME $KIBANA_DATA
EXPOSE 5601
ENTRYPOINT ["entry"]
CMD ["kibana"]