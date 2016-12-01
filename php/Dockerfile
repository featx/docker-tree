#++++++++++++++++++++++++++++++++++++++
# PHP Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV PHP_HOME=/usr/local \
    PHP_DATA=/mnt/php \
    PHP_APPS=/mnt/app \
    PHP_VERSION=7.0.13 \
    #5.6.28
    PHP_EXT=no-debug-non-zts-20151012 \
    #debug-non-zts-20131226 \
    PHP_USER=www \
    PHP_GROUP=www \
    COMPOSER_VERSION=1.2.2 \
#    XDEBUG_VERSION=2.4.1 \
#    PHPUNIT_VERSION=5.6.7 \--enable-debug
    PHP_COMPILE_ARGS="--enable-fpm --with-fpm-group=$PHP_GROUP --with-fpm-user=$PHP_USER \
--with-mysql --with-mysqli --with-pdo-mysql --with-iconv --with-gmp \
--with-openssl --with-gd --with-libedit  --with-zlib --with-curl \
--with-mcrypt --with-mhash --enable-xml --enable-bcmath \
--enable-mbstring --enable-mbregex --enable-gd-native-ttf --enable-mysqlnd \
--enable-sockets --enable-zip --enable-soap --enable-pdo \
--with-freetype-dir=/usr/local --with-jpeg-dir=/usr/local \
--with-png-dir=/usr/local --with-libxml-dir=/usr/local \
--with-vpx-dir=/usr/local --with-xpm-dir=/usr/local"

COPY entry $PHP_HOME/bin/

RUN set -x \
    && apk add --no-cache -U libmemcached \
                             wget ca-certificates gnupg \
                             autoconf g++ gcc make re2c file \
    libc-dev curl-dev libmcrypt-dev jpeg-dev libxpm-dev gmp-dev \
    libedit-dev libxml2-dev openssl-dev libpng-dev libvpx-dev freetype-dev \
    && addgroup -g 82 -S $PHP_GROUP \
    && adduser -u 82 -D -S -G $PHP_GROUP $PHP_USER \
    && mkdir -p $PHP_HOME/src $PHP_DATA/etc \
    && cd $PHP_HOME/src \
    #Download and Verify
    && wget -O php-$PHP_VERSION.tar.xz http://php.net/get/php-$PHP_VERSION.tar.xz/from/this/mirror \
    && wget -O php-$PHP_VERSION.tar.xz.asc http://php.net/get/php-$PHP_VERSION.tar.xz.asc/from/this/mirror \
    && wget -O composer https://getcomposer.org/download/$COMPOSER_VERSION/composer.phar \
#    && wget -O phpunit https://phar.phpunit.de/phpunit-$PHPUNIT_VERSION.phar \
#    && wget -O xdebug.tgz https://xdebug.org/files/xdebug-$XDEBUG_VERSION.tgz \
#    && mv composer phpunit $PHP_HOME/bin && chmod u+x $PHP_HOME/bin/* \
    && mv composer $PHP_HOME/bin && chmod u+x $PHP_HOME/bin/* \
    && echo "357ba7f93975d7d836abed0852dc3ed96a988af539e87750613294cbee82f1bf *php-$PHP_VERSION.tar.xz" | sha256sum -c - \
	  && export GNUPGHOME=$(mktemp -d) \
    && for key in 1A4E8B7277C42E53DBA9C7B9BCAA30EA9C0D5763 6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3; do \
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
                libc-dev curl-dev libmcrypt-dev jpeg-dev libxpm-dev gmp-dev \
                libedit-dev libxml2-dev openssl-dev libpng-dev libvpx-dev freetype-dev \
    && rm -rf $GNUPGHOME /var/cache/apk/* $PHP_HOME/src/* \
    && chmod u+x /usr/local/bin/entry

EXPOSE 9000
#9001
VOLUME ["/mnt/php", "/mnt/app"]
ENTRYPOINT ["entry"]
CMD ["php-fpm", "-y", "/mnt/php/etc/php-fpm.conf", "-R"]
