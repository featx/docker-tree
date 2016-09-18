#++++++++++++++++++++++++++++++++++++++
# Courier Docker container in CentOS7
#++++++++++++++++++++++++++++++++++++++

FROM opensuse:42.1
LABEL vendor=Glad.so
MAINTAINER Palmtale <m@glad.so>

ENV COURIER_HOME=/usr/local \
    COURIER_VERSION=0.76.2 \
    MAIL_USER=mail \
    MAIL_GROUP=mail \

COPY /

RUN set -ex \
    && zypper in make gcc gcc-c++ libc-devel linux-headers perl-devel perl
EXPOSE 965 456 23
VOLUME [""]
ENTRYPOINT [""]
CMD [""]
