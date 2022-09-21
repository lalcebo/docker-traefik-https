#!/usr/bin/env bash

# include common functions
. /functions.sh

# fix linux internal host
if [[ -n $(command -v ping) ]]; then
    DOCKER_INTERNAL_HOST="host.docker.internal"
    ping -q -c1 ${DOCKER_INTERNAL_HOST} > /dev/null 2>&1 || EXIT_CODE=$?
    if [[ ${EXIT_CODE} -eq 2 ]]; then
      HOST_IP=$(ip route | awk 'NR==1 {print $3}')
      echo -e "$HOST_IP\t$DOCKER_INTERNAL_HOST" >> /etc/hosts
      echo "$(datetime) added $DOCKER_INTERNAL_HOST to /etc/hosts"
    fi
fi
