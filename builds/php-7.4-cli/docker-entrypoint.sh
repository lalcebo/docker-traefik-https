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
echo "        PHP 7.4 CLI (openSUSE/Leap)"
echo
echo $(tput sgr0)

/docker.sh # docker gateway
/github.sh # gitHub auth
/composer.sh # composer auth

# run
echo "[ENTRYPOINT INFO]: Docker container started."
exec "$@"
