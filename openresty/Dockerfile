#++++++++++++++++++++++++++++++++++++++#
# Openresty Docker container in Alpine #
#++++++++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Glad.so
MAINTAINER Palmtale <palmtale@glad.so>

ARG RESTY_HOME=/usr/local
ARG NGX_VERSION=1.11.2
ARG RESTY_SUFVER=.5

RUN set -ex && mkdir -p $RESTY_HOME/src \
    && apk add --no-cache --virtual .build-deps \
               build-base wget tar gnupg git ca-certificates \
               pcre-dev openssl-dev libstdc++ paxctl \
               linux-headers perl \
    && apk add --no-cache --virtual .run-deps \
                libgcc pcre openssl \

    && cd $RESTY_HOME/src \
    && wget https://openresty.org/download/openresty-$NGX_VERSION$RESTY_SUFVER.tar.gz \
    && wget https://openresty.org/download/openresty-$NGX_VERSION$RESTY_SUFVER.tar.gz.asc \ 
    && gpg --keyserver pgpkeys.mit.edu --recv-key A0E98066 \
    && gpg --verify openresty-$NGX_VERSION$RESTY_SUFVER.tar.gz.asc openresty-$NGX_VERSION$RESTY_SUFVER.tar.gz \
    && tar -zxf openresty-$NGX_VERSION$RESTY_SUFVER.tar.gz \
    && mv openresty-$NGX_VERSION$RESTY_SUFVER openresty \
    && cd openresty \

    && sed -i '12s/1011002/1100000/' bundle/nginx-$NGX_VERSION/src/core/nginx.h \
    && sed -i '13s/1.11.2/Motor/' bundle/nginx-$NGX_VERSION/src/core/nginx.h \
    && sed -i '14s/openresty/SoGlad/' bundle/nginx-$NGX_VERSION/src/core/nginx.h \
    && sed -i '14s/".2/".R/' bundle/nginx-$NGX_VERSION/src/core/nginx.h \
    && sed -i '49s/openresty/SoGlad/' bundle/nginx-$NGX_VERSION/src/http/ngx_http_header_filter_module.c \
    && sed -i '29s/nginx/SoGlad/' bundle/nginx-$NGX_VERSION/src/http/ngx_http_special_response.c \
    && sed -i '22s/"NGINX/"SOGLAD/' bundle/nginx-$NGX_VERSION/src/core/nginx.h \
    
    && ./configure --with-luajit \
                   --prefix=$RESTY_HOME/nginx \
                   --sbin-path=/usr/sbin/nginx \
                   --conf-path=/mnt/ngx/etc/nginx.conf \
                   --error-log-path=/mnt/ngx/log/error.log \
                   --http-log-path=/mnt/ngx/log/access.log \
                   --with-http_v2_module \
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

    && mkdir -p /tmp/etc && mv /mnt/ngx/etc/* /tmp/etc/ \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* $RESTY_HOME/src $RESTY_HOME/nginx/html $RESTY_HOME/nginx/logs \

    && echo -e '#!/bin/sh\n\
\n\
set -e\n\
\n\
mkdir -p /mnt/ngx/log /mnt/ngx/etc /mnt/lib\n\
\n\
if [ ! -f /mnt/ngx/etc/nginx.conf ]; then\n\
    cp -r /tmp/etc/*  /mnt/ngx/etc/\n\
fi\n\
\n\
exec "$@"' >> /usr/bin/entry \
    && chmod u+x /usr/bin/entry

#USER soglad
EXPOSE 80 443
VOLUME ["/mnt/ngx"]
WORKDIR /mnt/ngx
ENTRYPOINT ["entry"]
CMD ["nginx"]
