#!/usr/bin/env sh

# shellcheck disable=SC2039

# common functions
. /usr/local/bin/commons.sh

# docker internal host
if [ -n "$(command -v ping)" ]; then
    DOCKER_INTERNAL_HOST="host.docker.internal"
    ping -q -c1 host.docker.internal >/dev/null 2>&1
    if [ $? -eq 1 ]; then
        HOST_IP=$(ip route | awk 'NR==1 {print $3}')
        echo -e "$HOST_IP\t$DOCKER_INTERNAL_HOST" >>/etc/hosts
        echo "$(datetime) INFO added $DOCKER_INTERNAL_HOST to /etc/hosts"
    fi
fi
