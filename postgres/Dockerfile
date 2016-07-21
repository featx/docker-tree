#++++++++++++++++++++++++++++++++++++++
# Postgres Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++
#++++++++++++++++++++++++++++++++++++++
# Still not work, Just record here.
#++++++++++++++++++++++++++++++++++++++
FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV LANG=en_US.utf8 \
    GOSU_VERSION=1.7 \
    PG_VERSION=9.5.3 \
    PG_HOME=/usr/local \
    PG_DATA=/var/data
# Hidden ENV PG_CONF=/var/conf PG_DATA=/var/data PG_LOGS=/var/logs

COPY docker-prepare.sh /usr/bin/
# explicitly set user/group IDs
RUN groupadd -r postgres --gid=999 && useradd -r -g postgres --uid=999 postgres \
  && set -x \
  && chmod u+x /usr/bin/docker-prepare.sh \
  # grab gosu for easy step-down from root
	&& apk add -U ca-certificates wget gnupg locales readline-dev zlib-dev \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
  # make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
  ## wget source package and install postgresql
  && cd $PG_HOME \
  && wget -O postgresql.tar.gz https://ftp.postgresql.org/pub/source/v$PG_VERSION/postgresql-$PG_VERSION.tar.gz \
  && tar -zxf postgresql.tar.gz && rm -f postgresql.tar.gz && mv postgresql-$PG_VERSION postgresql
  && cd postgresql \
  && ./configure --prefix=$PG_HOME --sysconfdir=/var/conf && make && make install &&
  && cd $PG_HOME \
  # make the sample config easier to munge (and "correct by default")
  && mkdir -p /tmp/conf /var/run && chown -R postgres /var/run \
  && sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /tmp/conf/createcluster.conf \
  && sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /tmp/conf/postgresql.conf.sample \
  ## destructor
  && apk del ca-certificates wget gnupg locales readline-dev zlib-dev \
  && rm -rf "$GNUPGHOME" $PG_HOME/postgresql /usr/local/bin/gosu.asc /var/cache/apk/*

VOLUME /var
EXPOSE 5432

ENTRYPOINT ["docker-prepare.sh"]
CMD ["postgres"]
