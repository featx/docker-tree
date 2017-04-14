#++++++++++++++++++++++++++++++++++++++
# Rust Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM opensuse:42.2
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV RUST_HOME=/usr/local \
    RUST_VERSION=1.16.0 \
    CARGO_VERSION=0.17.0 

RUN set -ex \
    && zypper in -y make gcc gcc-c++ glibc-devel cmake curl tar python openssl-devel \
       ca-certificates file lldb gdb \
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
    && zypper rm -y make gcc gcc-c++ glibc-devel cmake curl tar python openssl-devel \
    && rm -rf /var/cache/* $RUST_HOME/rustc-$RUST_VERSION-src*

CMD ["rustc"]
