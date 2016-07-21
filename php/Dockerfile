#++++++++++++++++++++++++++++++++++++++
# PHP Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV PHP_HOME=/usr/local \
    PHP_VERSION=5.6.23 \
    COMPOSER_VERSION=1.1.3 \
    XDEBUG_VERSION=2.4.0 \
    PHP_INI_DIR=/usr/local/etc \
    PHP_COMPILE_ARGS="--enable-fpm --with-fpm-user=root --with-fpm-group=root \
--with-mysql --with-mysqli --with-pdo-mysql --with-iconv --with-gmp \
--with-openssl --with-gd --with-libedit  --with-zlib --with-curl \
--with-mcrypt --with-mhash --enable-xml --enable-bcmath \
--enable-mbstring --enable-mbregex --enable-gd-native-ttf --enable-mysqlnd \
--enable-sockets --enable-zip --enable-soap --enable-pdo --enable-debug \
--with-freetype-dir=/usr/local --with-jpeg-dir=/usr/local \
--with-png-dir=/usr/local --with-libxml-dir=/usr/local \
--with-vpx-dir=/usr/local --with-xpm-dir=/usr/local"

COPY docker-php-* $PHP_HOME/bin/

RUN set -x \
#       Download and Verify
    && apk add --no-cache --virtual .persistent-deps curl ca-certificates libmemcached \
    && apk add --no-cache --virtual .build-deps autoconf g++ gcc make re2c file \
           gnupg libc-dev curl-dev libmcrypt-dev jpeg-dev libxpm-dev gmp-dev \
    		   libedit-dev libxml2-dev openssl-dev libpng-dev libvpx-dev freetype-dev \
    && mkdir -p $PHP_INI_DIR/conf.d \
    && curl -fSL http://php.net/get/php-${PHP_VERSION}.tar.xz/from/this/mirror -o php-${PHP_VERSION}.tar.xz \
    && curl -fSL http://php.net/get/php-${PHP_VERSION}.tar.xz.asc/from/this/mirror -o php-${PHP_VERSION}.tar.xz.asc \
    && curl -fkSL https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -o composer \
    && curl -fkSL https://xdebug.org/files/xdebug-$XDEBUG_VERSION.tgz -o xdebug.tgz && tar -zxf xdebug.tgz \
    && mv composer $PHP_HOME/bin && chmod u+x $PHP_HOME/bin/* \
    && echo "39141e9a617af172aedbbacee7a63eb15502850f7cea20d759a9cffa7cfb0a1a *php-${PHP_VERSION}.tar.xz" | sha256sum -c - \
	  && export GNUPGHOME=$(mktemp -d) \
	  && for key in \
      0BD78B5F97500D450838F95DFE857D9A90D90EC1 \
      6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3 \
      ; do \
          gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	     done \
    && gpg --batch --verify php-${PHP_VERSION}.tar.xz.asc php-${PHP_VERSION}.tar.xz \
    && mkdir -p /usr/src \
    && tar -Jxf php-${PHP_VERSION}.tar.xz -C /usr/src \
    && mv /usr/src/php-$PHP_VERSION /usr/src/php \
    && rm -r $GNUPGHOME php-${PHP_VERSION}.tar.xz php-${PHP_VERSION}.tar.xz.asc xdebug.tgz \

#       Compile and install
    && cd /usr/src/php \
    && ./configure --prefix=$PHP_HOME \
		--with-config-file-path=$PHP_INI_DIR \
		--with-config-file-scan-dir=$PHP_INI_DIR/conf.d \
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
    && mv /usr/src/php/php.ini-development $PHP_INI_DIR/php.ini \
    && mv /xdebug-$XDEBUG_VERSION /usr/src/php/ext/ && cd /usr/src/php/ext/xdebug-$XDEBUG_VERSION \
    && /usr/local/bin/phpize && ./configure --with-php-config=/usr/local/bin/php-config \
    && make && make install \
    && apk del .build-deps autoconf g++ gcc make re2c file \
           gnupg libc-dev curl-dev libmcrypt-dev jpeg-dev libxpm-dev gmp-dev \
    		   libedit-dev libxml2-dev openssl-dev libpng-dev libvpx-dev freetype-dev\
    && rm -rf /var/cache/apk/* /usr/src/php/* \
    && mkdir -p /tmp/etc /tmp/extensions \
    && mv $PHP_HOME/etc/* /tmp/etc/ \
    && mv $PHP_HOME/lib/php/extensions/debug-non-zts-20131226/* /tmp/extensions/

WORKDIR /usr/local/app
VOLUME ["/usr/local/app", "/usr/local/etc", "/usr/local/lib/php/extensions/debug-non-zts-20131226"]
EXPOSE 9000 9001
ENTRYPOINT ["docker-php-fpm"]
CMD ["php-fpm", "-R"]
