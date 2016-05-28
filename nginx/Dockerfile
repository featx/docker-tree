#++++++++++++++++++++++++++++++++++++++
# Nginx Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine:3.3
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV NGINX_HOME /usr/local
ENV NGINX_SRC_HOME /usr/local/src
ENV NGINX_VERSION release-1.11.0

RUN apk add --no-cache git pcre-dev openssl-dev make gcc g++ linux-headers paxctl libgcc libstdc++ gnupg \
    && mkdir $NGINX_SRC_HOME \
    && cd $NGINX_SRC_HOME \
    && git clone https://github.com/nginx/nginx.git \
    && cd $NGINX_SRC_HOME/nginx \
    && git checkout $NGINX_VERSION \
    && rm $NGINX_SRC_HOME/nginx/src/core/nginx.h

COPY conf/nginx.h $NGINX_SRC_HOME/nginx/src/core/

RUN cd $NGINX_SRC_HOME/nginx \
    && ./auto/configure --prefix=$NGINX_HOME/nginx \
                   --sbin-path=/usr/sbin/nginx \
                   --conf-path=/etc/nginx/nginx.conf \
                   --error-log-path=/var/log/nginx/error.log \
                   --http-log-path=/var/log/nginx/access.log \
                   --with-pcre --with-http_ssl_module \
                   --with-http_realip_module \
                   --with-http_addition_module --with-http_sub_module \
                   --with-http_dav_module --with-http_flv_module \
                   --with-http_mp4_module --with-http_gunzip_module \
                   --with-http_gzip_static_module \
                   --with-http_random_index_module \
                   --with-http_secure_link_module \
                   --with-http_stub_status_module \
                   --with-mail --with-mail_ssl_module \
                   --with-ipv6 \
    && make && make install \
    && rm -rf $NGINX_SRC_HOME/* \
    && rm -rf $NGINX_HOME/html \
    && rm -rf /etc/nginx/nginx.conf \
    && mkdir /etc/nginx/conf.d \
    && apk del git make gcc g++ linux-headers paxctl libgcc libstdc++ gnupg \
    && rm -rf /var/cache/apk/*
COPY conf/etc/nginx/* /etc/nginx/
EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/usr/sbin/nginx"]
