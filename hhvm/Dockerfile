#++++++++++++++++++++++++++++++++++++++++++++#
#      HHVM Docker container in Alpine       #
#++++++++++++++++++++++++++++++++++++++++++++#

FROM ubuntu:16.10
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

RUN set -e \
    && apt-get install -y ca-certificates git make gcc gcc-c++ cmake automake autoconf \
           libelf-devel libevent-devel libmcrypt-devel libmemcached-devel libicu-devel liblz4-devel \
           boost-devel pcre-devel openssl-devel zlib-devel gettext-devel readline-devel sqlite-devel \
           gd-devel imagemagick-devel freetype-devel jemalloc-devel gmp-devel \
           pkgconfig gawk jemalloc libtool \
    && \
    && apt-get remove -y ca-certificates git make gcc gcc-c++ cmake automake autoconf \
           libelf-devel libevent-devel libmcrypt-devel libmemcached-devel libicu-devel liblz4-devel \
           boost-devel pcre-devel openssl-devel zlib-devel gettext-devel readline-devel sqlite-devel \
           gd-devel imagemagick-devel freetype-devel jemalloc-devel gmp-devel \
#    && rm -rf /var/cache/apk/*

VOLUME $DATA_DIR
EXPOSE 9000
CMD ["entry"]
