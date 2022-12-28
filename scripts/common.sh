#!/usr/bin/env sh

# shellcheck disable=SC2046
# shellcheck disable=SC2002
# shellcheck disable=SC2034

# load commons functions
. ./scripts/functions.sh

# initialize vars
COMPOSE_FILE=""

# get config variables from .env file & set docker registry
export $(cat .env | grep -v ^# | xargs)
export BUILD_PLATFORM=${BUILD_PLATFORM:-"linux/amd64,linux/arm64"}
export DOCKER_REGISTRY=${DOCKER_REGISTRY:-"ghcr.io/lalcebo/docker-traefik-https"}

# set delimiter values for looping through services to pull
IFS=","

if [ ${#ROOT_PASSWORD} -lt 8 ]; then
    echo "Root password value length should be at least 8 characters"
    exit 1
fi

if [ -z "${COMPOSE_FILE}" ]; then
    echo "Missing env var COMPOSE_FILE, see https://docs.docker.com/compose/reference/envvars/#compose_file"
    exit 1
fi

# calculate path separator
isWinPlatform && PATH_SEPARATOR=";" || PATH_SEPARATOR=":"

#  fix .env file for unix format
isWinPlatform && dos2unix -q .env
