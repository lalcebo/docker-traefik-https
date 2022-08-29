#!/usr/bin/env sh

# shellcheck disable=SC2039
# shellcheck disable=SC2206

# Services
SERVICES=($ENABLE_SERVICES)
for i in "${SERVICES[@]}"; do
    COMPOSE_FILE=${COMPOSE_FILE}${PATH_SEPARATOR}./services/${i}.yml
done
