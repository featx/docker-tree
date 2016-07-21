#++++++++++++++++++++++++++++++++++++++
# Postgres Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++
#++++++++++++++++++++++++++++++++++++++
# Still not work, Just record here.
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV LANG en_US.utf8
ENV GOSU_VERSION 1.7
ENV PG_MAJOR 9.5
ENV PG_VERSION 9.5.3-1.pgdg80+1
ENV PATH /usr/lib/postgresql/$PG_MAJOR/bin:$PATH
ENV PGDATA /var/lib/postgresql/data

COPY docker-prepare.sh /usr/bin/
# explicitly set user/group IDs
RUN groupadd -r postgres --gid=999 && useradd -r -g postgres --uid=999 postgres \
  && set -x \
  && chmod u+x /usr/bin/docker-prepare.sh \
  # grab gosu for easy step-down from root
	&& apk add -U ca-certificates wget \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& apt-get purge -y --auto-remove ca-certificates wget \
  # make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
  && apk add -U locales \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
  && mkdir /docker-entrypoint-initdb.d \
  && apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8 \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list \
  && apk add -U postgresql-common \
	&& sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf \
	&& apk add -U postgresql-$PG_MAJOR=$PG_VERSION postgresql-contrib-$PG_MAJOR=$PG_VERSION \
	&& rm -rf /var/cache/apk/* \
  # make the sample config easier to munge (and "correct by default")
  && mv -v /usr/share/postgresql/postgresql.conf.sample /usr/share/postgresql/ \
	&& ln -sv ../postgresql.conf.sample /usr/share/postgresql/$PG_MAJOR/ \
	&& sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/share/postgresql/postgresql.conf.sample \
  && mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

VOLUME /var/lib/postgresql/data
EXPOSE 5432

ENTRYPOINT ["docker-prepare.sh"]
CMD ["postgres"]
