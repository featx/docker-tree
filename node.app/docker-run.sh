#!/bin/sh

set -e

node-inspector &

if [ -f $APP_HOME/package.json ]; then
	npm install --production
else    
    cp /usr/local/index.js $APP_HOME/
fi

exec "$@"