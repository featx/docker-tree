#++++++++++++++++++++++++++++++++++++++++++++++++#
# Node.js Running app Docker container in Alpine #
#++++++++++++++++++++++++++++++++++++++++++++++++#

FROM soglad/node
LABEL vendor=Glad.so
MAINTAINER palmtale<palmtale@glad.so>

ENV APP_HOME=/mnt/app \
    APP_ENV=dev \
    APP_PORT=5000 \
    # No dev but inspect upper than 7.x.x, and no node-inspector any more
    # It's not required to expose Debug and inspector ports in production env
    DEBUG_PORT=9229 
    #5858 INSPECTOR_PORT=8080

COPY entry /usr/local/bin/
RUN chmod u+x /usr/local/bin/entry 
    # It's not required to expose Debug and inspector ports in production env
    #&& apk add -U build-base python2 \
    #&& npm install -g node-inspector \
    #&& apk del build-base python2 

VOLUME $APP_HOME
EXPOSE $APP_PORT $DEBUG_PORT 
#$INSPECTOR_PORT
WORKDIR $APP_HOME
ENTRYPOINT ["entry"]
CMD ["node", "--inspect", "."]
#CMD ["node", "--debug", "."]