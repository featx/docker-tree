#!/bin/sh

set -e

if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

exec java -jar /usr/local/sonarqube/lib/sonar-application-5.5.jar \
  -server -Xmx512m -Xms128m -XX:MaxPermSize=160m -XX:+HeapDumpOnOutOfMemoryError \
  -Djava.net.preferIPv4Stack=true \
  -Dsonar.jdbc.username="$SONARQUBE_JDBC_USERNAME" \
  -Dsonar.jdbc.password="$SONARQUBE_JDBC_PASSWORD" \
  -Dsonar.jdbc.url="$SONARQUBE_JDBC_URL" \
  "$@"
