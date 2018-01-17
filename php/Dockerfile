#++++++++++++++++++++++++++++++++#
# PHP Docker container in Alpine #
#++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Glad.so
MAINTAINER Excepts <excepts@glad.so>

# Required info below:
# http://php.net/downloads.php

ENV PHP_HOME=/usr/local \
    PHP_DATA=/mnt/php \
    PHP_APPS=/mnt/lib \
    PHP_VERSION=7.2.1 \
#   5.6.31 7.0.24 7.1.12 7.2.0 
    PHP_EXT=no-debug-non-zts-20170718 \
    #debug-non-zts-20160303 (7.1)\
    #debug-non-zts-20151012 (7.0)\
    #debug-non-zts-20131226 (5.6)\
    PHP_USER=www \
    PHP_GROUP=www \
    COMPOSER_VERSION=1.6.2 \
    XDEBUG_VERSION=2.5.5 \
    PHPUNIT_VERSION=6.5.5 \
# 5.7.21, 6.2.3
    COMPOSER_MIRROR=https://packagist.phpcomposer.com \
   
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
RUN set -x \
    && apk add --no-cache --virtual .build-deps \
        wget ca-certificates gnupg autoconf automake re2c file \
        build-base curl-dev libressl-dev libssh2-dev libmcrypt-dev gettext-dev \
        libedit-dev libxml2-dev gmp-dev jpeg-dev libxpm-dev libpng-dev libvpx-dev \
        freetype-dev postgresql-dev libmemcached-dev \
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
#    && mv composer phpunit $PHP_HOME/bin/ && chmod u+x $PHP_HOME/bin/* \
    && mv composer $PHP_HOME/bin/ && chmod u+x $PHP_HOME/bin/* \
    && echo "6c6cf82fda6660ed963821eb0525214bb3547e8e29f447b9c15b2d8e6efd8822 *php-$PHP_VERSION.tar.xz" | sha256sum -c - \
	&& export GNUPGHOME=$(mktemp -d) \
    && for key in 1729F83938DA44E27BA0F4D3DBDB397470D12172 B1B44D8F021E4E2D6021E995DC9FF8D3EE5AF27F; do \
#7.1    && for key in A917B1ECDA84AEC2B568FED6F50ABC807BD5DCD0 528995BFEDFBA7191D46839EF9BA0ADA31CBD89E; do \
#7.0    && for key in 1A4E8B7277C42E53DBA9C7B9BCAA30EA9C0D5763 6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3; do \
#5.6    && for key in 6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3 0BD78B5F97500D450838F95DFE857D9A90D90EC1; do \
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
    && mv php.ini-development $PHP_DATA/etc/php.ini \
    
# Compile and install xdebug
#    && cd $PHP_HOME/src \
#    && tar -zxf xdebug.tgz && cd xdebug-$XDEBUG_VERSION \
#    && $PHP_HOME/bin/phpize \
#    && ./configure --with-php-config=$PHP_HOME/bin/php-config \
#    && make && make install \

    && cd $PHP_HOME \
    && mkdir -p /tmp/etc /tmp/lib \
    && mv $PHP_HOME/etc/* /tmp/etc/ && mv $PHP_HOME/lib/php/extensions/$PHP_EXT/* /tmp/lib/ \
    && rm -rf $PHP_HOME/etc $PHP_HOME/lib/php/extensions/$PHP_EXT \
    
    && composer config -g repo.packagist composer $COMPOSER_MIRROR \
    
    # distructor
    && apk del .build-deps \
    && apk add --no-cache --virtual .php-rundeps $runDeps \
    && rm -rf $GNUPGHOME /var/cache/apk/* $PHP_HOME/src \

    && echo -e '#!/bin/sh\n\
\n\
set -e\n\
\n\
for path in etc lib\n\
do\n\
    if [ ! -d $PHP_DATA/$path ]; then\n\
        mkdir -p $PHP_DATA/$path\n\
        cp -r /tmp/$path/* $PHP_DATA/$path/\n\
    fi\n\
done\n\
\n\
if [ ! -f $PHP_DATA/etc/php-fpm.conf ]; then\n\
    cp $PHP_DATA/etc/php-fpm.conf.default $PHP_DATA/etc/php-fpm.conf\n\
fi\n\
\n\
chown -R $PHP_GROUP:$PHP_USER $PHP_DATA\n\
\n\
rm -rf $PHP_HOME/etc $PHP_HOME/lib/php/extensions/$PHP_EXT\n\
ln -s $PHP_DATA/etc $PHP_HOME/etc\n\
ln -s $PHP_DATA/lib $PHP_HOME/lib/php/extensions/$PHP_EXT\n\
\n\
exec "$@"' >> /usr/local/bin/entry \
    && chmod u+x /usr/local/bin/entry

EXPOSE 9000
VOLUME ["/mnt/php"]
WORKDIR $PHP_HOME
ENTRYPOINT ["entry"]
CMD ["php-fpm", "-y", "/mnt/php/etc/php-fpm.conf", "-R"]
