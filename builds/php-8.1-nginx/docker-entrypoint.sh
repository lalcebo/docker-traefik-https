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
echo "         NGINX/PHP 8.1 (openSUSE/Leap)"
echo
echo $(tput sgr0)

/usr/sbin/docker.sh # Main
/usr/sbin/github.sh # GitHub Auth
/usr/sbin/composer.sh # Composer Auth

# Run
echo "[ENTRYPOINT INFO]: Docker container started."
exec "$@"
