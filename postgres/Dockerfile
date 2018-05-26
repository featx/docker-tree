#+++++++++++++++++++++++++++++++++++++#
# Postgres Docker container in Alpine #
#+++++++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Glad.so
MAINTAINER Excepts <excepts@glad.so>

ENV LANG=en_US.utf8 \
    PG_MAJOR=10.4 \
    PG_VERSION=10.4 \
    PG_HOME=/usr/local \
    PG_GROUP=postgres \
    PG_USER=postgres \
    PG_DATA=/mnt/postgres \

    PGDATA=/mnt/postgres/data \
    PGDATABASE=postgres \
    PGUSER=postgres \
    PGPASSWORD=postgres

COPY entry ${PG_HOME}/bin/
RUN set -ex \
  && chmod u+x /usr/local/bin/entry \
  && apk add --no-cache --virtual .build-deps \
    wget gnupg ca-certificates openssl build-base coreutils flex \
    libc-dev libedit-dev libxml2-dev libxslt-dev util-linux-dev zlib-dev \
    openldap-dev python-dev python3-dev perl-dev perl-utils perl-ipc-run \
  # perl-dev krb5-dev openssl-dev tcl-dev gettext-dev \

  && export PG_COMPILE_ARGS="--prefix=${PG_DATA} --exec-prefix=${PG_HOME} \
      --includedir=${PG_HOME}/include --disable-rpath \
      --enable-integer-datetimes --enable-thread-safety --enable-tap-tests \ 
      --with-uuid=e2fs -with-gnu-ld --with-pgport=5432 --with-openssl \
      --with-includes=/usr/local/include --with-libraries=/usr/local/lib \
      --with-system-tzdata=/usr/share/zoneinfo --with-libxml -with-libxslt \
      --with-python --with-ldap" \
# These make our image abnormally large (at least 100MB larger), 
#  which seems uncouth for an "Alpine" (ie, "small") variant :)
#   --with-krb5 --with-perl --enable-nls=zh_CN.UTF-8' \
#   --with-gssapi  --with-tcl \
#   --with-pam --enable-debug \

  # Wget source package and install postgresql
  && cd ${PG_HOME} \
  && wget https://ftp.postgresql.org/pub/source/v${PG_VERSION}/postgresql-${PG_VERSION}.tar.gz \
  && wget https://ftp.postgresql.org/pub/source/v${PG_VERSION}/postgresql-${PG_VERSION}.tar.gz.sha256 \
  && grep postgresql-${PG_VERSION}.tar.gz postgresql-${PG_VERSION}.tar.gz.sha256 | sha256sum -c - \
  && tar -zxf postgresql-${PG_VERSION}.tar.gz && mv postgresql-${PG_VERSION} postgresql \
  && cd postgresql \
  && awk '$1 == "#define" && $2 == "DEFAULT_PGSOCKET_DIR" && $3 == "\"/tmp\"" { $3 = "\"/var/run/postgresql\""; print; next } { print }' src/include/pg_config_manual.h > src/include/pg_config_manual.h.new \
  && grep '/var/run/postgresql' src/include/pg_config_manual.h.new \
  && mv src/include/pg_config_manual.h.new src/include/pg_config_manual.h \
  && ./configure ${PG_COMPILE_ARGS} \
  && make -j "$(nproc)" world \
  && make install-world \
  && make -C contrib install \
  && runDeps="$( scanelf --needed --nobanner --recursive /usr/local \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u \
      | xargs -r apk info --installed \
      | sort -u )" \
  && cd ${PG_HOME} \
  # make the sample config easier to munge (and "correct by default")
  && sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" ${PG_DATA}/share/postgresql.conf.sample \
  && mkdir -p /var/run/postgresql \
  && chown -R ${PG_GROUP}:${PG_USER} /var/run/postgresql \
  && chmod g+s /var/run/postgresql \
  
  ## destructor
  && apk del .build-deps \
  && apk add --no-cache --virtual .postgresql-rundeps ${runDeps} bash su-exec tzdata \
  && rm -rf "${GNUPGHOME}" /var/cache/apk/* \
    ${PG_HOME}/postgresql* ${PG_DATA}/share/doc ${PG_DATA}/share/man \
  && find /usr/local -name '*.a' -delete \
  && mv ${PG_DATA}/* /tmp/

WORKDIR ${PG_HOME}
VOLUME ${PG_DATA}
EXPOSE 5432
ENTRYPOINT ["entry"]
CMD ["postgres"]
