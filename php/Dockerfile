#++++++++++++++++++++++++++++++++++++++
# PHP Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV PHP_HOME=/usr/local \
    PHP_VERSION=5.6.24 \
    COMPOSER_VERSION=1.2.0 \
    XDEBUG_VERSION=2.4.1 \
    PHPUNIT_VERSION=5.5.0 \
    PHP_CONF=/mnt/etc \
    PHP_COMPILE_ARGS="--enable-fpm --with-fpm-user=root --with-fpm-group=root \
--with-mysql --with-mysqli --with-pdo-mysql --with-iconv --with-gmp \
--with-openssl --with-gd --with-libedit  --with-zlib --with-curl \
--with-mcrypt --with-mhash --enable-xml --enable-bcmath \
--enable-mbstring --enable-mbregex --enable-gd-native-ttf --enable-mysqlnd \
--enable-sockets --enable-zip --enable-soap --enable-pdo --enable-debug \
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

    && mkdir -p $PHP_HOME/src $PHP_CONF \
    && cd $PHP_HOME/src \
    #Download and Verify
    && wget -O php-${PHP_VERSION}.tar.xz http://php.net/get/php-${PHP_VERSION}.tar.xz/from/this/mirror \
    && wget -O php-${PHP_VERSION}.tar.xz.asc http://php.net/get/php-${PHP_VERSION}.tar.xz.asc/from/this/mirror \
    && wget -O composer https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar \
    && wget -O phpunit https://phar.phpunit.de/phpunit-$PHPUNIT_VERSION.phar \
    && wget -O xdebug.tgz https://xdebug.org/files/xdebug-$XDEBUG_VERSION.tgz \
    && mv composer phpunit $PHP_HOME/bin && chmod u+x $PHP_HOME/bin/* \
    && echo "ed7c38c6dac539ade62e08118258f4dac0c49beca04d8603bee4e0ea6ca8250b *php-${PHP_VERSION}.tar.xz" | sha256sum -c - \
	  && export GNUPGHOME=$(mktemp -d) \
	  && for key in \
      0BD78B5F97500D450838F95DFE857D9A90D90EC1 \
      6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3 \
      ; do \
          gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	     done \
    && gpg --batch --verify php-${PHP_VERSION}.tar.xz.asc php-${PHP_VERSION}.tar.xz \
    # Unpackage
    && tar -Jxf php-${PHP_VERSION}.tar.xz && mv php-$PHP_VERSION php \
    # Compile and install
    && cd php \
    && ./configure --prefix=$PHP_HOME \
		--with-config-file-path=$PHP_CONF \
		--with-config-file-scan-dir=$PHP_CONF/conf.d \
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
    && mv php.ini-development $PHP_CONF/php.ini \
    && cd $PHP_HOME/src \
    && tar -zxf xdebug.tgz && cd xdebug-$XDEBUG_VERSION \
    && $PHP_HOME/bin/phpize \
    && ./configure --with-php-config=$PHP_HOME/bin/php-config \
    && make && make install \
    && cd $PHP_HOME \
    && mkdir -p /tmp/etc /tmp/lib \
    && mv $PHP_HOME/etc/* /tmp/etc/ && mv $PHP_HOME/lib/php/extensions/debug-non-zts-20131226/* /tmp/lib/ \
    && rm -rf $PHP_HOME/etc $PHP_HOME/lib/php/extensions/debug-non-zts-20131226 \
    # distructor
    && apk del wget ca-certificates gnupg \
                autoconf g++ gcc make re2c file \
                libc-dev curl-dev libmcrypt-dev jpeg-dev libxpm-dev gmp-dev \
                libedit-dev libxml2-dev openssl-dev libpng-dev libvpx-dev freetype-dev \
    && rm -rf $GNUPGHOME /var/cache/apk/* $PHP_HOME/src/* \
    && chmod u+x /usr/local/bin/entry

EXPOSE 9000 9001
VOLUME ["/mnt", "/usr/src"]
ENTRYPOINT ["entry"]
CMD ["php-fpm", "-R"]
