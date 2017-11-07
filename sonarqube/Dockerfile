#++++++++++++++++++++++++++++++++++++++
# SonarQube Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM java:8-jre-alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<palmtale@glad.so>

ENV GOSU_VERSION=1.10 \
    SONAR_VERSION=6.6 \
    SONARQUBE_HOME=/usr/local \
    SONARQUBE_DATA=/mnt/sonarqube 

RUN set -x \
    && addgroup -g 1000 sonar && adduser -G sonar -u 1000 -s /sbin/nologin -D -H sonar \
    && apk add --no-cache gnupg unzip curl wget ca-certificates \
    && mkdir -p $SONARQUBE_HOME/bin $SONARQUBE_HOME/lib $SONARQUBE_HOME/web \

     # Grab gosu for easy step-down from root
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver pgp.mit.edu --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    
    && cd $SONARQUBE_HOME \
    && curl -o sonarqube.zip -fSL https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && curl -o sonarqube.zip.asc \
            -fSL https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc\
    && gpg --keyserver pgp.mit.edu --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && mv sonarqube/lib/* ./lib/ \
    && mv sonarqube/web/* ./web/ \
    && mv sonarqube/elasticsearch ./ \
    && sed -i '1s/bash/sh/' ./elasticsearch/bin/elasticsearch \
    && mkdir -p /tmp/sonarqube/ \
    && mv sonarqube/extensions /tmp/sonarqube/ \
    && apk del gnupg unzip wget ca-certificates \
    && rm -rf sonarqube* /root/.gnupg /var/cache/apk/* \
    && echo -e '#!/bin/sh\n\
\n\
set -e\n\
\n\
if [ "${1:0:1}" = '-' ]; then\n\
    set -- sonar "$@"\n\
fi\n\
\n\
if [ ! -d $SONARQUBE_DATA/extensions ]; then\n\
    cp -r /tmp/sonarqube/extensions $SONARQUBE_DATA/\n\
fi\n\
\n\
if [ ! -d $SONARQUBE_DATA/conf ]; then\n\
    mkdir -p $SONARQUBE_DATA/conf\n\
    echo -e "sonar.jdbc.url=jdbc:h2:tcp://localhost:9092/sonar\n\
sonar.jdbc.username=sonar\n\
sonar.jdbc.password=sonar" >> $SONARQUBE_DATA/conf/sonar.properties\n\
fi\n\
\n\
if [ ! -d $SONARQUBE_DATA/data ]; then\n\
    mkdir -p $SONARQUBE_DATA/data $SONARQUBE_DATA/logs $SONARQUBE_DATA/temp\n\
fi\n\
\n\
rm -rf $SONARQUBE_HOME/extensions $SONARQUBE_HOME/conf $SONARQUBE_HOME/data $SONARQUBE_HOME/logs $SONARQUBE_HOME/temp\n\
ln -s $SONARQUBE_DATA/extensions $SONARQUBE_HOME/\n\
ln -s $SONARQUBE_DATA/conf $SONARQUBE_HOME/\n\
ln -s $SONARQUBE_DATA/data $SONARQUBE_HOME/\n\
ln -s $SONARQUBE_DATA/logs $SONARQUBE_HOME/\n\
ln -s $SONARQUBE_DATA/temp $SONARQUBE_HOME/\n\
\n\
chown -R sonar:sonar $SONARQUBE_HOME $SONARQUBE_DATA\n\
\n\
if [ "$1" = './bin/nexus' -a "$(id -u)" = '0' ]; then\n\
    exec gosu sonar java -jar $SONARQUBE_HOME/lib/sonar-application-$SONAR_VERSION.jar -server -Xmx512m -Xms128m -XX:MaxPermSize=160m -XX:+HeapDumpOnOutOfMemoryError -Djava.net.preferIPv4Stack=true "$@"\n\
else\n\
    exec java -jar $SONARQUBE_HOME/lib/sonar-application-$SONAR_VERSION.jar -server -Xmx512m -Xms128m -XX:MaxPermSize=160m -XX:+HeapDumpOnOutOfMemoryError -Djava.net.preferIPv4Stack=true "$@"\n\
fi' >> $SONARQUBE_HOME/bin/entry \
    && chmod u+x $SONARQUBE_HOME/bin/entry

VOLUME $SONARQUBE_DATA
WORKDIR $SONARQUBE_HOME
EXPOSE 9000
HEALTHCHECK –interval=10s –timeout=3s –retries=3 CMD curl http://127.0.0.1:9000/
ENTRYPOINT ["./bin/entry"]
