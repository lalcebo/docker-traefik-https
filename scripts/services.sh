#!/usr/bin/env sh

# shellcheck disable=SC2039
# shellcheck disable=SC2206
# shellcheck disable=SC1090

# Applications
APPS=($ENABLE_APPS)
for i in "${APPS[@]}"; do
    # load pre hooks
    if [ -f "./hooks/apps/pre-$i" ]; then
        . "./hooks/apps/pre-$i"
    fi
    COMPOSE_FILE=${COMPOSE_FILE}${PATH_SEPARATOR}./apps/${i}.yml
    # load post hooks
    if [ -f "./hooks/apps/post-$i" ]; then
        . "./hooks/apps/post-$i"
    fi
done

# Servers
SERVERS=($ENABLE_SERVERS)
for i in "${SERVERS[@]}"; do
    # load pre hooks
    if [ -f "./hooks/servers/pre-$i" ]; then
        . "./hooks/servers/pre-$i"
    fi
    COMPOSE_FILE=${COMPOSE_FILE}${PATH_SEPARATOR}./servers/${i}.yml
    # load post hooks
    if [ -f "./hooks/servers/post-$i" ]; then
        . "./hooks/servers/post-$i"
    fi
done
