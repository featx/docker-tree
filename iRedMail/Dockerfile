#++++++++++++++++++++++++++++++++++++++
# iRedMail Docker container in CentOS7
#++++++++++++++++++++++++++++++++++++++

FROM centos:7.2.1511
LABEL vendor=Glad.so
MAINTAINER Palmtale <m@glad.so>

ENV IRED_HOME=/usr/local \
    IRED_VERSION=0.9.0 \
    # uid 8 in Centos
    MAIL_USER=mail \
    # gid 12 in Centos
    MAIL_GROUP=mail \
    HOSTNAME=mail.glad.so \
    LDAP_DN="dc=glad,dc=so"

COPY /

RUN set -ex
    # Update hostname
    && echo $HOSTNAME > /etc/hostname && echo $HOSTNAME > /etc/mailname
    && echo "127.0.0.1   $HOSTNAME" > /etc/hosts
    && echo "HOSTNAME=$HOSTNAME" > /etc/sysconfig/network \
    && yum install curl wget ca-certicicates

EXPOSE 25 80 110 143 389 443 587 636 993 995
VOLUME ["/mnt"]
ENTRYPOINT [""]
CMD [""]
