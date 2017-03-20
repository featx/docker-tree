#++++++++++++++++++++++++++++++++++++++
# Postgres Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV LANG=en_US.utf8 \
    GOSU_VERSION=1.7 \
    PG_MAJOR=9.6 \
    PG_VERSION=9.6.2 \
    PG_HOME=/usr/local \
    PG_DATA=/mnt \
    PG_GROUP=postgres \
    PG_USER=postgres \
    PGDATA=/mnt/data \
    PGDATABASE=postgres \
    PGUSER=postgres \
    PGPASSWORD=postgres \
    PG_COMPILE_ARGS="--prefix=$PG_HOME \
      --datarootdir=/mnt --sysconfdir=/mnt/data \
      --with-openssl --with-ldap \
      --with-libxslt --with-libxml"

# Hidden ENV PG_CONF=/mnt/data PG_LOGS=/mnt/log

COPY entry /usr/bin/
RUN set -ex \
  && chmod u+x /usr/bin/entry \
  && apk add -U build-base wget gnupg ca-certificates \
                readline-dev zlib-dev libxml2-dev openldap-dev libxslt-dev \
                glib-lang readline zlib libxml2 openldap \

  # Grab gosu for easy step-down from root
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \

  # Wget source package and install postgresql
  && cd $PG_HOME \
  && wget -O postgresql.tar.gz https://ftp.postgresql.org/pub/source/v$PG_VERSION/postgresql-$PG_VERSION.tar.gz \
  && wget -O postgresql.tar.gz.sha256 https://ftp.postgresql.org/pub/source/v$PG_VERSION/postgresql-$PG_VERSION.tar.gz.sha256 \
  && grep postgresql-$PG_VERSION.tar.gz postgresql-$PG_VERSION.tar.gz.sha256 | sha256sum -c - \
  && tar -zxf postgresql.tar.gz && mv postgresql-$PG_VERSION postgresql \
  && cd postgresql \
  && ./configure $PG_COMPILE_ARGS && make world && make install-world \
  && cd $PG_HOME \

  # make the sample config easier to munge (and "correct by default")
  && sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" $PG_DATA/postgresql/postgresql.conf.sample \
  && sed -ri "s!^#?(data_directory)\s*=\s*\S+.*!\1 = '/mnt/data'!" $PG_DATA/postgresql/postgresql.conf.sample \
  && sed -ri "s!^#?(hba_file)\s*=\s*\S+.*!\1 = '/mnt/data/pg_hba.conf'!" $PG_DATA/postgresql/postgresql.conf.sample \
  && sed -ri "s!^#?(ident_file)\s*=\s*\S+.*!\1 = '/mnt/data/pg_ident.conf'!" $PG_DATA/postgresql/postgresql.conf.sample \

  ## destructor
  && apk del build-base wget gnupg ca-certificates \
             readline-dev openssl-dev zlib-dev libxml2-dev openldap-dev libxslt-dev \
  && rm -rf "$GNUPGHOME" $PG_HOME/postgresql* /usr/local/bin/gosu.asc /var/cache/apk/* \
  && mkdir $PGDATA && chown -R $PG_GROUP:$PG_USER $PG_DATA \
  && eval "gosu $PG_USER initdb -D $PGDATA" \
  && mv $PG_DATA/postgresql /etc/ \
  && mv $PG_DATA/* /tmp/

VOLUME $PG_DATA
EXPOSE 5432

ENTRYPOINT ["entry"]
CMD ["postgres"]
