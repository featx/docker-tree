#++++++++++++++++++++++++++++++++++#
# Nginx Docker container in Alpine #
#++++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Glad.so
MAINTAINER Palmtale <palmtale@glad.so>

ARG NGX_HOME=/usr/local
ARG NGX_VERSION=1.13.0

RUN set -ex && mkdir -p $NGX_HOME/src \
    && apk add --no-cache --virtual .build-deps \
               build-base wget tar gnupg git ca-certificates \
               pcre-dev openssl-dev libstdc++ paxctl \
               linux-headers \
    && apk add --no-cache --virtual .run-deps \
                libgcc pcre openssl \
    
    # Install Nginx
    && wget http://nginx.org/download/nginx-$NGX_VERSION.tar.gz \
    && wget http://nginx.org/download/nginx-$NGX_VERSION.tar.gz.asc \
    && gpg --keyserver pgpkeys.mit.edu --recv-key 520A9993A1C052F8 \
    && gpg --verify nginx-$NGX_VERSION.tar.gz.asc nginx-$NGX_VERSION.tar.gz \
    && tar -zxf nginx-$NGX_VERSION.tar.gz && mv nginx-$NGX_VERSION nginx \
    && cd nginx \

    && sed -i '12s/1013000/1100000/' src/core/nginx.h \
    && sed -i '13s/1.13.0/Motor/' src/core/nginx.h \
    && sed -i '14s/nginx/SoGlad/' src/core/nginx.h \
    && sed -i '49s/nginx/SoGlad/' src/http/ngx_http_header_filter_module.c \
    && sed -i '36s/nginx/SoGlad/' src/http/ngx_http_special_response.c \
    && sed -i '22s/"NGINX/"SOGLAD/' src/core/nginx.h \
    
    && ./configure --prefix=$NGX_HOME/nginx \
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
    && rm -rf /var/cache/apk/* $NGX_HOME/src $NGX_HOME/nginx/html $NGX_HOME/nginx/logs \

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
