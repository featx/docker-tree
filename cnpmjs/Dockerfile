#+++++++++++++++++++++++++++++++++++++++#
# CNPM Docker container based on Alpine #
#+++++++++++++++++++++++++++++++++++++++#

FROM soglad/node:alpine
MAINTAINER palmtale<m@glad.so>
LABEL vendor=Glad.so

ENV HOME=/usr/local
ENV VERSION=2.10.0

WORKDIR $HOME
RUN apk add -U git && git clone https://github.com/cnpm/cnpmjs.org.git
WORKDIR $HOME/cnpmjs.org
RUN git checkout $VERSION && rm -rf $HOME/cnpmjs.org/config/index.js
COPY config.js $HOME/cnpmjs.org/config/index.js
RUN make install && apk del git
EXPOSE 7001,7002
CMD ["npm"]
