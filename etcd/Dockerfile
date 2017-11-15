#+++++++++++++++++++++++++++++++++++++#
#   Etcd Docker container in Alpine   #
#+++++++++++++++++++++++++++++++++++++#


FROM alpine
LABEL vendor=Glad.so
MAINTAINER Palmtale <palmtale@glad.so>

ENV GOSU_VERSION=1.10 \
    ETCD_HOME=/usr/local \
    ETCD_VERSION=3.2.9

RUN set -ex \
    && addgroup -g 1000 etcd && adduser -G etcd -u 1000 -s /sbin/nologin -D -H etcd \
    && apk add -U ca-certificates wget git build-base go \

    # Grab gosu for easy step-down from root
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver pgp.mit.edu --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \

    && cd ${ETCD_HOME}/ \
    && git clone https://github.com/coreos/etcd.git \
    && cd etcd && git checkout v${ETCD_VERSION} \
    && make build && mkdir -p ${ETCD_HOME}/bin \
    && mv ./bin/* ${ETCD_HOME}/bin/ \
    && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf \
    && apk del ca-certificates git build-base go wget \
    && rm -rf /var/cache/apk/* ${ETCD_HOME}/etcd "$GNUPGHOME" /usr/local/bin/gosu.asc \
    
    # Entrypoint
    && echo -e '#!/bin/sh\n\
\n\
set -e\n\
\n\
if [ "${1:0:1}" != '-' ]; then\n\
  exec "$@"\n\
fi\n\
\n\
if [ -f ${ETCD_HOME}/etcd/etcd.conf ]; then\n\
    source ${ETCD_HOME}/etcd/etcd.conf\n\
fi\n\
\n\
if [ "$1" = 'etcd' -a "$(id -u)" = '0' ]; then\n\
    exec gosu etcd "$@"\n\
else\n\
  exec "$@"\n\
fi' >> $ETCD_HOME/bin/entry \
    && chmod u+x $ETCD_HOME/bin/entry

WORKDIR ${ETCD_HOME}
EXPOSE 2379 2380
ENTRYPOINT ["/usr/local/bin/entry"]
CMD ["etcd"]