#++++++++++++++++++++++++++++++++++#
#  Lua Docker container in Alpine  #
#++++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Featx
MAINTAINER Excepts <excepts@aliyun.com>

ENV LUA_HOME=/usr/local \
    LUA_VERSION=5.3.5 \
    WITH_LUA=/usr/local/ \
    LUA_LIB=/usr/local/lib/lua \
    LUA_INCLUDE=/usr/local/include

RUN apk add --no-cache --virtual .build-deps \
    make tar unzip gcc readline-dev libressl-dev wget libc-dev ncurses-dev \
    #Go into src and Make
    && cd ${LUA_HOME} \
    && wget http://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz \
    && echo "112eb10ff04d1b4c9898e121d6bdf54a81482447  lua-${LUA_VERSION}.tar.gz" > lua-${LUA_VERSION}.tar.gz.sha1 \
    && grep lua-${LUA_VERSION}.tar.gz lua-${LUA_VERSION}.tar.gz.sha1 | sha1sum -c - \
    && tar -zxf lua-${LUA_VERSION}.tar.gz \
    && cd lua-${LUA_VERSION} \
    && make linux test \
    && make install \
    && cd .. \
    && runDeps="$( scanelf --needed --nobanner --recursive ${LUA_HOME} \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u \
        | xargs -r apk info --installed \
        | sort -u )" \
    #Go out parent for dispose
    && apk del .build-deps \
    && rm -rf lua-* /var/cache/apk/* \
    && apk add --no-cache --virtual .lua-deps $runDeps

WORKDIR ${LUA_HOME}