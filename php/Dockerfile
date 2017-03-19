#++++++++++++++++++++++++++++++++++++++
# PHP Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

# Required info below:
# http://php.net/downloads.php

ENV PHP_HOME=/usr/local \
    PHP_DATA=/mnt/php \
    PHP_APPS=/mnt/app \
    PHP_VERSION=7.1.1 \
#   5.6.30 7.0.16 7.1.1 
    PHP_EXT=no-debug-non-zts-20160303 \
    #debug-non-zts-20160303 (7.1)\
    #debug-non-zts-20151012 (7.0)\
    #debug-non-zts-20131226 (5.6)\
    PHP_USER=www \
    PHP_GROUP=www \
    COMPOSER_VERSION=1.3.2 \
    XDEBUG_VERSION=2.5.0 \
    PHPUNIT_VERSION=6.0.8 \
    COMPOSER_MIRROR=https://packagist.phpcomposer.com \
    #5.7.X, 6.1.0
    PHP_COMPILE_ARGS="--enable-fpm --with-fpm-group=$PHP_GROUP --with-fpm-user=$PHP_USER \
    --enable-xml --enable-zip --enable-soap --enable-pdo \
    --enable-bcmath --enable-mbstring --enable-mbregex \
    --enable-mysqlnd --enable-sockets --enable-gd-native-ttf \
    --with-mysql --with-mysqli --with-pdo-mysql --with-pgsql --with-pdo-pgsql \
    --with-iconv --with-gmp --with-openssl --with-gd --with-libedit  --with-zlib \
    --with-curl --with-mcrypt --with-mhash --with-gettext \
    --with-freetype-dir=/usr/local --with-jpeg-dir=/usr/local \
    --with-png-dir=/usr/local --with-libxml-dir=/usr/local \
    --with-vpx-dir=/usr/local --with-xpm-dir=/usr/local"
# --enable-debug
COPY entry $PHP_HOME/bin/

RUN set -x \
    && apk add --no-cache -U libmemcached \
    wget ca-certificates gnupg autoconf g++ gcc make re2c file \
    libc-dev curl-dev libmcrypt-dev jpeg-dev libxpm-dev gmp-dev postgresql-dev gettext-dev \
    libedit-dev libxml2-dev libressl-dev libssh2-dev libpng-dev libvpx-dev freetype-dev \
    #
    && addgroup -g 82 -S $PHP_GROUP && adduser -u 82 -D -S -G $PHP_GROUP $PHP_USER \
    && mkdir -p $PHP_HOME/src $PHP_DATA/etc \
    && cd $PHP_HOME/src \
    #Download and Verify
    && wget -O php-$PHP_VERSION.tar.xz http://php.net/get/php-$PHP_VERSION.tar.xz/from/this/mirror \
    && wget -O php-$PHP_VERSION.tar.xz.asc http://php.net/get/php-$PHP_VERSION.tar.xz.asc/from/this/mirror \
    && wget -O composer https://getcomposer.org/download/$COMPOSER_VERSION/composer.phar \
#    && wget -O phpunit https://phar.phpunit.de/phpunit-$PHPUNIT_VERSION.phar \
#    && wget -O xdebug.tgz https://xdebug.org/files/xdebug-$XDEBUG_VERSION.tgz \
#    && mv composer phpunit $PHP_HOME/bin && chmod u+x $PHP_HOME/bin/* \
    && mv composer $PHP_HOME/bin/ && chmod u+x $PHP_HOME/bin/* \
    && echo "b3565b0c1441064eba204821608df1ec7367abff881286898d900c2c2a5ffe70 *php-$PHP_VERSION.tar.xz" | sha256sum -c - \
	  && export GNUPGHOME=$(mktemp -d) \
    && for key in A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0 528995BFEDFBA7191D46839EF9BA0ADA31CBD89E; do \
		       gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	     done \
	  && gpg --batch --verify php-$PHP_VERSION.tar.xz.asc php-$PHP_VERSION.tar.xz \

    # Unpackage
    && tar -Jxf php-$PHP_VERSION.tar.xz && mv php-$PHP_VERSION php \
    # Compile and install
    && cd php \
    && ./configure --prefix=$PHP_HOME \
		--with-config-file-path=$PHP_DATA/etc \
		--with-config-file-scan-dir=$PHP_DATA/etc/conf.d \
		$PHP_COMPILE_ARGS \
    && make -j"$(getconf _NPROCESSORS_ONLN)" \
	  && make install \
    && { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
	  && make clean \
	  && runDeps="$( scanelf --needed --nobanner --recursive /usr/local \
			  | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			  | sort -u \
			  | xargs -r apk info --installed \
			  | sort -u )" \
	  && apk add --no-cache --virtual .php-rundeps $runDeps \
    && mv php.ini-development $PHP_DATA/etc/php.ini \
    && composer config -g repo.packagist composer $COMPOSER_MIRROR \
  #  && cd $PHP_HOME/src \
  #  && tar -zxf xdebug.tgz && cd xdebug-$XDEBUG_VERSION \
  #  && $PHP_HOME/bin/phpize \
  #  && ./configure --with-php-config=$PHP_HOME/bin/php-config \
  #  && make && make install \
    && cd $PHP_HOME \
    && mkdir -p /tmp/etc /tmp/lib \
    && mv $PHP_HOME/etc/* /tmp/etc/ && mv $PHP_HOME/lib/php/extensions/$PHP_EXT/* /tmp/lib/ \
    && rm -rf $PHP_HOME/etc $PHP_HOME/lib/php/extensions/$PHP_EXT \
    # distructor
    && apk del wget gnupg autoconf g++ gcc make re2c file \
                libc-dev curl-dev openssl-dev libmcrypt-dev libxml2-dev gmp-dev postgresql-dev \
                gettext-dev libedit-dev jpeg-dev libxpm-dev libpng-dev libvpx-dev freetype-dev \
    && rm -rf $GNUPGHOME /var/cache/apk/* $PHP_HOME/src/* \
    && chmod u+x /usr/local/bin/entry

EXPOSE 9000 
#9001
VOLUME ["/mnt/php"]
WORKDIR /mnt/php
ENTRYPOINT ["entry"]
CMD ["php-fpm", "-y", "/mnt/php/etc/php-fpm.conf", "-R"]
