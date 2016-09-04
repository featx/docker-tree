#++++++++++++++++++++++++++++++++++++++
# Courier Docker container in CentOS7
#++++++++++++++++++++++++++++++++++++++

FROM centos:7.2.1511
LABEL vendor=Glad.so
MAINTAINER Palmtale <m@glad.so>

ENV COURIER_HOME=/usr/local \
    COURIER_VERSION=0.76.2 \
    MAIL_USER=mail \
    MAIL_GROUP=mail \

COPY /

RUN set -ex \
    && yum install make gcc gcc-c++ libc-devel linux-headers perl-devel perl   
EXPOSE 965 456 23
VOLUME [""]
ENTRYPOINT [""]
CMD [""]
