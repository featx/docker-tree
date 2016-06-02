#++++++++++++++++++++++++++++++++++++++
# Memcached Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine:3.3
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV MEMCACHED_VERSION 1.4.25
ENV MEMCACHED_SHA1 7fd0ba9283c61204f196638ecf2e9295688b2314

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN adduser -S -g daemon memcache \
    && set -x \
    && apk add --no-cache libevent curl tar make gcc g++ linux-headers paxctl libgcc libstdc++ gnupg libevent-dev perl \
    && curl -SL "http://memcached.org/files/memcached-$MEMCACHED_VERSION.tar.gz" -o memcached.tar.gz \
    && echo "$MEMCACHED_SHA1  memcached.tar.gz" | sha1sum -c - \
    && mkdir -p /usr/src/memcached \
    && tar -xzf memcached.tar.gz -C /usr/src/memcached --strip-components=1 \
    && rm -rf memcached.tar.gz /usr/src/memcached/slabs.c /usr/src/memcached/items.c /usr/src/memcached/slabs.c

COPY src/*.c /usr/src/memcached/
RUN cd /usr/src/memcached && ./configure && make && make install && cd / \
    && apk del curl tar make gcc g++ linux-headers paxctl libgcc libstdc++ gnupg libevent-dev perl \
    && rm -rf /var/cache/apk/* /usr/src/memcached

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

USER memcache
EXPOSE 11211
CMD ["memcached"]
