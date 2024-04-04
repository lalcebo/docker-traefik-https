#!/usr/bin/env sh

# common functions
. /usr/local/bin/docker-functions.sh

# run
echo "$(datetime) INFO docker container started"
exec "$@"
