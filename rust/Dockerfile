#++++++++++++++++++++++++++++++++++++++
# Rust Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM opensuse:42.2
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV RUST_VERSION=1.16.0 \
    RUST_HOME=/usr/local

RUN set -ex \
    && zypper in -y make gcc gcc-c++ glibc-devel cmake curl tar python \
       ca-certificates file lldb gdb \
    && export DOWNLOAD_URL=https://static.rust-lang.org/dist/rustc-$RUST_VERSION-src.tar.gz \

    && cd $RUST_HOME \
    && curl -fsOSL $DOWNLOAD_URL \
    && curl -s $DOWNLOAD_URL.sha256 | sha256sum -c - \
    && tar -zxvf rustc-$RUST_VERSION-src.tar.gz \
    && cd rustc-$RUST_VERSION-src \
    && ./configure --prefix=$RUST_HOME \
    && make && make install \
    && zypper rm -y make gcc gcc-c++ glibc-devel cmake curl tar python ca-certificates \
    && rm -rf /var/cache/* $RUST_HOME/rustc-$RUST_VERSION-src*

CMD ["rustc"]
