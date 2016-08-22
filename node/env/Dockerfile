#++++++++++++++++++++++++++++++++++++++++++++++++#
# Node.js Running app Docker container in Alpine #
#++++++++++++++++++++++++++++++++++++++++++++++++#

FROM soglad/node
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV APP_HOME=/usr/local/app \
    APP_PORT=5000 \
    APP_ENV=production
    # It's not required to expose Debug and inspector ports in production env
    #DEBUG_PORT=5858 \
    #INSPECTOR_PORT=8080

COPY docker-entry /usr/local/bin/
RUN chmod u+x /usr/local/bin/docker-entry
    # It's not required to expose Debug and inspector ports in production env
    # && npm install -g node-inspector

VOLUME $APP_HOME $APP_HOME/data
EXPOSE $APP_PORT
       #$DEBUG_PORT $INSPECTOR_PORT
WORKDIR $APP_HOME
ENTRYPOINT ["docker-entry"]
CMD ["node", "."]
