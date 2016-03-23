#++++++++++++++++++++++++++++++++++++++
# CentOS 7 Hub Docker container
#++++++++++++++++++++++++++++++++++++++

FROM soglad/base:centos7
MAINTAINER palmtale<m@glad.so>
LABEL vendor=Glad.so

ENV WEB_ALIAS_DOMAIN   *.vm
ENV CONF_HOME /usr/local
ENV GOROOT_BOOTSTRAP=/usr
ENV GOROOT=/usr/local/src/github.com/golang/go
ENV GOPATH=/usr/local

#Install golang 1.4.x
RUN /usr/local/bin/yum-install golang

# Compile and Install go 1.6
WORKDIR $CONF_HOME/src/github.com/golang
RUN git clone https://github.com/golang/go.git
WORKDIR $GOROOT
RUN git checkout release-branch.go1.6
WORKDIR $GOROOT/src
RUN ./make.bash
RUN export PATH=$PATH:$GOROOT/bin

VOLUME ['/data/hubs']
# Git to solve the dependencies
WORKDIR $CONF_HOME/src/golang.org/x
RUN git clone https://github.com/golang/net.git
RUN git clone https://github.com/golang/crypto.git
RUN git clone https://github.com/golang/text.git
WORKDIR $CONF_HOME/src/golang.org/x/net
RUN git checkout release-branch.go1.6

#Install gogits/gogs
WORKDIR $CONF_HOME
RUN go get github.com/gogits/gogs
EXPOSE 9009

#Install docker/distribution
RUN go get github.com/docker/distribution
EXPOSE 9010
