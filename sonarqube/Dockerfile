#++++++++++++++++++++++++++++++++++++++
# SonarQube Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM java:8-jre-alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV SONAR_VERSION=5.6 \
    SONARQUBE_HOME=/usr/local/sonarqube \
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=jdbc:h2:tcp://localhost:9092/sonar

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
    && apk del gnupg unzip curl \
    && rm -rf $SONARQUBE_HOME/conf/* $SONARQUBE_HOME/bin/* /root/.gnupg /var/cache/apk/*


#VOLUME ["$SONARQUBE_HOME/data", "$SONARQUBE_HOME/extensions"]

COPY run.sh $SONARQUBE_HOME/bin/
WORKDIR $SONARQUBE_HOME
EXPOSE 9000
ENTRYPOINT ["./bin/run.sh"]

# invoke: docker run -v /var/data/docker/sonardata:/usr/local/sonarqube/data
#                    -v /var/data/docker/sonarext:/usr/local/sonarqube/extensions
#                    -v /var/data/docker/sonarlogs:/usr/local/sonarqube/logs
# -p xxxx:9000 -p xxxx:9001 --name sonar soglad/sonarqube:alpine start
