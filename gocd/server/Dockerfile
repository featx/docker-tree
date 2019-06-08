#++++++++++++++++++++++++++++++++++++++++#
# GOCD Server Docker container in Alpine #
#++++++++++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Featx
MAINTAINER Excepts <excepts@featx.org>

ENV GOCD_HOME=/usr/local/gocd \
    GOCD_VERSION=17.4.0 \
    GOCD_GROUP=gocd \
    GOCD_USER=gocd
    
RUN set -ex \
    && export DAEMON=Y \
    && addgroup -g 1000 ${GOCD_GROUP} && adduser -G ${GOCD_GROUP} -u 1000 -s /sbin/nologin -D ${GOCD_USER} \
    && apk add -U wget ca-certificates openjdk8-jre-base bash git mercurial subversion openssh-client \
    
    && cd /tmp \
    && wget -O go-server.zip \
       https://download.gocd.io/binaries/${GOCD_VERSION}-4892/generic/go-server-${GOCD_VERSION}-4892.zip \
    && echo "18e7da698804d329b8b79b8d49f122e8dbc959d4e9019a0946c671559c872fcd *go-server.zip" | sha256sum -c - \
    && mkdir -p ${GOCD_HOME} \
    && unzip go-server.zip \
    && mv go-server-${GOCD_VERSION}/* ${GOCD_HOME}/ \

    && cd ${GOCD_HOME} \
    && bash server.sh \
    # Wait until the application started up.
    && while [ $(cat go-server.out.log|wc -l) -lt 59 ]; do sleep 5s; done \
    && bash stop-server.sh \
    # Wait until the java process is killed.
    && while [ $(ps -A|grep go.jar|wc -l) -gt 3 ]; do sleep 5s; done \
    
    && mkdir -p /var/tmp/gocd/logs /var/tmp/gocd/addons \
    && mv artifacts config db plugins /var/tmp/gocd/ \
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

    && sed -i '171 r entry.sh' server.sh \
    && apk del wget \
    && rm -rf *.bat *.cmd entry.sh /tmp/* /var/cache/apk/* 


USER ${GOCD_USER}
VOLUME /home/${GOCD_USER}
EXPOSE 8153 8154
WORKDIR ${GOCD_HOME}
#ENV GO_CONFIG_DIR=${GOCD_HOME}/config \
#    SERVER_WORK_DIR=${GOCD_HOME} \
#   STDOUT_LOG_FILE=${GOCD_HOME}/logs
HEALTHCHECK --interval=5m --timeout=3s CMD curl -f http://localhost:8153/go || exit 1
CMD ["./server.sh"]