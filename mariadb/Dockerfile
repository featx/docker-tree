#++++++++++++++++++++++++++++++++++++++#
# Mariadb Docker container in Alpine #
#+++++++++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV MARIA_VERSION=10.1.16 \
    MARIA_HOME=/usr/mysql \
    DATA_DIR=/mnt/data \
    CMAKE_ARGS="-DCMAKE_INSTALL_PREFIX=$db_install_prefix \
-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
-DMYSQL_DATADIR=/data/mariadb \
-DSYSCONFDIR=/etc \
-DMYSQL_USER=mysql \
-DMYSQL_TCP_PORT=3306 \
-DWITH_XTRADB_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_EXTRA_CHARSETS=1 \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DEXTRA_CHARSETS=all \
-DWITH_BIG_TABLES=1 \
-DWITH_DEBUG=0"

COPY *.* $MARIA_HOME/
RUN apk add --no-cache --virtal .build-dep ca-certificates wget gnupg cmake make gcc g++  \
#    && export MIRROR_ROOT = "https://mirrors.tuna.tsinghua.edu.cn/mariadb";
#    && wget -O mariadb.tar.gz $MIRROR_ROOT/mariadb-$MY_VERSION/source/mariadb-#MY_VERSION.tar.gz \
    && wget -O mariadb.tar.gz https://github.com/MariaDB/server/archive/mariadb-$MARIA_VERSION.tar.gz \
#   Verify GPG, SHA/MD5
    && tar -Jxf mariadb.tar.gz && cd mariadb-$MARIA_VERSION \
    && cmake . $CMAKE_ARGS && make && make install \
    && support-files/mysql.server \
    && scripts/mysql_install_db --user=mysql --basedir=$MARIA_HOME --datadir=$DATA_DIR
    
    && rm -rf /tmp/src/* /var/cache/apk/* /etc/mysql/my.cnf \
		&& mv $BASE_DIR/my.cnf /etc/mysql/ \
		&& mv $BASE_DIR/mysql.sh /usr/bin/ && chmod u+x /usr/bin/mysql.sh

VOLUME ["/mnt"]
EXPOSE 3306
CMD ["entry.sh"]
