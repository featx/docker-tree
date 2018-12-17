#++++++++++++++++++++++++++++++++++++++
# OpenLDAP Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Featx
MAINTAINER Excepts <excepts@aliyun.com>

ENV OLDAP_HOME=/usr/local \
    OLDAP_DATA=/mnt \
    OLDAP_VERSION=OPENLDAP_REL_ENG_2_4_46 \
    OLDAP_DOMAIN="dc=glad,dc=so" \
    OLDAP_USER=ldap \
    OLDAP_GROUP=ldap \
    OLDAP_COMPILE_ARGS="--enable-modules --enable-slapd --enable-spasswd \
    --with-cyrus-sasl --enable-overlays=mod --enable-sql --enable-shell \
    --enable-meta --enable-passwd --enable-null --enable-ldap --enable-monitor"
# It's not required gosu, because of "slapd -u"

RUN set -x \
    
    && addgroup -g 101 -S $OLDAP_GROUP && adduser -u 100 -D -S -G $OLDAP_GROUP $OLDAP_USER \
    && apk add -U build-base m4 wget ca-certificates gnupg db-dev openssl-dev cyrus-sasl-dev unixodbc-dev \
                  db openssl groff cyrus-sasl unixodbc \

    && wget http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz \
    && tar -zxf libtool-2.4.6.tar.gz \
    && cd libtool-2.4.6 && ./configure --prefix=/usr && make && make install \
    && cd libltdl && ./configure --prefix=/usr && make && make install \

    && cd $OLDAP_HOME \
    && wget -O openldap.tar.gz https://github.com/openldap/openldap/archive/$OLDAP_VERSION.tar.gz \
    && tar -zxf openldap.tar.gz \
    && cd openldap-$OLDAP_VERSION \
    && ./configure --prefix=$OLDAP_HOME --datarootdir=$OLDAP_DATA --sysconfdir=$OLDAP_DATA/etc \
        $OLDAP_COMPILE_ARGS \
    && make depend && make && make install \
    && cd $OLDAP_HOME \
    && apk del build-base m4 wget ca-certificates gnupg db-dev openssl-dev cyrus-sasl-dev unixodbc-dev \
    && rm -rf /var/cache/apk/* openldap.tar.gz openldap-$OLDAP_VERSION libtool-2.4.6.tar.gz \
    && mv $OLDAP_DATA/* /tmp/ \

    && echo -e '#!/bin/sh\n\
\n\
ulimit -n 8192\n\
\n\
set -e\n\
\n\
if [ ! -d $OLDAP_DATA/etc ]; then\n\
    mv /tmp/* $OLDAP_DATA/\n\
fi\n\
\n\
chown -R $OLDAP_GROUP:$OLDAP_USER $OLDAP_HOME\n\
chown -R $OLDAP_GROUP:$OLDAP_USER $OLDAP_DATA\n\
\n\
exec "$@"' >> /usr/bin/entry \
    && chmod u+x /usr/bin/entry 

WORKDIR $OLDAP_HOME
EXPOSE 389
VOLUME $OLDAP_DATA
ENTRYPOINT ["entry"]
CMD ["/usr/local/libexec/slapd", "-d", "32768", "-u", "ldap", "-g", "ldap"]
