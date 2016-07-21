#++++++++++++++++++++++++++++++++++++++#
# Mariadb Docker container in Alpine #
# https://mirrors.tuna.tsinghua.edu.cn/mariadb/mariadb-10.1.16/source/mariadb-10.1.16.tar.gz
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
RUN apk -U upgrade && apk -U add mariadb mariadb-client wget \
    && export MIRROR_ROOT = "https://mirrors.tuna.tsinghua.edu.cn/mariadb";
    && wget -O mariadb.tar.gz $MIRROR_ROOT/mariadb-$MY_VERSION/source/mariadb-#MY_VERSION.tar.gz \
    && rm -rf /tmp/src/* /var/cache/apk/* /etc/mysql/my.cnf \
		&& mv $BASE_DIR/my.cnf /etc/mysql/ \
		&& mv $BASE_DIR/mysql.sh /usr/bin/ && chmod u+x /usr/bin/mysql.sh

VOLUME ["/usr/mysql"]
EXPOSE 3306
CMD ["mysql.sh"]
