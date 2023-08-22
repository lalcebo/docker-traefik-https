#!/usr/bin/env sh

# nginx
NGINX_DEFAULT_CONF=${NGINX_DEFAULT_CONF:-"/etc/nginx/http.d/default.conf"}
sed -i "s|{WORKDIR}|$WORKDIR|g" "$NGINX_DEFAULT_CONF"
sed -i "s|{HANDLER}|$HANDLER|g" "$NGINX_DEFAULT_CONF"

/usr/local/bin/commons.sh # common functions
/usr/local/bin/docker.sh # docker
/usr/local/bin/github.sh # github
/usr/local/bin/composer.sh # php composer
/usr/local/bin/npm.sh # nodejs npm

# run
echo "$(datetime) INFO docker container started"
exec "$@"
