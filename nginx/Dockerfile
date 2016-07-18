#++++++++++++++++++++++++++++++++++++++
# Nginx Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>
#USER soglad

ENV NGINX_PREFIX=/usr/local \
    NGINX_VERSION=release-1.11.2

RUN mkdir -p $NGINX_PREFIX/src && cd $NGINX_PREFIX/src \
    && apk add --no-cache pcre openssl \
       git pcre-dev openssl-dev make gcc g++ linux-headers paxctl libgcc libstdc++ gnupg \
    && git clone https://github.com/nginx/nginx.git \
    && cd $NGINX_PREFIX/src/nginx \
    && git checkout $NGINX_VERSION \
    && rm $NGINX_PREFIX/src/nginx/src/core/nginx.h
COPY nginx.* $NGINX_PREFIX/src/nginx/src/core/

RUN set -ex \
    && mv $NGINX_PREFIX/src/nginx/src/core/nginx.sh /usr/bin/ \
    && chmod u+x /usr/bin/nginx.sh \
    && cd $NGINX_PREFIX/src/nginx \
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
    && cd $NGINX_PREFIX \
    && apk del git pcre-dev openssl-dev make gcc g++ linux-headers paxctl libgcc libstdc++ gnupg \
    && rm -rf /var/cache/apk/* $NGINX_PREFIX/src $NGINX_PREFIX/etc/nginx.conf $NGINX_PREFIX/etc/*.default \
              $NGINX_PREFIX/nginx/html $NGINX_PREFIX/nginx/logs \
    && mkdir -p /tmp/etc \
    && mv $NGINX_PREFIX/etc/* /tmp/etc/

COPY conf/* /tmp/etc/
EXPOSE 80 443
VOLUME ["/usr/local/etc", "/usr/local/app", "/usr/local/log"]
ENTRYPOINT ["nginx.sh"]
