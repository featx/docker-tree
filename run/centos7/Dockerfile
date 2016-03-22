#++++++++++++++++++++++++++++++++++++++
# CentOS 7 Nginx Docker container
#++++++++++++++++++++++++++++++++++++++

FROM soglad/base:centos7
MAINTAINER palmtale<m@glad.so>
LABEL vendor=Glad.so

ENV WEB_DOCUMENT_ROOT  /application/code/
ENV WEB_DOCUMENT_INDEX index.php
ENV WEB_ALIAS_DOMAIN   *.vm
ENV CONF_HOME /usr/local

# Install nginx
RUN /usr/local/bin/yum-install \
        nginx

# Deploy scripts/configurations
COPY conf/ $CONF_HOME
RUN bash $CONF_HOME/bin/control.sh provision.role soglad-nginx \
    && bash $CONF_HOME/bin/bootstrap.sh

EXPOSE 80
EXPOSE 443

CMD ["supervisord"]
