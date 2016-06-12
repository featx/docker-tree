#++++++++++++++++++++++++++++++++++++++#
# Ghost Docker container in Alpine #
#+++++++++++++++++++++++++++++++++++++++#

FROM soglad/node:6.2.1-alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV GHOST_SOURCE=/usr/src/ghost \
    GHOST_VERSION=0.8.0

RUN set -ex && mkdir -p $GHOST_SOURCE && cd $GHOST_SOURCE \
#   && addgroup -S soglad && adduser -S -g soglad soglad \
    && apk add --no-cache ca-certificates git wget gnupg gcc g++ make libc-dev python unzip sqlite-dev \
	  && wget -O ghost.zip https://ghost.org/archives/ghost-$GHOST_VERSION.zip \
    && unzip ghost.zip && git clone https://github.com/mapbox/node-sqlite3.git sqlite3 \
    && rm -f sqlite3/src/gcc-preinclude.h ghost.zip
COPY gcc-preinclude.h $GHOST_SOURCE/sqlite3/src/

RUN npm install -g node-pre-gyp node-gyp \
    && cd $GHOST_SOURCE/sqlite3 \
    && npm install --build-from-source \
    && ./node_modules/.bin/node-pre-gyp rebuild --loglevel=verbose \
    && cd ../ && mkdir node_modules && mv sqlite3 node_modules/ \
    && rm -rf node_modules/sqlite3/.git && npm install --production \
    && apk del ca-certificates git wget gnupg gcc g++ make libc-dev python unzip sqlite-dev \
    && rm -rf /tmp/npm* /var/cache/apk/* \
    && npm cache clean \
    && mkdir -p /var/lib/ghost

VOLUME /var/lib/ghost
WORKDIR $GHOST_SOURCE
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 2368
CMD ["npm", "start"]
