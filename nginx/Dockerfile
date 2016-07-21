#++++++++++++++++++++++++++++++++++++++
# Nginx Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>
#USER soglad

ENV NGX_HOME=/usr/local \
    NGX_VERSION=release-1.11.2
# product variable/data would be put in /var   etc=/var/conf logs=/var/logs apps=/var/apps
RUN mkdir -p $NGX_HOME/src && cd $NGX_HOME/src \
    && apk add --no-cache pcre openssl \
       git pcre-dev openssl-dev make gcc g++ linux-headers paxctl libgcc libstdc++ gnupg \
    && git clone https://github.com/nginx/nginx.git \
    && cd $NGX_HOME/src/nginx \
    && git checkout $NGX_VERSION \
    && rm $NGX_HOME/src/nginx/src/core/nginx.h
COPY nginx.* $NGX_HOME/src/nginx/src/core/

RUN set -ex \
    && mv $NGX_HOME/src/nginx/src/core/nginx.sh /usr/bin/ \
    && chmod u+x /usr/bin/nginx.sh \
    && cd $NGX_HOME/src/nginx \
    && ./auto/configure --prefix=$NGX_HOME/nginx \
                   --sbin-path=/usr/sbin/nginx \
                   --conf-path=/var/conf/nginx.conf \
                   --error-log-path=/var/logs/error.log \
                   --http-log-path=/var/logs/access.log \
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
    && apk del git pcre-dev openssl-dev make gcc g++ linux-headers paxctl libgcc libstdc++ gnupg \
    && rm -rf /var/cache/apk/* $NGX_HOME/src $NGX_HOME/etc/nginx.conf $NGX_HOME/etc/*.default \
              $NGX_HOME/nginx/html $NGX_HOME/nginx/logs \
    && mkdir -p /tmp/etc \
    && mv $NGX_HOME/etc/* /tmp/etc/

COPY conf/* /tmp/etc/
EXPOSE 80 443
VOLUME /var
ENTRYPOINT ["nginx.sh"]
