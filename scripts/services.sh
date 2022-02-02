#!/usr/bin/env sh

# shellcheck disable=SC2039
# shellcheck disable=SC2206

# Applications
APPS=($ENABLE_APPS)
for i in "${APPS[@]}"; do
    COMPOSE_FILE=${COMPOSE_FILE}${PATH_SEPARATOR}./apps/${i}.yml
done

# Servers
SERVERS=($ENABLE_SERVERS)
for i in "${SERVERS[@]}"; do
    if [ "$i" = "dynamodb" ] && [ ! -d .docker/dynamodb ]; then
        mkdir -p .docker/dynamodb && chmod -R 777 .docker/dynamodb
    fi
    COMPOSE_FILE=${COMPOSE_FILE}${PATH_SEPARATOR}./servers/${i}.yml
done
