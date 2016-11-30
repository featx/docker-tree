#+++++++++++++++++++++++++++++++++++++++#
#  MyCollab Docker container in Alpine  #
#+++++++++++++++++++++++++++++++++++++++#

FROM java:8-jre-alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV GOSU_VERSION=1.7 \
    MYCOLLAB_HOME=/usr/local \
    MYCOLLAB_DATA=/mnt
    MYCOLLAB_VERSION=5.4.5 \
    MYCOLLAB_USER=mycollab \
    MYCOLLAB_GROUP=mycollab

COPY entry $MYCOLLAB_HOME/bin/

RUN set -ex \
    && addgroup -g 1000 $MYCOLLAB_GROUP && adduser -G $MYCOLLAB_GROUP -u 1000 -s /sbin/nologin -D -H $MYCOLLAB_USER \
    && apk add -U --no-cache ca-certificates wget unzip \

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
    && wget https://github.com/MyCollab/mycollab/releases/download/Release_$MYCOLLAB_VERSION/MyCollab-Pro-All-$MYCOLLAB_VERSION.zip \
    #&& wget https://MyCollab-Pro-All-$MYCOLLAB_VERSION.zip.sha1 \
    # Verify artifact tgz.
    #&& grep MyCollab-Pro-All-$MYCOLLAB_VERSION.zip MyCollab-Pro-All-$MYCOLLAB_VERSION.zip.sha1 | sha256sum -c - \

    # Unzip & install artifact tgz.
    && unzip MyCollab-Pro-All-$MYCOLLAB_VERSION.zip \
    && for path in \
        bin i18n lib webapp \
    ; do \
        mkdir -p $MYCOLLAB_HOME/$path; \
        mv MyCollab-$MYCOLLAB_VERSION/$path/* $MYCOLLAB_HOME/$path/; \
        chown -R $MYCOLLAB_GROUP:$MYCOLLAB_USER $MYCOLLAB_HOME/$path; \
    done \
    && mv MyCollab-$MYCOLLAB_VERSION/executor.jar $MYCOLLAB_HOME/ \
    && mkdir -p /tmp/conf /tmp/logs \
    && mv MyCollab-$MYCOLLAB_VERSION/conf/* /tmp/conf/ \
    && mv MyCollab-$MYCOLLAB_VERSION/logs/* /tmp/logs/ \
    # Disconstruct
    && apk del ca-certificates wget unzip \
    && rm -rf MyCollab-Pro-All-$MYCOLLAB_VERSION.zip MyCollab-$MYCOLLAB_VERSIONs \
       /var/cache/apk/* $MYCOLLAB_HOME/bin/*.exe $MYCOLLAB_HOME/bin/*.bat \
    && chmod u+x $MYCOLLAB_HOME/bin/*

VOLUME $MYCOLLAB_DATA
EXPOSE 8080 32645
ENTRYPOINT ["entry"]
CMD ["mycollab.sh", "start"]
