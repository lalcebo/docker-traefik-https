#!/usr/bin/env sh

/usr/local/bin/docker-service.sh
/usr/local/bin/docker-github.sh
/usr/local/bin/docker-composer.sh
/usr/local/bin/docker-nodejs.sh

# common functions
. /usr/local/bin/docker-functions.sh

# run
echo "$(datetime) INFO docker container started"
exec "$@"
