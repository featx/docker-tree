#++++++++++++++++++++++++++++++++++++++
# PHP Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV PHP_HOME=/usr/local \
    PHP_VERSION=5.6.22 \
    COMPOSER_VERSION=1.1.2 \
    PHP_INI_DIR=/etc/php/ \
    PHP_COMPILE_ARGS="--enable-fpm --with-fpm-user=root --with-fpm-group=root \
                      --with-mysql --with-mysqli --with-pdo-mysql --with-iconv \
                      --with-openssl --with-gd --with-libedit  --with-zlib --with-curl \
                      --with-freetype-dir=/usr/local --with-jpeg-dir=/usr/local \
                      --with-png-dir=/usr/local --with-libxml-dir=/usr/local \
                      --with-vpx-dir=/usr/local --with-xpm-dir=/usr/local \
                      --with-mcrypt --with-mhash --enable-xml --enable-bcmath \
                      --enable-mbstring --enable-mbregex --enable-gd-native-ttf \
                      --enable-sockets --enable-zip --enable-soap --enable-pdo --enable-debug"

RUN set -x \
#	  && addgroup -g 82 -S www-data \
#	  && adduser -u 82 -D -S -G www-data www-data \
    && apk add --no-cache --virtual .persistent-deps curl ca-certificates \
    && apk add --no-cache --virtual .build-deps autoconf libmcrypt-dev \
    		   file g++ gcc libc-dev make pkgconf re2c curl-dev jpeg-dev libxpm-dev freetype-dev \
    		   gnupg libedit-dev libxml2-dev openssl-dev sqlite-dev libpng-dev libvpx-dev \
    && mkdir -p $PHP_INI_DIR/conf.d \
    && curl -fSL http://php.net/get/php-${PHP_VERSION}.tar.xz/from/this/mirror -o php-${PHP_VERSION}.tar.xz \
    && curl -fSL http://php.net/get/php-${PHP_VERSION}.tar.xz.asc/from/this/mirror -o php-${PHP_VERSION}.tar.xz.asc \
    && curl -fkSL https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -o composer \
    && chmod u+x composer && mv composer /usr/local/bin \
    && echo "c96980d7de1d66c821a4ee5809df0076f925b2fe0b8c362d234d92f2f0a178e2 *php-${PHP_VERSION}.tar.xz" | sha256sum -c - \
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
    && rm -r $GNUPGHOME php-${PHP_VERSION}.tar.xz php-${PHP_VERSION}.tar.xz.asc \
    && cd /usr/src/php \
    && ./configure --prefix=/usr/local \
		--with-config-file-path=$PHP_INI_DIR \
		--with-config-file-scan-dir=$PHP_INI_DIR/conf.d \
		$PHP_COMPILE_ARGS --enable-mysqlnd \
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
	  && apk del .build-deps autoconf file gnupg g++ gcc make pkgconf re2c \
    		   libmcrypt-dev libc-dev curl-dev jpeg-dev libxpm-dev freetype-dev \
           libedit-dev libxml2-dev openssl-dev sqlite-dev libpng-dev libvpx-dev \
    && rm -rf /var/cache/apk/*

COPY docker-php-ext-* /usr/local/bin/

WORKDIR /var/www/html

RUN set -ex \
	&& cd /usr/local/etc \
	&& if [ -d php-fpm.d ]; then \
		# for some reason, upstream's php-fpm.conf.default has "include=NONE/etc/php-fpm.d/*.conf"
		sed 's!=NONE/!=!g' php-fpm.conf.default | tee php-fpm.conf > /dev/null; \
		cp php-fpm.d/www.conf.default php-fpm.d/www.conf; \
	else \
		# PHP 5.x don't use "include=" by default, so we'll create our own simple config that mimics PHP 7+ for consistency
		mkdir php-fpm.d; \
		cp php-fpm.conf.default php-fpm.d/www.conf; \
		{ \
			echo '[global]'; \
			echo 'include=etc/php-fpm.d/*.conf'; \
		} | tee php-fpm.conf; \
	fi \
	&& { \
		echo '[global]'; \
		echo 'error_log = /proc/self/fd/2'; \
		echo; \
		echo '[www]'; \
		echo '; if we send this to /proc/self/fd/1, it never appears'; \
		echo 'access.log = /proc/self/fd/2'; \
		echo; \
		echo 'clear_env = no'; \
		echo; \
		echo '; Ensure worker stdout and stderr are sent to the main error log.'; \
		echo 'catch_workers_output = yes'; \
	} | tee php-fpm.d/docker.conf \
	&& { \
		echo '[global]'; \
		echo 'daemonize = no'; \
		echo; \
		echo '[www]'; \
		echo 'listen = [::]:9000'; \
	} | tee php-fpm.d/zz-docker.conf

VOLUME ["/usr/local/php"]
EXPOSE 9000
CMD ["php-fpm"]
