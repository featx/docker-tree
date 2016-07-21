#!/bin/sh
mkdir -p /var/logs /var/conf /var/apps

if [ ! -f /var/conf/nginx.conf ]; then
    mv /tmp/conf/*  /var/conf/
fi

nginx
