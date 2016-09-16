#++++++++++++++++++++++++++++++++++++++
# Postgres Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV LANG=en_US.utf8 \
    GOSU_VERSION=1.7 \
    PG_MAJOR=9.5 \
    PG_VERSION=9.5.4 \
    PG_HOME=/usr/local \
    PG_DATA=/mnt \
    PG_DB=postgres \
    PG_USER=postgres \
    PG_GROUP=postgres \
    POSTGRES_PASSWORD=postgres \
    PG_COMPILE_ARGS="--prefix=$PG_HOME \
    --sysconfdir=/mnt/etc --datarootdir=/mnt"

# Hidden ENV PG_CONF=/var/conf PG_DATA=/var/data PG_LOGS=/var/logs

COPY entry /usr/bin/
RUN set -x \
  && chmod u+x /usr/bin/entry \
  && apk add -U build-base readline-dev openssl-dev zlib-dev libxml2-dev glib-lang wget gnupg ca-certificates \

  # grab gosu for easy step-down from root
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \

  ## wget source package and install postgresql
  && cd $PG_HOME \
  && wget -O postgresql.tar.gz https://ftp.postgresql.org/pub/source/v$PG_VERSION/postgresql-$PG_VERSION.tar.gz \
  && tar -zxf postgresql.tar.gz && rm -f postgresql.tar.gz && mv postgresql-$PG_VERSION postgresql \
  && cd postgresql \
  && ./configure $PG_COMPILE_ARGS && make world && make install-world \
  && cd $PG_HOME \

  # make the sample config easier to munge (and "correct by default")
  && sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" $PG_DATA/postgresql/postgresql.conf.sample \

  ## destructor
  && apk del build-base readline-dev openssl-dev zlib-dev libxml2-dev wget gnupg ca-certificates \
  && rm -rf "$GNUPGHOME" $PG_HOME/postgresql /usr/local/bin/gosu.asc /var/cache/apk/* \
  && mv $PG_DATA/* /tmp/ \
  && mv /tmp/postgresql /tmp/etc \
  && mv /tmp/etc/postgresql.conf.sample /tmp/etc/postgresql.conf \
	&& mv /tmp/etc/pg_hba.conf.sample /tmp/etc/pg_hba.conf \
  && chown -R $PG_GROUP:$PG_USER /tmp/

VOLUME /mnt
EXPOSE 5432

ENTRYPOINT ["entry"]
CMD ["postgres"]
