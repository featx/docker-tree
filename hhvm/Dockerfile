#++++++++++++++++++++++++++++++++++++++++++++#
#      HHVM Docker container in Ubuntu       #
#++++++++++++++++++++++++++++++++++++++++++++#

FROM ubuntu:16.10
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV HHVM_VERSION=3.15.0 \
    HHVM_HOME=/usr/local \
    HHVM_DATA=/mnt/hhvm \
    HHVM_SAVE=/home/hhvm

COPY entry /usr/bin/
RUN set -e \
    && apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449 \
    && add-apt-repository "deb http://dl.hhvm.com/ubuntu $(lsb_release -sc) main" \
    && apt-get update \
    && apt-get install -y hhvm ca-certificates --no-install-recommends \
    && update-rc.d hhvm defaults \
    && apt-get clean \
    && rm -rf /var/cache/apt/archives/*
    
VOLUME $HHVM_DATA /mnt/app
EXPOSE 9000
ENTRYPOINT ["entry"]
CMD ["hhvm", "-c", "/mnt/hhvm/etc/php.ini", "-c", "/mnt/hhvm/etc/server.ini", "-m", "s", "-u", "hhvm"]
