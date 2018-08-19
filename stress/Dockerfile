#++++++++++++++++++++++++++++++++++++++
#  Stress Docker container in Alpine  #
#++++++++++++++++++++++++++++++++++++++

FROM alpine
LABEL vendor=Glad.so
MAINTAINER Excepts <excepts@glad.so>

ENV GOSU_VERSION=1.10 \
    STRESS_VERSION=1.0.4 \
    STRESS_HOME=/usr/local 

RUN set -x \
    && export STRESS_URL=http://people.seas.harvard.edu/~apw/stress \
    && apk add -U build-base wget \
    && wget ${STRESS_URL}/stress-${STRESS_VERSION}.tar.gz \
    && wget ${STRESS_URL}/stress-${STRESS_VERSION}.tar.gz.sign \
    && tar -zxf stress-${STRESS_VERSION}.tar.gz && mv stress-${STRESS_VERSION} stress \
    && cd stress && ./configure && make && make install && cd .. \
    && apk del build-base wget \
    && rm -rf /var/cache/apk/* stress stress-${STRESS_VERSION}.tar.gz stress-${STRESS_VERSION}.tar.gz.sign
