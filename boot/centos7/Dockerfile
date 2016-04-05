#++++++++++++++++++++++++++++++++++++++
# CentOS 7 Boot Docker container
#++++++++++++++++++++++++++++++++++++++

FROM centos:7.2.1511
MAINTAINER Palm Tale <m@glad.so>
LABEL vendor=Glad.So

ADD scripts.tar /

# Init bootstrap
RUN set -x \
    # Fix root terminal
    && echo "export TERM=xterm" >> /root/.bashrc \
    # System update
    && /usr/local/bin/yum-upgrade \
