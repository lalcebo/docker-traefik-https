#!/usr/bin/env bash

# shellcheck disable=SC2046
# shellcheck disable=SC2002

# Get config variables from .env file.
export $(cat .env | grep -v ^# | xargs)

read -p "You want to build the images, will this take a while? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    echo '---------------------------------------------------------------------------'
    echo '--- Building Images'
    echo '---------------------------------------------------------------------------'

    # Base
    docker build -t "$DOCKER_REGISTRY"/opensuse-base -f builds/openSUSE_Base.dockerfile builds/

    # Apache
    docker build -t "${DOCKER_REGISTRY}/php-7.4-apache2" -f builds/php-7.4-apache2/Dockerfile builds/
    docker build -t "${DOCKER_REGISTRY}/php-8.0-apache2" -f builds/php-8.0-apache2/Dockerfile builds/
    docker build -t "${DOCKER_REGISTRY}/php-8.1-apache2" -f builds/php-8.1-apache2/Dockerfile builds/
fi
