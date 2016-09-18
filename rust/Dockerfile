#++++++++++++++++++++++++++++++++++++++
# Rust Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM opensuse:42.1
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV RUST_VERSION=1.10.0 \
    RUST_HOME=/usr/local

RUN set -ex \
    && zypper in -y make gcc gcc-c++ libc-devel \
       ca-certificates file curl python \
    && export DOWNLOAD_URL=https://static.rust-lang.org/dist/rust-$RUST_VERSION-x86_64-unknown-linux-gnu.tar.gz \
    && cd $RUST_HOME \
    && curl -fsOSL $DOWNLOAD_URL \
    && curl -s $DOWNLOAD_URL.sha256 | sha256sum -c - && mkdir -p $RUST_HOME/rust \
    && tar -C $RUST_HOME/rust -zxf rust-$RUST_VERSION-x86_64-unknown-linux-gnu.tar.gz --strip-components=1 \
    && cd $RUST_HOME/rust && ./install.sh \
    && zypper rm -y g++ gcc make libc-dev curl ca-certificates \
    && rm -rf /var/cache/apk/* $RUST_HOME/rust-$RUST_VERSION-x86_64-unknown-linux-gnu.tar.gz

CMD ["rustc"]
