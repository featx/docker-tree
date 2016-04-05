#++++++++++++++++++++++++++++++++++++++
# Alpine 3 Boot Docker container
#++++++++++++++++++++++++++++++++++++++

FROM alpine:3.3
MAINTAINER Palm Tale <m@glad.so>
LABEL vendor=Glad.So

# Ensure UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# Add scripts
ADD scripts.tar /

# Init bootstrap
RUN set -x \
    # Fix root terminal
    && echo "export TERM=xterm" >> /root/.bashrc \
    # Add testing
    && echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
    # System update
    && /usr/local/bin/apk-upgrade \
    # Install base stuff
    && /usr/local/bin/apk-install \
        bash \
        shadow \
        ca-certificates
