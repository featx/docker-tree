#++++++++++++++++++++++++++++++++++++++
# Nginx Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>
#USER soglad

ENV NGINX_PREFIX=/usr/local \
    NGINX_VERSION=release-1.11.0

RUN set -ex \
    && apk add --no-cache pcre openssl \
#The compile dependences
    git pcre-dev openssl-dev make gcc g++ linux-headers paxctl libgcc libstdc++ gnupg \
    && mkdir -p $NGINX_PREFIX/src \
    && cd $NGINX_PREFIX/src \
    && git clone https://github.com/nginx/nginx.git \
    && cd $NGINX_PREFIX/src/nginx \
    && git checkout $NGINX_VERSION \
    && rm $NGINX_PREFIX/src/nginx/src/core/nginx.h

COPY conf/nginx.h $NGINX_PREFIX/src/nginx/src/core/

RUN cd $NGINX_PREFIX/src/nginx \
    && ./auto/configure --prefix=$NGINX_PREFIX/nginx \
                   --sbin-path=/usr/sbin/nginx \
                   --conf-path=$NGINX_PREFIX/etc/nginx.conf \
                   --error-log-path=$NGINX_PREFIX/log/error.log \
                   --http-log-path=$NGINX_PREFIX/log/access.log \
                   --with-pcre --with-http_ssl_module \
                   --with-http_realip_module --with-http_addition_module \
                   --with-http_sub_module --with-http_dav_module \
                   --with-http_flv_module --with-http_mp4_module \
                   --with-http_gunzip_module --with-ipv6 \
                   --with-http_gzip_static_module \
                   --with-http_random_index_module \
                   --with-http_secure_link_module \
                   --with-http_stub_status_module \
                   --with-mail --with-mail_ssl_module \
    && make && make install \
    && apk del git pcre-dev openssl-dev make gcc g++ linux-headers paxctl libgcc libstdc++ gnupg \
    && rm -rf $NGINX_PREFIX/src/* $NGINX_PREFIX/html NGINX_PREFIX/etc/nginx.conf /var/cache/apk/* \
    && mkdir -p $NGINX_PREFIX/etc/conf.d && mkdir -p $NGINX_PREFIX/app

COPY conf/etc/nginx/* $NGINX_PREFIX/etc/
EXPOSE 80 443
VOLUME ["/usr/local/etc/conf.d","/usr/local/app","/usr/local/log"]
ENTRYPOINT ["/usr/sbin/nginx"]
