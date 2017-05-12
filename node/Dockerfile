#++++++++++++++++++++++++++++++++++++++
# Node.js Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=SoGlad
MAINTAINER Palm Tale<palmtale@glad.so>

ENV NODE_VERSION=v7.10.0 \
#v6.10.3
    NPM_VERSION=4.2.0 \
#3.10.10
    NODE_HOME=/usr/local

# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && apk add --no-cache gnupg build-base linux-headers binutils-gold paxctl python curl libgcc libstdc++ \
  && for key in \
    #94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    #B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    #56730D5401028683275BD23C23EFEFE93C4CFFFE \
    #71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    #FD3A5288F042B6850C66B31F09FE44734EB7990E \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    #DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    #0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    #9554F04D7259F04124DE6B476D5A82AC7E37093B \
    #93C7E9E91B49E432C2F75674B0A78B0A6C481CF6 \
    #114F43EE0176B71C7BC219DD50A3051F888C628D \
    #7937DFD2AB06298B2293C3187D33FF9D0246406D \
  ; do \
    gpg --keyserver pool.sks-keyservers.net --recv-keys "$key"; \
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
  && cd / \
  && if [ -x $NODE_HOME/bin/npm ]; \
     then npm install -g npm@$NPM_VERSION \
  && find $NODE_HOME/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf; \
     fi \
  && apk del gnupg build-base linux-headers binutils-gold paxctl python curl \
  && rm -rf /etc/ssl /node-$NODE_VERSION.tar.gz /SHASUMS256.txt.asc /node-$NODE_VERSION /usr/include/* \
      $NODE_HOME/share/man /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp /root/.gnupg \
      $NODE_HOME/lib/node_modules/npm/man $NODE_HOME/lib/node_modules/npm/doc $NODE_HOME/lib/node_modules/npm/html
CMD ["node", "-v"]
