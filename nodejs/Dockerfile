#++++++++++++++++++++++++++++++++++++++
# Alpine 3 Node.js Docker container
#++++++++++++++++++++++++++++++++++++++

FROM alpine:3.3
MAINTAINER palmtale<m@glad.so>
LABEL vendor=Glad.so

ENV NODE_VERSION=v5.10.1
ENV NPM_VERSION=3
ENV NODE_HOME=/usr/local
ENV NPM_CONFIG_LOGLEVEL info
ENV CONFIG_FLAGS="--fully-static --without-npm" DEL_PKGS="libgcc libstdc++" RM_DIRS=/usr/include

# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && apk add --no-cache curl make gcc g++ binutils-gold python linux-headers paxctl libgcc libstdc++ gnupg \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done \
  && curl -o node-${NODE_VERSION}.tar.gz -sSL https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}.tar.gz \
  && curl -o SHASUMS256.txt.asc -sSL https://nodejs.org/dist/${NODE_VERSION}/SHASUMS256.txt.asc \
  && gpg --verify SHASUMS256.txt.asc \
  && grep node-${NODE_VERSION}.tar.gz SHASUMS256.txt.asc | sha256sum -c - \
  && tar -zxf node-${NODE_VERSION}.tar.gz \
  && cd /node-${NODE_VERSION} \
  && ./configure --prefix=${NODE_HOME} ${CONFIG_FLAGS} \
  && make -j$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
  && make install \
  && paxctl -cm ${NODE_HOME}/bin/node \
  && cd / \
  && if [ -x ${NODE_HOME}/bin/npm ]; \
     then npm install -g npm@${NPM_VERSION} \
  && find ${NODE_HOME}/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf; \
     fi \
  && apk del curl make gcc g++ binutils-gold python linux-headers paxctl gnupg ${DEL_PKGS} \
  && rm -rf /etc/ssl /node-${NODE_VERSION}.tar.gz /SHASUMS256.txt.asc /node-${NODE_VERSION} ${RM_DIRS} \
      ${NODE_HOME}/share/man /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp /root/.gnupg \
      ${NODE_HOME}/lib/node_modules/npm/man ${NODE_HOME}/lib/node_modules/npm/doc ${NODE_HOME}/lib/node_modules/npm/html
