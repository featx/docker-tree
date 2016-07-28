#!/bin/sh

set -e

mkdir -p /mnt/etc /mnt/lib

if [ ! -f /mnt/etc/php-fpm.conf ]; then
    rm -rf /mnt/etc/* /mnt/lib/*
    cp -r /tmp/etc/* /mnt/etc/
    cp -r /tmp/lib/* /mnt/lib/
    mv /mnt/etc/php-fpm.conf.default /mnt/etc/php-fpm.conf
fi

rm -rf $PHP_HOME/etc $PHP_HOME/lib/php/extensions/debug-non-zts-20131226
ln -s /mnt/etc $PHP_HOME/etc
ln -s /mnt/lib $PHP_HOME/lib/php/extensions/debug-non-zts-20131226

exec "$@"
