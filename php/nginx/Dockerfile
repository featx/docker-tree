#++++++++++++++++++++++++++++++++++++++
# PHP Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM soglad/php:7.0.10-debug-alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV NGX_HOME=/usr/local \
    NGX_VERSION=1.11.3

COPY * $NGX_HOME/
# product variable/data would be put in /var   etc=/var/conf logs=/var/logs apps=/var/apps
RUN set -ex && mkdir -p $NGX_HOME/src \
    && apk add --no-cache -U pcre openssl \
       ca-certificates wget make gcc g++ linux-headers paxctl libgcc libstdc++ gnupg \
       pcre-dev openssl-dev tar \
    && cd $NGX_HOME/src \
    && wget -O nginx.tar.gz http://nginx.org/download/nginx-$NGX_VERSION.tar.gz \
    && tar -zxf nginx.tar.gz && mv nginx-$NGX_VERSION nginx \
    && cd nginx \
    && rm ./src/core/nginx.h \
    && mv $NGX_HOME/nginx.h ./src/core/ \
    && ./configure --prefix=$NGX_HOME/nginx \
                   --sbin-path=/usr/sbin/nginx \
                   --conf-path=/mnt/ngx/etc/nginx.conf \
                   --error-log-path=/mnt/ngx/log/error.log \
                   --http-log-path=/mnt/ngx/log/access.log \
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
    && cd $NGX_HOME \
    && mv $NGX_HOME/entry /usr/bin/ \
    && chmod u+x /usr/bin/entry \
    && mkdir -p /tmp/etc && mv /mnt/ngx/etc/* /tmp/etc/ \
    && apk del ca-certificates wget make gcc g++ linux-headers paxctl libgcc libstdc++ gnupg \
               pcre-dev openssl-dev tar \
    && rm -rf /var/cache/apk/* $NGX_HOME/Dockfile $NGX_HOME/src $NGX_HOME/nginx/html $NGX_HOME/nginx/logs

EXPOSE 80 443
VOLUME ["/mnt/ngx", "/mnt/app"]
ENTRYPOINT ["entry"]
CMD ["nginx"]
