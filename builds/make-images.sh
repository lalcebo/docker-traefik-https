#!/usr/bin/env bash

# shellcheck disable=SC2046
# shellcheck disable=SC2002

# common scripts
. ./scripts/common.sh

# images
IMAGES=(
    dnsmasq
    mailhog
    php-7.4-cli
    php-8.0-cli
    php-8.1-cli
    php-8.2-cli
    php-7.4-apache
    php-8.0-apache
    php-8.1-apache
    php-8.2-apache
    php-8.1-nginx
)

# options
OPTIONS=""

read -p "You want to build the images, will this take a while? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    echo '---------------------------------------------------------------------------'
    echo '--- Building & Pushing: opensuse-base'
    echo '---------------------------------------------------------------------------'
    docker buildx build --platform "${BUILD_PLATFORM}" -t "${DOCKER_REGISTRY}/opensuse-base" -f builds/Dockerfile builds/
    # build
    read -p "You want to push the images after build? " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        OPTIONS="--push"
    fi
    for i in "${IMAGES[@]}"; do
        echo
        echo '---------------------------------------------------------------------------'
        echo '--- Building & Pushing:' ${i}
        echo '---------------------------------------------------------------------------'
        docker buildx build ${OPTIONS} --platform "${BUILD_PLATFORM}" -t "${DOCKER_REGISTRY}/${i}" -f "builds/${i}/Dockerfile" builds/
    done
fi
