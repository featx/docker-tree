#++++++++++++++++++++++++++++++++++++++
# SonarQube Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM java:8-jre-alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<palmtale@glad.so>

ENV SONAR_VERSION=6.6 \
    SONARQUBE_HOME=/usr/local \
    SONARQUBE_DATA=/mnt/sonarqube 

RUN set -x \
    && apk add --no-cache gnupg unzip curl \
    && mkdir -p $SONARQUBE_HOME/bin $SONARQUBE_HOME/lib $SONARQUBE_HOME/web \
    
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
    && mkdir -p /tmp/sonarqube/ \
    && mv sonarqube/extensions /tmp/sonarqube/ \
    && apk del gnupg unzip curl \
    && rm -rf sonarqube* /root/.gnupg /var/cache/apk/* \
    && echo -e '#!/bin/sh\n\
\n\
set -e\n\
\n\
if [ "${1:0:1}" != '-' ]; then\n\
  exec "$@"\n\
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
exec java -jar $SONARQUBE_HOME/lib/sonar-application-$SONAR_VERSION.jar\n\
  -server -Xmx512m -Xms128m -XX:MaxPermSize=160m -XX:+HeapDumpOnOutOfMemoryError\n\
  -Djava.net.preferIPv4Stack=true\n\
  "$@"' >> $SONARQUBE_HOME/bin/entry \
    && chmod u+x $SONARQUBE_HOME/bin/entry

VOLUME $SONARQUBE_DATA
WORKDIR $SONARQUBE_HOME
EXPOSE 9000
ENTRYPOINT ["./bin/entry"]
