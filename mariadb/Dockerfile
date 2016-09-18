#++++++++++++++++++++++++++++++++++++++++++++#
#      Mariadb Docker container in Alpine    #
#++++++++++++++++++++++++++++++++++++++++++++#

FROM opensuse:42.1
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV MYSQL_VERSION=10.1.17 \
    MYSQL_HOME=/usr/mysql \
    DATA_DIR=/mnt/data \
    MYSQL_USER=mysql \
    MYSQL_GROUP=mysql \
    CMAKE_ARGS="-DCMAKE_INSTALL_PREFIX=$MYSQL_HOME \
-DMYSQL_DATADIR=$DATA_DIR \
-DSYSCONFDIR=$DATA_DIR \
-DMYSQL_UNIX_ADDR=$DATA_DIR/mysql.sock \
-DMYSQL_USER=$MYSQL_USER \
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
-DWITH_ZLIB=system \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_EXTRA_CHARSETS=1 \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_unicode_ci \
-DEXTRA_CHARSETS=all \
-DWITH_BIG_TABLES=1 \
-DWITH_DEBUG=0"

COPY entry $MYSQL_HOME/
RUN groupadd -g 101 -S $MYSQL_GROUP && adduser -u 100 -D -S -G $MYSQL_GROUP $MYSQL_USER \
    && zypper in -y ca-certificates wget gnupg linux-headers cmake make gcc g++ \
         zlib-dev openssl-dev readline-dev ncurses-dev libxml2-dev jemalloc-dev \
         bison jemalloc \
    && export MIRROR_ROOT=https://mirrors.tuna.tsinghua.edu.cn/mariadb/ \
    && wget -O mariadb.tar.gz $MIRROR_ROOT/mariadb-$MYSQL_VERSION/source/mariadb-$MYSQL_VERSION.tar.gz \
#   && wget -O mariadb.tar.gz https://github.com/MariaDB/server/archive/mariadb-$MARIA_VERSION.tar.gz \

#   Verify GPG, SHA/MD5
    && echo "65d3bd1c253c3b1440dc9a628986257ffb92586f *mariadb.tar.gz" | sha1sum -c - \
    && tar -zxf mariadb.tar.gz && rm -f mariadb.tar.gz \
    && cd mariadb-$MARIA_VERSION \
    && cmake . $CMAKE_ARGS && make && make install \
    && support-files/mysql.server \
    && scripts/mysql_install_db --user=$MYSQL_USER --basedir=$MYSQL_HOME --datadir=$DATA_DIR

#   destructor
    && zypper rm -y ca-certificates wget gnupg cmake make gcc g++ \
    && zypper rm -y zlib-dev openssl-dev readline-dev ncurses-dev libxml2-dev jemalloc-dev \
    && rm -rf /tmp/src/* /var/cache/apk/* /etc/mysql/my.cnf \
    && mv $BASE_DIR/entry /usr/bin/ && chmod u+x /usr/bin/entry \
		&& mv $BASE_DIR/my.cnf $DATA_DIR/etc/

VOLUME $DATA_DIR
EXPOSE 3306
CMD ["entry"]
