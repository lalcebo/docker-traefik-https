#!/usr/bin/env bash

# shellcheck disable=SC2046
# shellcheck disable=SC2002

# common scripts
. ./scripts/common.sh

echo
echo '---------------------------------------------------------------------------'
echo '--- Pushing Images'
echo '---------------------------------------------------------------------------'

# cli
docker push "${DOCKER_REGISTRY}/php-7.4-cli:latest"
docker push "${DOCKER_REGISTRY}/php-8.0-cli:latest"
docker push "${DOCKER_REGISTRY}/php-8.1-cli:latest"
# apache
docker push "${DOCKER_REGISTRY}/php-7.4-apache:latest"
docker push "${DOCKER_REGISTRY}/php-8.0-apache:latest"
docker push "${DOCKER_REGISTRY}/php-8.1-apache:latest"
# nginx
docker push "${DOCKER_REGISTRY}/php-8.1-nginx:latest"
# others
docker push "${DOCKER_REGISTRY}/dnsmasq:latest"
