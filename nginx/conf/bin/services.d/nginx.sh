#!/usr/bin/env bash
set -e

if [[ ! -e "$WEB_DOCUMENT_ROOT" ]]; then
    echo ""
    echo "[WARNING] WEB_DOCUMENT_ROOT does not exists with path \"$WEB_DOCUMENT_ROOT\"!"
    echo ""
fi

rpl --quiet "<DOCUMENT_INDEX>" "$WEB_DOCUMENT_INDEX" $CONF_HOME/etc/nginx/*.conf
rpl --quiet "<DOCUMENT_ROOT>"  "$WEB_DOCUMENT_ROOT"  $CONF_HOME/etc/nginx/*.conf
rpl --quiet "<ALIAS_DOMAIN>"   "$WEB_ALIAS_DOMAIN"   $CONF_HOME/etc/nginx/*.conf
rpl --quiet "<SERVERNAME>"     "$HOSTNAME"           $CONF_HOME/etc/nginx/*.conf

exec /usr/sbin/nginx
