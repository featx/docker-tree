#!/bin/sh

set -e

mkdir -p /mnt/app /mnt/etc /mnt/lib

if [ ! -f /mnt/etc/php-fpm.conf ]; then
    rm -rf /mnt/etc/* /mnt/lib/*
    cp -r /usr/local/etc/* /mnt/etc/
    rm -rf /usr/local/etc
    ln -s /usr/local/etc /mnt/etc
    cp -r $PHP_HOME/lib/php/extensions/debug-non-zts-20131226/* /mnt/lib/
    rm -rf $PHP_HOME/lib/php/extensions/debug-non-zts-20131226
    ln -s $PHP_HOME/lib/php/extensions/debug-non-zts-20131226 /mnt/lib
    mv /mnt/etc/php-fpm.conf.default /mnt/etc/php-fpm.conf
fi

exec "$@"
