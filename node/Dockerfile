#++++++++++++++++++++++++++++++++++++++
# Node.js Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Featx
MAINTAINER Excepts <ex7ept@featx.org>

ENV NODE_VERSION=v16.2.0 \
#v14.17.0
    NPM_VERSION=7.14.0 \
    NODE_HOME=/usr/local \
    NODE_PATH=/usr/local/lib/node_modules
# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && apk add --no-cache --virtual .build-deps \
   gnupg build-base linux-headers binutils-gold paxctl \
   python3 curl libgcc libstdc++ \
  && ln -s /usr/bin/python3 /usr/bin/python \ 
  && for key in \
    #4ED778F539E3634C779C87C6D7062848A1AB005C \
    #94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    #B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    #77984A986EBC2AA786BC0F66B01FBB92821C587A \
    #71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    #FD3A5288F042B6850C66B31F09FE44734EB7990E \
    8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
    #C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    #DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    #A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
    #B9E2F5981AA6E0CD28160D9FF13993A75599653C \
  ; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key"; \
  done \
  && curl -o node-$NODE_VERSION.tar.gz -sSL https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION.tar.gz \
  && curl -o SHASUMS256.txt.asc -sSL https://nodejs.org/dist/$NODE_VERSION/SHASUMS256.txt.asc \
  && gpg --verify SHASUMS256.txt.asc && grep node-$NODE_VERSION.tar.gz SHASUMS256.txt.asc | sha256sum -c - \
  && tar -zxf node-$NODE_VERSION.tar.gz && cd node-$NODE_VERSION \
  && export GYP_DEFINES="linux_use_gold_flags=0" \
  && ./configure --prefix=$NODE_HOME \
# --fully-static \
  && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
  && make -j${NPROC} -C out mksnapshot BUILDTYPE=Release \
  && paxctl -cm out/Release/mksnapshot \
  && make -j${NPROC} && make install \
  && paxctl -cm $NODE_HOME/bin/node \
  && runDeps="$( scanelf --needed --nobanner --recursive ${NODE_HOME} \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
    | sort -u \
    | xargs -r apk info --installed \
    | sort -u )" \
  && cd / \
  && if [ -x $NODE_HOME/bin/npm ]; \
     then npm install -g npm@$NPM_VERSION \
  && find $NODE_HOME/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf; \
     fi \
  && apk del .build-deps \
  && apk add --no-cache --virtual .node-rundeps $runDeps \
  && rm -rf /etc/ssl /node-$NODE_VERSION.tar.gz /SHASUMS256.txt.asc /node-$NODE_VERSION /usr/include/* \
      $NODE_HOME/share/man /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp /root/.gnupg \
      $NODE_HOME/lib/node_modules/npm/man $NODE_HOME/lib/node_modules/npm/doc $NODE_HOME/lib/node_modules/npm/html
CMD ["node", "-v"]
