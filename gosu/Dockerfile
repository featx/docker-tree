#+++++++++++++++++++++++++++++++++++++#
#   Gosu Docker container in Alpine   #
#+++++++++++++++++++++++++++++++++++++#


FROM alpine
LABEL vendor=Featx
MAINTAINER Excepts <excepts@featx.org>

ENV GOSU_VERSION=1.11

WORKDIR /usr/local

RUN set -ex \
    && addgroup -g 1000 feat && adduser -G feat -u 1000 -s /sbin/nologin -D -H feat \

    && apk add -U ca-certificates wget gnupg \
    # Grab gosu for easy step-down from root
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver pgp.mit.edu --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \

    && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf \
    && apk del ca-certificates wget gnupg \
    && rm -rf /var/cache/apk/* "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && echo -e '#!/bin/sh\n\
\n\
set -e\n\
\n\
if [ "${1:0:1}" = \047-\047 ]; then\n\
    set -- feat "$@"\n\
fi\n\
\n\
#replace#\n\
\n\
' >> /usr/local/bin/entry \
    && chmod u+x /usr/local/bin/entry

ENTRYPOINT ["/usr/local/bin/entry"]    