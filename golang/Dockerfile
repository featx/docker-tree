#++++++++++++++++++++++++++++++++++++++
# Alpine 3 Golang Docker container
#++++++++++++++++++++++++++++++++++++++

FROM soglad/base:alpine3
MAINTAINER palmtale<m@glad.so>
LABEL vendor=Glad.so

ENV WEB_ALIAS_DOMAIN   *.vm
ENV CONF_HOME /usr/local

ENV GOROOT_BOOTSTRAP=$CONF_HOME/src/github.com/golang/go1.4
ENV GOROOT=$CONF_HOME/src/github.com/golang/go
ENV GOPATH=$CONF_HOME

RUN /usr/local/bin/apk-install gcc make

# Compile and Install go 1.6
WORKDIR $CONF_HOME/src/github.com/golang
RUN git clone https://github.com/golang/go.git
RUN cp -r go go1.4
WORKDIR $CONF_HOME/src/github.com/golang/go1.4
RUN git checkout release-branch.go1.4
WORKDIR $CONF_HOME/src/github.com/golang/go1.4/src
RUN ./make.bash
WORKDIR $GOROOT
RUN git checkout release-branch.go1.6
WORKDIR $GOROOT/src
RUN ./make.bash
ENV PATH $PATH:$GOROOT/bin

# Git to solve the dependencies
WORKDIR $CONF_HOME/src/golang.org/x
RUN git clone https://github.com/golang/net.git
RUN git clone https://github.com/golang/crypto.git
RUN git clone https://github.com/golang/text.git
WORKDIR $CONF_HOME/src/golang.org/x/net
RUN git checkout release-branch.go1.6
