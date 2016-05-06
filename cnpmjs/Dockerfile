#+++++++++++++++++++++++++++++++++++++++#
# CNPM Docker container based on Alpine #
#+++++++++++++++++++++++++++++++++++++++#

FROM soglad/node:alpine
MAINTAINER palmtale<m@glad.so>
LABEL vendor=Glad.so

ENV HOME=/usr/local
ENV VERSION=2.10.0

RUN apk add -U git \
    && mkdir $HOME/cnpm && cd $HOME/cnpm && git clone https://github.com/cnpm/cnpmjs.org.git \
    && cd $HOME/cnpm/cnpmjs.org/ && git checkout $VERSION
COPY config.js $HOME/cnpmjs.org/config/
WORKDIR $HOME/cnpm/cnpmjs.org
RUN export NODE_ENV=production && npm install --build-from-source --registry=https://registry.npm.taobao.org --disturl=https://npm.taobao.org/mirrors/node && apk del git
EXPOSE 7001
EXPOSE 7002
ENTRYPOINT npm run start
