#!/usr/bin/env sh

# shellcheck disable=SC2015
# shellcheck disable=SC2006

# Initialize script
. ./initscripts.sh

if [ -n "$1" ] && [ -n "`docker-compose ps --services | grep "$1"`" ]; then
    echo
    echo '---------------------------------------------------------------------------'
    echo '--- Get Container Shell'
    echo '---------------------------------------------------------------------------'
    echo
    isWinPlatform && winpty docker-compose exec "$1" bash || docker-compose exec "$1" bash
else
     if [ -n "$1" ]; then
        echo
        echo "Container \"$1\" is not running."
        echo
     else
        echo
        echo 'You need pass a container name on the first param.'
        echo
    fi
fi
