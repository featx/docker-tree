#++++++++++++++++++++++++++++++++++++++#
# Mariadb Docker container in Alpine #
#+++++++++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Glad.so
MAINTAINER palmtale<m@glad.so>

ENV BASE_DIR=/usr/mysql \
    DATA_DIR=/usr/mysql/data \
		DB_ROOT_PASS=root \
		DB_USER=soglad \
		DB_PASS=soglad

COPY m* $BASE_DIR/
RUN addgroup -S mysql && adduser -S -g mysql mysql \
    && apk -U upgrade && apk -U add mariadb mariadb-client \
		&& rm -rf /tmp/src/* /var/cache/apk/* /etc/mysql/my.cnf \
		&& mv $BASE_DIR/my.cnf /etc/mysql/ && chmod o-r /etc/mysql/my.cnf \
		&& mv $BASE_DIR/mysql.sh /usr/bin/ && chmod u+x /usr/bin/mysql.sh

#USER mysql
VOLUME ["/usr/mysql"]
EXPOSE 3306
CMD ["mysql.sh"]
