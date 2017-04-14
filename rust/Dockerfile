#+++++++++++++++++++++++++++++++++#
# Rust Docker container in CentOS #
#+++++++++++++++++++++++++++++++++#

FROM centos:7.3.1611
LABEL vendor=Glad.so
MAINTAINER palmtale<palmtale@glad.so>

ENV RUST_HOME=/usr/local \
    RUST_VERSION=1.16.0 \
    CARGO_VERSION=0.17.0 

RUN set -ex \
    && yum install -y make gcc gcc-c++ cmake glibc-devel openssl-devel \
       curl tar python ca-certificates file lldb gdb \
    && export RUST_URL=https://static.rust-lang.org/dist/rustc-$RUST_VERSION-src.tar.gz \
    && export CARGO_URL=https://github.com/rust-lang/cargo/archive/$CARGO_VERSION.tar.gz \
    
    && cd $RUST_HOME \
    && curl -fsOSL $RUST_URL \
    && curl -s $RUST_URL.sha256 | sha256sum -c - \
    && tar -zxvf rustc-$RUST_VERSION-src.tar.gz \
    && cd rustc-$RUST_VERSION-src \
    && ./configure --prefix=$RUST_HOME \
    #  --enable-debug
    && make && make install \
    
    && curl -fsOSL $CARGO_URL \
    && tar -zxvf cargo-$CARGO_VERSION.tar.gz \
    && cd cargo-$CARGO_VERSION \
    && $RUST_HOME/rustc-$RUST_VERSION-src/build/x86_64-unknown-linux-gnu/stage0/bin/cargo build --release \
    && mv target/release/cargo $RUST_HOME/bin/ \
    
    && cd $RUST_HOME \
    && yum erase -y make gcc gcc-c++ cmake glibc-devel openssl-devel curl tar python \
    && rm -rf /var/cache/* $RUST_HOME/rustc-$RUST_VERSION-src*

CMD ["rustc"]

