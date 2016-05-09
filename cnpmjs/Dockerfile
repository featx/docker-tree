#++++++++++++++++++++++++++++++++++++++#
# CNPM Docker container based on Alpine #
#+++++++++++++++++++++++++++++++++++++++#

FROM soglad/node:alpine
MAINTAINER palmtale<m@glad.so>
LABEL vendor=Glad.so

ENV INSTALL_HOME /usr/local
ENV VERSION 2.10.0
ENV NODE_ENV production

# TODO The datadir is configured in config.js,
#      But dont know how to set variable for some ENV,
#      hard code for now
ENV DATA_DIR /var/data/cnpmjs

RUN apk add -U git \
    && mkdir $INSTALL_HOME/cnpm && cd $INSTALL_HOME/cnpm \
    && git clone https://github.com/cnpm/cnpmjs.org.git \
    && cd $INSTALL_HOME/cnpm/cnpmjs.org/ && git checkout $VERSION \
    && rm -rf $INSTALL_HOME/cnpm/cnpmjs.org/config/index.js

COPY config.js $INSTALL_HOME/cnpm/cnpmjs.org/config/index.js

WORKDIR $INSTALL_HOME/cnpm/cnpmjs.org

RUN NODE_ENV=$NODE_ENV && npm install --production \
    --build-from-source --registry=https://registry.npm.taobao.org \
    --disturl=https://npm.taobao.org/mirrors/node \
    && apk del git && rm -rf /var/cache/apk/* \
    && LOG_PATH=`node -e "console.log(require('./config').logdir);\
    process.exit(0);"` && echo $LOG_PATH

EXPOSE 7001 7002
ENTRYPOINT cp ./History.md ./docs/web/history.md && nohup node ./dispatch.js > $DATA_DIR/logs/cnpmjs_out.log 2>&1
