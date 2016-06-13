#++++++++++++++++++++++++++++++++++++++#
# Ghost Docker container in Alpine #
#+++++++++++++++++++++++++++++++++++++++#

FROM soglad/node:lts
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV GHOST_SOURCE=/usr/local/ghost \
    GHOST_VERSION=0.8.0 \
    GHOST_CONTENT=/var/ghost

COPY *.* /usr/local/bin/
RUN set -ex && mkdir -p $GHOST_SOURCE && cd $GHOST_SOURCE \
#   && addgroup -S soglad && adduser -S -g soglad soglad \
    && apk --no-cache add wget unzip ca-certificates \
    && wget -O ghost.zip https://ghost.org/archives/ghost-$GHOST_VERSION.zip \
#   https://github.com/TryGhost/Ghost/releases/download/$GHOST_VERSION/Ghost-$GHOST_VERSION.zip \
    && unzip ghost.zip && rm -rf ghost.zip package.json && mv /usr/local/bin/package.json ./ \
#   && npm install --production \
    && apk del wget unzip ca-certificates \
#   && npm cache clean \
	  && rm -rf /tmp/npm* /var/cache/apk/* \
    && mkdir -p $GHOST_CONTENT \
    && chmod u+x /usr/local/bin/entrypoint.sh

WORKDIR $GHOST_SOURCE
EXPOSE 2368
VOLUME $GHOST_CONTENT

ENTRYPOINT ["entrypoint.sh"]
CMD ["npm", "start"]
