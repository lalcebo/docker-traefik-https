#!/usr/bin/env bash

# shellcheck disable=SC2046
# shellcheck disable=SC2005

set -e

echo
echo "                    >'?'<"
echo "                  ª( o o )ª"
echo "----------------ooOO-(_)-OOoo-----------------"
echo ""
echo "        PHP 8.2 CLI (openSUSE/Leap)"
echo

# include common functions
. /functions.sh

# run
/docker.sh # docker gateway
/github.sh # gitHub auth
/composer.sh # composer auth

echo "$(datetime) INFO docker container started"
exec "$@"