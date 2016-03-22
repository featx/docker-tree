#++++++++++++++++++++++++++++++++++++++
# CentOS 7 Base Docker container
#++++++++++++++++++++++++++++++++++++++

FROM soglad/boot:centos7
MAINTAINER palmtale<m@glad.so>
LABEL vendor=Glad.so

ENV APPLICATION_USER  soglad
ENV APPLICATION_GROUP soglad
ENV APPLICATION_UID   1000
ENV APPLICATION_GID   1000
ENV CONF_HOME  /usr/local/

# Install services
RUN /usr/local/bin/yum-install \
        cronie \
        supervisor \
        syslog-ng \
        logrotate \
        openssh-server \
        dnsmasq \
        postfix

# Install tools
RUN /usr/local/bin/yum-install \
        sudo \
        zip \
        unzip \
        bzip2 \
        wget \
        curl \
        net-tools \
        rsync \
        git \
        vim

# Deploy scripts/configurations
COPY conf/ $CONF_HOME
RUN bash $CONF_HOME/bin/control.sh provision.role soglad-base \
    && bash $CONF_HOME/bin/control.sh provision.role.finish soglad-cleanup \
    && bash $CONF_HOME/bin/bootstrap.sh

ENTRYPOINT ["$CONF_HOME/bin/entrypoint.sh"]
CMD ["noop"]
