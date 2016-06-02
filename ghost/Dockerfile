#++++++++++++++++++++++++++++++++++++++#
# Ghost Docker container in Alpine #
#+++++++++++++++++++++++++++++++++++++++#

FROM soglad/node:6.0.0-alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV GOSU_VERSION=1.7 \
    GHOST_SOURCE=/usr/src/ghost \
    GHOST_VERSION=0.8.0 \
    GHOST_CONTENT=/var/lib/ghost

WORKDIR $GHOST_SOURCE

RUN set -ex \
    && adduser -S soglad -g daemon \
    && apk add --no-cache ca-certificates wget gnupg gcc make python unzip \
	  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && wget -O ghost.zip "https://ghost.org/archives/ghost-${GHOST_VERSION}.zip" \
    && unzip ghost.zip \
    && npm install --production \
    && apk del ca-certificates wget gnupg gcc make python unzip \
    && rm -rf ghost.zip /tmp/npm* /var/cache/apk/* \
    && npm cache clean \
    && mkdir -p "$GHOST_CONTENT"
    && chown -R soglad:daemon "$GHOST_CONTENT"

VOLUME $GHOST_CONTENT

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 2368
CMD ["npm", "start"]
