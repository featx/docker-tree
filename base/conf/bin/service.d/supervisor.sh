#!/usr/bin/env bash

exec supervisord -c /usr/local/etc/supervisor.conf --logfile /dev/null --pidfile /dev/null --user root
