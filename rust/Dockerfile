#++++++++++++++++++++++++++++++++++++++
# Rust Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV RUST_VERSION=1.16.0 \
    RUST_HOME=/usr/local

RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
               build-base cmake \
    && apk add --no-cache --virtual .run-deps \
               ca-certificates file curl python libc6-compat \
    && export DOWNLOAD_URL=https://static.rust-lang.org/dist/rust-$RUST_VERSION-x86_64-unknown-linux-gnu.tar.gz \
                           https://static.rust-lang.org/dist/rust-$RUST_VERSION-mipsel-unknown-linux-gnu.tar.gz
                           https://static.rust-lang.org/dist/rustc-$RUST_VERSION-src.tar.gz
    && cd $RUST_HOME \
    && curl -fsOSL $DOWNLOAD_URL \
    && curl -s $DOWNLOAD_URL.sha256 | sha256sum -c - && mkdir -p $RUST_HOME/rust \
    && tar -C $RUST_HOME/rust -zxf rust-$RUST_VERSION-x86_64-unknown-linux-gnu.tar.gz --strip-components=1 \
    && cd $RUST_HOME/rust && ./install.sh --enable-debug \
    && export PATH=$PATH:/usr/local/rust/build/x86_64-unknown-linux-g
nu/stage0/bin \
    && apk del g++ gcc make libc-dev curl tar ca-certificates \
    && rm -rf /var/cache/apk/* $RUST_HOME/rust-$RUST_VERSION-x86_64-unknown-linux-gnu.tar.gz

CMD ["rustc"]
