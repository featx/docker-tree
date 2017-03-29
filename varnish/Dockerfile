#++++++++++++++++++++++++++++++++++++++
# Nginx Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=SoGlad
MAINTAINER Palm Tale <palmtale@glad.so>

ENV VNS_HOME=/usr/local \
    VNS_VERSION=5.1.1

RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
               curl gnupg git build-base autoconf \
               linux-headers py-docutils \
               ncurses-dev  pcre-dev \
               libedit-dev readline-dev \
               jemalloc-dev libunwind-dev \
    && curl -o varnish-${VNS_VERSION}.tar.gz \
            -sSL https://repo.varnish-cache.org/source/varnish-${VNS_VERSION}.tar.gz \
 #   && curl -o SHA256SUM.gpg \
 #           -sSL https://repo.varnish-cache.org/source/SHA256SUM.gpg \
 #   && gpg --verify SHA256SUM.gpg \
    && curl -o SHA256SUM -sSL https://repo.varnish-cache.org/source/SHA256SUM \
    && grep varnish-${VNS_VERSION}.tar.gz SHA256SUM | sha256sum -c - \
    && tar -zxvf varnish-${VNS_VERSION}.tar.gz \
    && cd varnish-${VNS_VERSION} \
    && ./configure --prefix=${VNS_HOME} \
    && make CPPFLAGS=-D__NEED_mode_t -j$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && make install \
    && apk del .build-deps \
    && mkdir -p /tmp/varnish/etc && mv /etc/varnish/* /tmp/varnish/etc/ \
    && mkdir -p /tmp/varnish/lib && mv /var/lib/varnish/* /tmp/varnish/lib/ \
    && rm -rf /var/cache/apk/* /varnish* /SHA256* \
    && cd ${VNS_HOME} \
    && echo '#!/bin/sh\n\
set -x\n\
\n\
pid=0\n\
pid2=0\n\
\n\
term_handler() {\n\
  if [ $pid -ne 0 ]; then\n\
    kill -SIGTERM "$pid"\n\
    wait "$pid"\n\
  fi\n\
\n\
  if [ $pid2 -ne 0 ]; then\n\
    kill -SIGTERM "$pid2"\n\
    wait "$pid2"\n\
  fi\n\
\n\
  exit 143; \n\
}\n\
\n\
if [ ! -f /var/lib/varnish/default.vcl ]; then\n\
    mkdir -p /var/lib/varnish\n\
    cp /tmp/varnish/etc/default.vcl /var/lib/varnish/\n\
    cp -r /tmp/varnish/lib/* /var/lib/varnish/\n\
fi\n\
\n\
trap 'kill ${!}; term_handler' SIGTERM\n\
\n\
for name in VARNISH_BACKEND_PORT VARNISH_BACKEND_IP\n\
do\n\
    eval value=\$$name\n\
    sed -i "s|\${${name}}|${value}|g" /var/lib/varnish/default.vcl\n\
done\n\
\n\
sleep ${VARNISH_D_DELAY:=10}\n\
curl $VARNISH_BACKEND_IP:$VARNISH_BACKEND_PORT\n\
\n\
if [ -z "$VARNISH_ADMIN_IP"  ]; then\n\
  VARNISH_ADMIN_IP="localhost";\n\
fi\n\
\n\
if [ -z "$VARNISH_ADMIN_PORT" ]; then\n\
  VARNISH_ADMIN_PORT="6082";\n\
fi\n\
\n\
echo "Starting varnishd"\n\
varnishd -f /var/varnish/etc/default.vcl -s malloc,100M -a 0.0.0.0:${VARNISH_PORT} -T $VARNISH_ADMIN_IP:$VARNISH_ADMIN_PORT -F -p cli_timeout=60 -p connect_timeout=60 &\n\
\n\
pid="$!"\n\
sleep 5\n\
\n\
if [ ${VARNISH_LOG:=0} -eq 1 ]; then\n\
  echo "Starting log to console"\n\
  varnishlog &\n\
  pid2="$!"\n\
fi\n\
\n\
while true\n\
do\n\
  tail -f /dev/null & wait ${!}\n\
done' >> /usr/local/bin/entry && chmod u+x /usr/local/bin/entry 
 #   && apk add -U gcc libc-dev curl ncurses pcre libedit readline jemlloc libunwind
 
WORKDIR ${VNS_HOME}
VOLUME /var/lib/varnish
EXPOSE 6082
ENTRYPOINT ["entry"]