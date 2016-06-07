#++++++++++++++++++++++++++++++++++++++
# Rust Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV RUST_VERSION=1.9.0 \
    RUST_HOME=/usr/local

RUN set -ex \
    && apk add --no-cache g++ gcc make python ca-certificates file curl git tar \
    && cd $RUST_HOME && curl -fSL https://static.rust-lang.org/dist/rustc-$RUST_VERSION-src.tar.gz -o rustc.tar.gz \
    && tar -zxf rustc.tar.gz && cd rustc-$RUST_VERSION \
    && ./configure --prefix=$RUST_HOME \
    && make && make install \
    && apk del g++ gcc make python2 curl git tar ca-certificates \
    && rm -rf /var/cache/apk/* $RUST_HOME/rustc.tar.gz

CMD["rustc"]
