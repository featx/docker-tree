#++++++++++++++++++++++++++++++++++++++
# SonarQube Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM java:8-jre-alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV SONAR_VERSION=5.5 \
    SONARQUBE_HOME=/usr/local/sonarqube

RUN set -x \
    && apk add --no-cache gnupg unzip curl \
    # pub   2048R/D26468DE 2015-05-25
    #       Key fingerprint = F118 2E81 C792 9289 21DB  CAB4 CFCA 4A29 D264 68DE
    # uid                  sonarsource_deployer (Sonarsource Deployer) <infra@sonarsource.com>
    # sub   2048R/06855C1D 2015-05-25
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE \
    && cd /usr/local \
    && curl -o sonarqube.zip -fSL https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && curl -o sonarqube.zip.asc -fSL https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && rm sonarqube.zip* \
    && mv $SONARQUBE_HOME/bin/linux-x86-64/lib/libwrapper.so $SONARQUBE_HOME/ \
    && mv $SONARQUBE_HOME/bin/linux-x86-64/wrapper $SONARQUBE_HOME/ \
    && rm -rf $SONARQUBE_HOME/conf/* \
    && rm -rf $SONARQUBE_HOME/bin/* \
    && mkdir $SONARQUBE_HOME/bin/lib \
    && mv $SONARQUBE_HOME/wrapper $SONARQUBE_HOME/bin/ \
    && mv $SONARQUBE_HOME/libwrapper.so $SONARQUBE_HOME/bin/lib/ \
    && apk del gnupg unzip curl

VOLUME ["$SONARQUBE_HOME/data", "$SONARQUBE_HOME/extensions"]

COPY conf/* $SONARQUBE_HOME/conf/
COPY bin/sonar.sh $SONARQUBE_HOME/bin/
WORKDIR $SONARQUBE_HOME
EXPOSE 9000
ENTRYPOINT ["./bin/sonar.sh"]
