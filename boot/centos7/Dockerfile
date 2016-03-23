#++++++++++++++++++++++++++++++++++++++
# CentOS 7 Boot Docker container
#++++++++++++++++++++++++++++++++++++++

FROM centos:7.2.1511
MAINTAINER Palm Tale <m@glad.so>
LABEL vendor=Glad.So

ADD scripts.tar /

# Init
RUN set -x \
    # Fix root terminal
    && echo "export TERM=xterm" >> /root/.bashrc \
    # System update
    && /usr/local/bin/yum-upgrade \
    # Generate locales
    && localedef -v -c -i en_HK -f utf8 en_HK.utf8 ; $(exit 0) \
    && localedef -v -c -i en_US -f utf8 en_US.utf8 ; $(exit 0) \
    && localedef -v -c -i ja_JP -f utf8 ja_JP.utf8 ; $(exit 0) \
    && localedef -v -c -i ko_KR -f utf8 ko_KR.utf8 ; $(exit 0) \
    && localedef -v -c -i zh_CN -f utf8 zh_CN.utf8 ; $(exit 0) \
    && localedef -v -c -i zh_HK -f utf8 zh_HK.utf8 ; $(exit 0) \
    && localedef -v -c -i zh_SG -f utf8 zh_SG.utf8 ; $(exit 0) \
    && localedef -v -c -i zh_TW -f utf8 zh_TW.utf8 ; $(exit 0) \
    # Install Something in python
    && /usr/local/bin/yum-install \
        epel-release \
        PyYAML \
        python-httplib2 \
        python-paramiko \
        python-setuptools \
        python-setuptools-devel \
    && easy_install pip
