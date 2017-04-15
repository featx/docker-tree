#+++++++++++++++++++++++++++++++++#
# Rust Docker container in Alpine #
#+++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<palmtale@glad.so>

#ARG RUST_HOME=/usr/local
#ARG RUST_VERSION=1.16.0
#ARG CARGO_VERSION=0.17.0
#
#https://static.rust-lang.org/dist/rust-$RUST_VERSION-x86_64-unknown-linux-gnu.tar.gz
#https://static.rust-lang.org/dist/rust-$RUST_VERSION-mipsel-unknown-linux-gnu.tar.gz
#
RUN set -ex \
     && sed -i '$a\http://dl-cdn.alpinelinux.org/alpine/edge/main' /etc/apk/repositories \
     && sed -i '$a\http://dl-cdn.alpinelinux.org/alpine/edge/testing' /etc/apk/repositories \
     && apk update \
     && apk add -U rust cargo

#    && apk add --no-cache --virtual .build-deps \
#               build-base gnupg cmake curl \
#    && apk add --no-cache --virtual .run-deps \
#               file python libc6-compat \
#    && export DOWNLOAD_URL=https://static.rust-lang.org/dist/rustc-$RUST_VERSION-src.tar.gz \
    
#    && cd $RUST_HOME \
#    && curl -fsOSL $DOWNLOAD_URL \
#    && curl $DOWNLOAD_URL.sha256 | sha256sum -c - \
#    && curl -fsOSL $DOWNLOAD_URL.asc \
#    && gpg --keyserver pgpkeys.mit.edu --recv-key 5CB4A9347B3B09DC \
#    && gpg --verify rustc-$RUST_VERSION-src.tar.gz.asc rustc-$RUST_VERSION-src.tar.gz \
    
#    && tar -zxvf rustc-$RUST_VERSION-src.tar.gz \
#    && cd rustc-$RUST_VERSION-src \
#    && ./configure --prefix=$RUST_HOME --enable-debug \
        
#    && apk del .build-deps \
#    && rm -rf /var/cache/apk/* $RUST_HOME/rustc-$RUST_VERSION-src*

CMD ["rustc"]
