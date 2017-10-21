#+++++++++++++++++++++++++++++++++++++#
#   Etcd Docker container in Alpine   #
#+++++++++++++++++++++++++++++++++++++#


FROM alpine
LABEL vendor=Glad.so
MAINTAINER Palmtale <palmtale@glad.so>

ENV ETCD_HOME=/usr/local \
    ETCD_VERSION=3.2.9

RUN set -ex \
    && apk add -U ca-certificates git build-base go \
    && cd ${ETCD_HOME}/ \
    && git clone https://github.com/coreos/etcd.git \
    && cd etcd && git checkout v${ETCD_VERSION} \
    && make build && mkdir -p ${ETCD_HOME}/bin \
    && mv ./bin/* ${ETCD_HOME}/bin/ \
    && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf \
    && apk del ca-certificates git build-base go \
    && rm -rf /var/cache/apk/* ${ETCD_HOME}/etcd

WORKDIR ${ETCD_HOME}
EXPOSE 2379 2380
CMD ["etcd"]