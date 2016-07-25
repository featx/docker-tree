#++++++++++++++++++++++++++++++++++++++
# Node.js Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM soglad/node
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV APP_HOME=/usr/local/app \
    APP_PORT=5000 \
    DEBUG_PORT=5858 \
    INSPECTOR_PORT=8080

COPY *.* /usr/local/
RUN npm install -g node-inspector \
    && mv /usr/local/docker-run.sh /usr/local/bin/ \
    && chmod u+x /usr/local/bin/docker-run.sh

VOLUME $APP_HOME
EXPOSE $APP_PORT $DEBUG_PORT $INSPECTOR_PORT
WORKDIR $APP_HOME
ENTRYPOINT ["docker-run.sh"]
CMD ["node", "--debug", "."]