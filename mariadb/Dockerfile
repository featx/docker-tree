#++++++++++++++++++++++++++++++++++++++#
# Mariadb Docker container in Alpine #
#+++++++++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV MYSQL_VERSION=10.1.16 \
    MYSQL_HOME=/usr/mysql \
    DATA_DIR=/mnt/data \
    CMAKE_ARGS="-DCMAKE_INSTALL_PREFIX=$MYSQL_HOME \
-DMYSQL_DATADIR=$DATA_DIR \
-DSYSCONFDIR=$DATA_DIR/etc \
-DMYSQL_UNIX_ADDR=$DATA_DIR/log/mysql.sock \
-DMYSQL_USER=mysql \
-DMYSQL_TCP_PORT=3306 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_XTRADB_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DWITH_SSL=system \
-DWITH_ZLIB=system
-DENABLED_LOCAL_INFILE=1 \
-DWITH_EXTRA_CHARSETS=1 \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_unicode_ci \
-DEXTRA_CHARSETS=all \
-DWITH_BIG_TABLES=1 \
-DWITH_DEBUG=0"

COPY *.* $MARIA_HOME/
RUN apk add --no-cache --virtal .build-dep ca-certificates wget gnupg cmake make gcc g++ linux-headers  \
    && apk add --no-cache --virtal .lib-dep zlib-dev openssl-dev readline-dev ncurses-dev \
    libxml2-dev bison jemalloc-dev \
    && export MIRROR_ROOT=https://mirrors.tuna.tsinghua.edu.cn/mariadb/ \
    && wget -O mariadb.tar.gz $MIRROR_ROOT/mariadb-$MYSQL_VERSION/source/mariadb-$MYSQL_VERSION.tar.gz \
#   && wget -O mariadb.tar.gz https://github.com/MariaDB/server/archive/mariadb-$MARIA_VERSION.tar.gz \

#   Verify GPG, SHA/MD5
    && echo "725739d36e24bfa1156f92b0c5a57fcc379f4e91 *mariadb.tar.gz" | sha1sum -c - \
    && tar -zxf mariadb.tar.gz && rm -f mariadb.tar.gz \
    && cd mariadb-$MARIA_VERSION \
    && cmake . $CMAKE_ARGS && make && make install \
    && support-files/mysql.server \
    && scripts/mysql_install_db --user=mysql --basedir=$MARIA_HOME --datadir=$DATA_DIR

#   destructor
    && apk del .build-dep .lib-dep
    && rm -rf /tmp/src/* /var/cache/apk/* /etc/mysql/my.cnf \
		&& mv $BASE_DIR/my.cnf $DATA_DIR/etc/ \
		&& mv $BASE_DIR/mysql.sh /usr/bin/ && chmod u+x /usr/bin/mysql.sh

VOLUME $DATA_DIR
EXPOSE 3306
CMD ["entry.sh"]
