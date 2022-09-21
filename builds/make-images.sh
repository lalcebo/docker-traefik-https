#!/usr/bin/env bash

# shellcheck disable=SC2046
# shellcheck disable=SC2002

# common scripts
. ./scripts/common.sh

read -p "You want to build the images, will this take a while? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    echo '---------------------------------------------------------------------------'
    echo '--- Building Images'
    echo '---------------------------------------------------------------------------'
    # base
    docker build -t "${DOCKER_REGISTRY}/opensuse-base" -f builds/Dockerfile builds/
    # php cli
    docker build -t "${DOCKER_REGISTRY}/php-7.4-cli" -f builds/php-7.4-cli/Dockerfile builds/
    docker build -t "${DOCKER_REGISTRY}/php-8.0-cli" -f builds/php-8.0-cli/Dockerfile builds/
    docker build -t "${DOCKER_REGISTRY}/php-8.1-cli" -f builds/php-8.1-cli/Dockerfile builds/
    # apache
    docker build -t "${DOCKER_REGISTRY}/php-7.4-apache" -f builds/php-7.4-apache/Dockerfile builds/
    docker build -t "${DOCKER_REGISTRY}/php-8.0-apache" -f builds/php-8.0-apache/Dockerfile builds/
    docker build -t "${DOCKER_REGISTRY}/php-8.1-apache" -f builds/php-8.1-apache/Dockerfile builds/
    # nginx
    docker build -t "${DOCKER_REGISTRY}/php-8.1-nginx" -f builds/php-8.1-nginx/Dockerfile builds/
    # others
    docker build -t "${DOCKER_REGISTRY}/dnsmasq" -f builds/dnsmasq/Dockerfile builds/
fi
