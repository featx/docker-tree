#++++++++++++++++++++++++++++++++++++++#
# Xunsearch Docker container in Alpine #
#++++++++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Glad.so
MAINTAINER Excepts <excepts@glad.so>

ENV XUNS_VERSION=1.4.10 \
    XUNS_HOME=/usr/local \
    XUNS_DATA=/mnt/xunsearch

RUN set -x \
    && apk add --no-cache --virtual .build-deps \
        wget build-base bzip2 zlib-dev \
    && cd /root \
    && wget -O - http://www.xunsearch.com/download/xunsearch-full-dev.tar.bz2 | tar xj \
    && cd /root/xunsearch-full-$XUNS_VERSION \
    && sh setup.sh --prefix=$XUNS_HOME \
    && echo "#!/bin/sh \n\
rm -f tmp/pid.*\n\
echo -n > tmp/docker.log\n\
bin/xs-indexd -l tmp/docker.log -k start\n\
sleep 1\n\
bin/xs-searchd -l tmp/docker.log -k start\n\
sleep 1\n\
tail -f tmp/docker.log\n\
" >> bin/xs-docker.sh

VOLUME $XUNS_DATA
WORKDIR $XUNS_HOME
EXPOSE 8383 8384
ENTRYPOINT ["sh"]
CMD ["bin/xs-docker.sh"]
