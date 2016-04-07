#++++++++++++++++++++++++++++++++++++++
# Alpine 3 Base Docker container
#++++++++++++++++++++++++++++++++++++++

FROM soglad/boot:alpine3
MAINTAINER Palm Tale <m@glad.so>
LABEL vendor=Glad.So

ENV APP_USER  soglad
ENV APP_GROUP soglad
ENV APP_UID   1000
ENV APP_GID   1000
ENV CONF_HOME  /usr/local

# Install services and tools
RUN /usr/local/bin/apk-install \
        supervisor \
        syslog-ng \
        logrotate \
        wget \
        curl \
        sed \
        python \
        python-dev \
        py-setuptools \
        py-crypto \
        py-pip \
    && pip install --upgrade pip \
    && pip install ansible

# Deploy scripts/configurations
COPY conf/ $CONF_HOME
RUN bash $CONF_HOME/bin/control.sh provision.role soglad-base \
    && bash $CONF_HOME/bin/control.sh provision.role.finish soglad-cleanup \
    && bash $CONF_HOME/bin/bootstrap.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["noop"]
