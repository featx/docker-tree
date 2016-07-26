#++++++++++++++++++++++++++++++++++++++++++++++++#
# Node.js Running app Docker container in Alpine #
#++++++++++++++++++++++++++++++++++++++++++++++++#

FROM soglad/node
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV APP_HOME=/usr/local/app \
    APP_PORT=5000 \
    APP_ENV=production \
    # It's not require to expose Debug and inspector ports in production dev
    DEBUG_PORT=5858 \
    INSPECTOR_PORT=8080

COPY $APP_ENV-entry /usr/local/
RUN mv /usr/local/$APP_ENV-entry /usr/local/bin/node-entry \
    && chmod u+x /usr/local/bin/node-entry

VOLUME $APP_HOME
EXPOSE $APP_PORT \
       $DEBUG_PORT $INSPECTOR_PORT
WORKDIR $APP_HOME
ENTRYPOINT ["node-entry"]
CMD ["node", "."]
