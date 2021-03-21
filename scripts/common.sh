#!/usr/bin/env sh

# shellcheck disable=SC2046
# shellcheck disable=SC2002
# shellcheck disable=SC2034

# Load commons functions
. ./scripts/functions.sh

# Initialize vars
COMPOSE_FILE=''

# Get config variables from .env file.
export $(cat .env | grep -v ^# | xargs)

# Set delimiter values for looping through services to pull.
IFS=","

if [ -z "${COMPOSE_FILE}" ]; then
    echo 'Missing env var COMPOSE_FILE, see https://docs.docker.com/compose/reference/envvars/#compose_file'
    exit 1
fi

# Calculate path separator
isWinPlatform && PATH_SEPARATOR=';' || PATH_SEPARATOR=':'

#  Fix .env file for unix format
dos2unix -q .env
