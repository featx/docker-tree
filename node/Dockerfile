#++++++++++++++++++++++++++++++++++++++#
# Node.js Docker container in Opensuse #
#++++++++++++++++++++++++++++++++++++++#

FROM opensuse
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV NODE_VERSION=v4.6.1 \
#6.9.1
    NPM_VERSION=2.15.9 \
#3.10.8
    NODE_HOME=/usr/local

# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && zypper in tar curl make gcc gcc-c++ binutils-gold python kernel-default-devel \
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
  && curl -o node-$NODE_VERSION.tar.gz -sSL https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION.tar.gz \
  && curl -o SHASUMS256.txt.asc -sSL https://nodejs.org/dist/$NODE_VERSION/SHASUMS256.txt.asc \
  && gpg --verify SHASUMS256.txt.asc && grep node-$NODE_VERSION.tar.gz SHASUMS256.txt.asc | sha256sum -c - \
  && tar -zxf node-$NODE_VERSION.tar.gz && cd node-$NODE_VERSION \
  && export GYP_DEFINES="linux_use_gold_flags=0" \
  && ./configure --prefix=$NODE_HOME --fully-static \
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
  && zypper rm tar curl make gcc gcc-c++ binutils-gold python kernel-default-devel \
  && rm -rf /etc/ssl /node-$NODE_VERSION.tar.gz /SHASUMS256.txt.asc /node-$NODE_VERSION /usr/include/* \
      $NODE_HOME/share/man /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp /root/.gnupg \
      $NODE_HOME/lib/node_modules/npm/man $NODE_HOME/lib/node_modules/npm/doc $NODE_HOME/lib/node_modules/npm/html
CMD ["node", "-v"]
