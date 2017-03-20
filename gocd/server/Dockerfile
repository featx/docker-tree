#++++++++++++++++++++++++++++++++++++++++#
# GOCD Server Docker container in Alpine #
#++++++++++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Glad.so
MAINTAINER Palmtale <palmtale@glad.so>

ENV GOCD_HOME=/usr/local/gocd \
    GOCD_VERSION=17.2.0 \
    GOCD_USER=gocd
    
RUN set -ex \
    && export GOCD_VERSION=17.2.0 && export GOCD_GROUP=gocd && export DAEMON=Y \
    && addgroup -g 1000 ${GOCD_GROUP} && adduser -G ${GOCD_GROUP} -u 1000 -s /sbin/nologin -D ${GOCD_USER} \
    && apk add -U wget ca-certificates openjdk8-jre-base bash git mercurial subversion openssh-client \
    && wget -O /tmp/go-server.zip \
       https://download.gocd.io/binaries/${GOCD_VERSION}-4587/generic/go-server-${GOCD_VERSION}-4587.zip \
    && mkdir -p ${GOCD_HOME} \
    && unzip /tmp/go-server.zip -d /tmp/ \
    && mv /tmp/go-server-${GOCD_VERSION}/* ${GOCD_HOME}/ \
    && ${GOCD_HOME}/server.sh \
    && sleep 1m && ${GOCD_HOME}/stop-server.sh \

    && cd ${GOCD_HOME} \
    && mkdir -p /var/tmp/gocd/logs /var/tmp/gocd/addons \
    && mv ./artifacts ./config ./db ./plugins /var/tmp/gocd/ \
    && chown -R ${GOCD_USER}:${GOCD_GROUP} ${GOCD_HOME} \
    && chown -R ${GOCD_USER}:${GOCD_GROUP} /var/tmp/gocd \

    && echo -e '\nfor dir in `ls /var/tmp/gocd/`\n\
do\n\
    if [ ! -d /home/${GOCD_USER}/$dir ]; then\n\
        cp -r /var/tmp/gocd/$dir /home/${GOCD_USER}/\n\
    fi\n\
\n\
    rm -rf ${GOCD_HOME}/$dir\n\
    ln -s /home/${GOCD_USER}/$dir ${GOCD_HOME}/\n\
done\n' >> entry.sh \

    && sed -i '171 r entry.sh' server.sh\
    && rm -rf ./*.bat ./*.cmd ./entry.sh \
    && apk del wget ca-certificates \
    && rm -rf /tmp/* /var/cache/apk/* 


USER ${GOCD_USER}
VOLUME /home/${GOCD_USER}
EXPOSE 8153 8154
WORKDIR ${GOCD_HOME}
#ENV GO_CONFIG_DIR=${GOCD_HOME}/config \
#    SERVER_WORK_DIR=${GOCD_HOME} \
#   STDOUT_LOG_FILE=${GOCD_HOME}/logs
CMD ["./server.sh"]