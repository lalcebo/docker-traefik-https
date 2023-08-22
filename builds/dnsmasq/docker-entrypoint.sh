#!/usr/bin/env sh

/usr/local/bin/commons.sh # common functions

# run
echo "$(datetime) INFO docker container started"
exec "$@"
