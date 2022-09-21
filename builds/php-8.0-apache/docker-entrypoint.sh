#!/usr/bin/env bash

# shellcheck disable=SC2046
# shellcheck disable=SC2005

set -e

echo $(tput bold)
echo
echo "                    >'?'<"
echo "                  ª( o o )ª"
echo "----------------ooOO-(_)-OOoo-----------------"
echo ""
echo "       APACHE2/PHP 8.0 (openSUSE/Leap)"
echo
echo $(tput sgr0)

# include common functions
. /functions.sh

# run
/docker.sh # docker gateway
/github.sh # gitHub auth
/composer.sh # composer auth

echo "$(datetime) INFO docker container started"
exec "$@"
