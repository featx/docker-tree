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

COPY sbin/ /usr/sbin

# Deploy scripts/configurations
COPY conf/ $CONF_HOME

EXPOSE 80
EXPOSE 443

CMD ["supervisord"]
