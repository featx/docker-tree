FROM alpine AS builder

ENV ES_HOME /usr/share/elasticsearch \
    PATH $ES_HOME/bin:$PATH

RUN set -ex && \
    apk add -U unzip && \
    addgroup -g 1000 -S elasticsearch && \
    adduser -u 1000 -D -S -G elasticsearch elasticsearch

WORKDIR $ES_HOME

${source_elasticsearch}

RUN tar zxvf /opt/${elasticsearch} --strip-components=1 && \
    grep ES_DISTRIBUTION_TYPE=tar $ES_HOME/bin/elasticsearch-env && \
    sed -ie 's/ES_DISTRIBUTION_TYPE=tar/ES_DISTRIBUTION_TYPE=docker/' $ES_HOME/bin/elasticsearch-env && \
    mkdir -p config data logs && \
    chmod 0775 config data logs
COPY elasticsearch.yml log4j2.properties config/


FROM alpine
LABEL vendor=Featx
MAINTAINER Excepts <excepts@featx.org>
ENV ELASTIC_HOME /usr/share/elasticsearch \ 
    ELASTIC_CONTAINER true \
    PATH $ELASTIC_HOME/bin:$PATH

WORKDIR $ELASTIC_HOME

COPY --from=builder --chown=1000:1000 /usr/share/elasticsearch /usr/share/elasticsearch
COPY --chown=1000:1000 docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN set -ex && \
    apk add -U nc unzip wget && \ 
    addgroup -g 1000 -S elasticsearch && \
    adduser -u 1000 -D -S -G elasticsearch -d $ELASTIC_HOME elasticsearch && \
    chmod 0775 $ELASTIC_HOME && \
    chgrp 1000 $ELASTIC_HOME && \
    ln -sf /etc/pki/ca-trust/extracted/java/cacerts $ELASTIC_HOME/jdk/lib/security/cacerts && \
    chgrp 1000 /usr/local/bin/docker-entrypoint.sh && \
    chmod g=u /etc/passwd && \
    chmod 0775 /usr/local/bin/docker-entrypoint.sh

EXPOSE 9200 9300

LABEL org.label-schema.schema-version="1.0" \
  org.label-schema.vendor="Elastic" \
  org.label-schema.name="elasticsearch" \
  org.label-schema.version="${version}" \
  org.label-schema.url="https://www.elastic.co/products/elasticsearch" \
  org.label-schema.vcs-url="https://github.com/elastic/elasticsearch" \
  license="${license}"

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["eswrapper"]