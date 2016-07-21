#!/bin/sh

set -e

mkdir -p /mnt/log /mnt/etc /mnt/app

if [ ! -f /mnt/etc/nginx.conf ]; then
    cp -r /tmp/etc/*  /mnt/etc/
fi

exec "$@"
