#!/bin/sh
mkdir -p ${BASE_DIR}/log ${DATA_DIR} /var/run/mysqld
chown -R mysql:mysql ${BASE_DIR} /var/run/mysqld

if [ ! -f ${BASE_DIR}/my.cnf ]; then
    mv /etc/mysql/my.cnf  ${BASE_DIR}/
    rm -rf /etc/mysql/my.cnf
    ln -s ${BASE_DIR}/my.cnf /etc/mysql/my.cnf
    chmod o-r /etc/mysql/my.cnf
fi

if [ ! -f ${DATA_DIR}/ibdata1 ]; then

    mysql_install_db --user=mysql --datadir="${DATA_DIR}"

    mysqld_safe --defaults-file=${BASE_DIR}/my.cnf &
    sleep 10s

		#Changed mysql_secure_installation script to running only the commands.
		echo "UPDATE mysql.user SET Password=PASSWORD('${DB_ROOT_PASS}') WHERE User='root'; DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1'); DELETE FROM mysql.user WHERE User=''; DROP DATABASE test; FLUSH PRIVILEGES;" | mysql -u root
    echo "GRANT ALL ON *.* TO ${DB_USER}@'127.0.0.1' IDENTIFIED BY '${DB_PASS}' WITH GRANT OPTION; GRANT ALL ON *.* TO ${DB_USER}@'localhost' IDENTIFIED BY '${DB_PASS}' WITH GRANT OPTION; GRANT ALL ON *.* TO ${DB_USER}@'::1' IDENTIFIED BY '${DB_PASS}' WITH GRANT OPTION; FLUSH PRIVILEGES;" | mysql -u root --password="${DB_ROOT_PASS}"

    killall mysqld
    killall mysqld_safe
    sleep 10s
    killall -9 mysqld
    killall -9 mysqld_safe
fi

mysqld --user=mysql
