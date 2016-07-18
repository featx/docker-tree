#!/bin/sh
mkdir -p $NGINX_PREFIX/log $NGINX_PREFIX/etc $NGINX_PREFIX/app

if [ ! -f $NGINX_PREFIX/etc/nginx.conf ]; then
    mv /tmp/etc/*  $NGINX_PREFIX/etc/
fi

nginx
