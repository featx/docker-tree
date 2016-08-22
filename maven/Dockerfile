#++++++++++++++++++++++++++++++++++++++
# PHP Docker container in Alpine
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV JAVA_HOME=/usr \
    MVN_HOME=/usr/local/maven

RUN set -x \
    && export MVN_VERSION=3.3.9 \
    && export DLD_MIRROR=http://mirrors.cnnic.cn/apache \
    && apk add --no-cache -U ca-certificates wget openjdk8 \
    # gnupg \
    && wget -O maven.tar.gz $DLD_MIRROR/maven/maven-3/$MVN_VERSION/binaries/apache-maven-$MVN_VERSION-bin.tar.gz \
    && wget -O maven.tar.gz.asc https://www.apache.org/dist/maven/maven-3/$MVN_VERSION/binaries/apache-maven-$MVN_VERSION-bin.tar.gz.asc \
    && echo "516923b3955b6035ba6b0a5b031fbd8b *maven.tar.gz" | md5sum -c - \
#    && export GNUPGHOME=$(mktemp -d) \
#    && gpg --batch --verify maven.tar.gz.asc maven.tar.gz \
    && tar -zxf maven.tar.gz && mv apache-maven-$MVN_VERSION mvn \
    && mkdir -p $MVN_HOME && mv mvn/* $MVN_HOME/ \
    && apk del ca-certificates wget \
    #gnupg \
    && rm -rf mvn /var/cache/apk/* maven.tar.gz maven.tar.gz.asc \
    #$GNUPGHOME \
    && ln -s $MVN_HOME/bin/mvn /usr/bin/mvn \
    && ln -s /mnt /root/.m2

WORKDIR "/usr/local/app"
VOLUME ["/usr/local/app", "/mnt"]
CMD ["mvn"]
