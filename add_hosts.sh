#!/usr/bin/env sh

# shellcheck disable=SC2039
# shellcheck disable=SC2046
# shellcheck disable=SC2164

cd $(dirname $(readlink -f "$0"))

# Load commons functions
. ./scripts/functions.sh

# Get config variables from .env file.
export $(grep -v ^# <.env | xargs)

# Calculate path for host file
isWinPlatform && HOSTS_PATH='/c/Windows/System32/drivers/etc/hosts' || HOSTS_PATH='/etc/hosts'

# Get all projects yml files with VIRTUAL_HOSTS env
# shellcheck disable=SC2039
# shellcheck disable=SC2207
SERVICES=($(find apps/ servers/ -name \*.yml -type f))

# shellcheck disable=SC2068
for FILE in docker-compose.yml docker-compose-local.yml ${SERVICES[@]}; do
    if [ -f "$FILE" ]; then
        HOSTS=$(grep -oP "Host\(\`(.*)\`\)" <"$FILE" | sed s/Host//g | sed -E "s/\`|\(|\)//g" | tr "," "\n")
        for HOST in "${HOSTS[@]}"; do
            if [ "$(grep -P "(^|\s)\K($(echo "$HOST" | sed 's/*/\\\\*/g'))(?=\s|$)" ${HOSTS_PATH})" = "" ]; then
                printf "Add New Hostname: %s\n" "$HOST"
                printf "%s\t%s\n" "127.0.0.1" "$HOST" | tee -a "$HOSTS_PATH" > /dev/null
            fi
        done
    fi
done
