#++++++++++++++++++++++++++++++++++++++#
# Mariadb Docker container in Alpine #
#+++++++++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV MARIADB_VERSION=10.1 \
    MARIADB_HOME=/usr/local

RUN addgroup -S mysql && adduser -S -g mysql mysql \
    && set -x \
		&& apk add --no-cache openssl libevent zlib readline \
		   make gcc g++ git zip tar bison libtool ncurses-dev zlib-dev cmake jemalloc \
			 linux-headers paxctl libgcc libstdc++ gnupg autoconf automake \
    && cd $MARIADB_HOME && git clone https://github.com/MariaDB/server && cd server \
		&& ./BUILD/autorun.sh && ./configure --prefix=$MARIADB_HOME --enable-assembler \
    --with-extra-charsets=complex  --enable-thread-safe-client  --with-big-tables \
    --with-plugin-maria --with-aria-tmp-tables --without-plugin-innodb_plugin \
    --with-mysqld-ldflags=-static --with-client-ldflags=-static --with-readline \
    --with-ssl --with-plugins=max-no-ndb --with-embedded-server --with-libevent \
    --with-mysqld-ldflags=-all-static  --with-client-ldflags=-all-static \
    --with-zlib-dir=bundled --enable-local-infile && make && make install \
		&& apk del make gcc g++ git zip tar bison libtool ncurses-dev zlib-dev cmake jemalloc \
		linux-headers paxctl libgcc libstdc++ gnupg autoconf automake \
		&& rm -rf $MARIADB_HOME/server /var/cache/apk/* \
		&& chown -R mysql:mysql $MARIADB_HOME \
    && ./scripts/mysql_install_db --user=mysql

VOLUME ["/usr/local/etc", "/usr/local/data"]
EXPOSE 3306
CMD ["mysqld_safe", "--user=mysql"]
