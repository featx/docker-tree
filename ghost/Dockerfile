#++++++++++++++++++++++++++++++++++++++#
# Ghost Docker container in Alpine #
#+++++++++++++++++++++++++++++++++++++++#

FROM soglad/node:6.2.1-alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV GHOST_SOURCE=/usr/src/ghost \
    GHOST_VERSION=0.8.0

WORKDIR $GHOST_SOURCE

RUN set -ex \
#   && addgroup -S soglad && adduser -S -g soglad soglad \
    && apk add --no-cache ca-certificates wget gnupg gcc g++ make python unzip sqlite-dev \
	  && wget -O ghost.zip https://ghost.org/archives/ghost-$GHOST_VERSION.zip \
    && unzip ghost.zip \
    && npm install sqlite3 --build-from-source --sqlite=/usr/local
    && npm install --production \
    && apk del ca-certificates wget gnupg gcc g++ make python unzip sqlite-dev \
    && rm -rf ghost.zip /tmp/npm* /var/cache/apk/* \
    && npm cache clean \
    && mkdir -p /var/lib/ghost

VOLUME /var/lib/ghost

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 2368
CMD ["npm", "start"]
