#++++++++++++++++++++++++++++++++++++++
# CentOS 7 Nginx Docker container
#++++++++++++++++++++++++++++++++++++++

FROM soglad/boot:centos7
MAINTAINER palmtale<m@glad.so>
LABEL vendor=Glad.so

ENV WEB_DOCUMENT_ROOT  /application/code/
ENV WEB_DOCUMENT_INDEX index.php
ENV WEB_ALIAS_DOMAIN   *.vm

# Install nginx
RUN /usr/local/bin/yum-install \
        nginx

# Deploy scripts/configurations
COPY conf/ /opt/docker/
RUN bash /opt/docker/bin/control.sh provision.role soglad-nginx \
    && bash /opt/docker/bin/bootstrap.sh

EXPOSE 80
EXPOSE 443

CMD ["supervisord"]
