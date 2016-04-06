#++++++++++++++++++++++++++++++++++++++
# Alpine 3 Nginx Docker container
#++++++++++++++++++++++++++++++++++++++

FROM soglad/base:alpine3
MAINTAINER palmtale<m@glad.so>
LABEL vendor=Glad.so

ENV WEB_DOCUMENT_ROOT  /home/soglad/
ENV WEB_DOCUMENT_INDEX index.php
ENV WEB_ALIAS_DOMAIN   *.vm
ENV CONF_HOME /usr/local

# Compile and Install nginx
RUN /usr/local/bin/yum-install pcre-devel zlib-devel openssl-devel
WORKDIR /usr/local/src/github.com/nginx
RUN git clone https://github.com/nginx/nginx.git
WORKDIR /usr/local/src/github.com/nginx/nginx
RUN git checkout release-1.9.12
RUN rm -rf /usr/local/src/github.com/nginx/nginx/src/core/nginx.h
COPY conf/bin/nginx.h /usr/local/src/github.com/nginx/nginx/src/core/
RUN auto/configure --prefix=/usr/local/nginx --sbin-path=/usr/sbin/nginx --conf-path=/usr/local/etc/nginx/nginx.conf  --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-pcre --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-mail --with-mail_ssl_module --with-ipv6 --pid-path=/run/nginx.pid
RUN make && make install

# Deploy scripts/configurations
COPY conf/ $CONF_HOME
RUN bash $CONF_HOME/bin/control.sh provision.role soglad-nginx \
    && bash $CONF_HOME/bin/bootstrap.sh

EXPOSE 80
EXPOSE 443

CMD ["supervisord"]
