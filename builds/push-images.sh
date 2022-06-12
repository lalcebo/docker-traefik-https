#!/usr/bin/env bash

# shellcheck disable=SC2046
# shellcheck disable=SC2002

# Get config variables from .env file.
export $(cat .env | grep -v ^# | xargs)

echo
echo '---------------------------------------------------------------------------'
echo '--- Pushing Images'
echo '---------------------------------------------------------------------------'

# Apache
docker push "${DOCKER_REGISTRY}/php-7.4-apache2:latest"
docker push "${DOCKER_REGISTRY}/php-8.0-apache2:latest"
docker push "${DOCKER_REGISTRY}/php-8.1-apache2:latest"
