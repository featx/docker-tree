#++++++++++++++++++++++++++++++++++++++#
# Nexus Docker container in Alpine     #
#++++++++++++++++++++++++++++++++++++++#

FROM java:8-jre-alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV NEXUS_DATA=/data \
    NEXUS_HOME=/usr/local/nexus \
    NEXUS_VERSION=3.0.0-03 \
    CONTEXT_PATH=/

WORKDIR $NEXUS_HOME

RUN apk add -U wget \
    && mkdir -p $NEXUS_HOME \
    && wget -O nexus.tar.gz \
       https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-$NEXUS_VERSION-unix.tar.gz \
    && tar -zxvf nexus.tar.gz \
    && mv nexus-$NEXUS_VERSION/* ./ && mv nexus-$NEXUS_VERSION/.install4j ./ \
    && wget -O $NEXUS_HOME/system/com/sonatype/nexus/plugins/nexus-repository-docker/3.0.0-03/nexus-repository-docker-3.0.0-03.jar \
       https://support.sonatype.com/hc/en-us/article_attachments/208186848/nexus-repository-docker-3.0.0-03-patch2.jar \
    && apk del wget \
    && rm -rf /var/cache/apk/* nexus-$NEXUS_VERSION nexus.tar.gz \
    && sed \
    -e "s|karaf.home=.|karaf.home=$NEXUS_HOME|g" \
    -e "s|karaf.base=.|karaf.base=$NEXUS_HOME|g" \
    -e "s|karaf.etc=etc|karaf.etc=$NEXUS_HOME/etc|g" \
    -e "s|java.util.logging.config.file=etc|java.util.logging.config.file=$NEXUS_HOME/etc|g" \
    -e "s|karaf.data=data|karaf.data=$NEXUS_DATA|g" \
    -e "s|java.io.tmpdir=data/tmp|java.io.tmpdir=$NEXUS_DATA/tmp|g" \
    -i $NEXUS_HOME/bin/nexus.vmoptions

VOLUME $NEXUS_DATA
EXPOSE 8081

CMD ./bin/nexus run
