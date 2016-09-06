#++++++++++++++++++++++++++++++++++++++
# OpenLDAP Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV OLDAP_HOME=/usr/local \
    OLDAP_DATA=/mnt \
    OLDAP_VERSION=OPENLDAP_REL_ENG_2_4_44 \
    OLDAP_DOMAIN="dc=glad,dc=so" \
    OLDAP_USER=ldap \
    OLDAP_GROUP=ldap \
    GOSU_VERSION=1.7

COPY entry /usr/bin/
RUN set -x \
    && chmod u+x /usr/bin/entry \
    && addgroup -g 101 -S $OLDAP_GROUP && adduser -u 100 -D -S -G $OLDAP_GROUP $OLDAP_USER \
    && apk add -U build-base wget ca-certificates db-dev gnupg \
                  db libltdl groff \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \

    && cd $OLDAP_HOME \
    && wget -O openldap.tar.gz https://github.com/openldap/openldap/archive/$OLDAP_VERSION.tar.gz \
    && tar -zxf openldap.tar.gz \
    && cd openldap-$OLDAP_VERSION \
    && ./configure --prefix=$OLDAP_HOME --datarootdir=$OLDAP_DATA --sysconfdir=/mnt/etc \
    && make && make install \
    && cd $OLDAP_HOME \
    && apk del build-base wget ca-certificates db-dev gnupg \
    && rm -rf /var/cache/apk/* openldap.tar.gz openldap-$OLDAP_VERSION "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && mv $OLDAP_DATA/* /tmp/

WORKDIR $OLDAP_HOME
EXPOSE 389
VOLUME ["$OLDAP_DATA"]
ENTRYPOINT ["entry"]
CMD ["/usr/local/libexec/slapd", "-d", "389"]
