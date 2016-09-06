#++++++++++++++++++++++++++++++++++++++
# OpenLDAP Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV OLDAP_HOME=/usr/local \
    OLDAP_DATA=/mnt \
    OLDAP_DOMAIN="dc=glad,dc=so" \
    OLDAP_USER=ldap \
    OLDAP_GROUP=ldap

COPY entry /usr/bin/
RUN set -x \
    && apk add -U build-base wget ca-certificates db-dev groff \




WORKDIR $OLDAP_HOME
EXPOSE 389
ENTRYPOINT ["entry"]
CMD ["slapd", "-u", "ldap", "-g", "ldap"]
