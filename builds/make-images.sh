#!/usr/bin/env bash

# shellcheck disable=SC2046
# shellcheck disable=SC2002

# get config variables from .env file & set docker registry
export $(cat <.env | grep -v ^# | xargs)
export BUILD_PLATFORM=${BUILD_PLATFORM:-"linux/amd64,linux/arm64"}
export DOCKER_REGISTRY=${DOCKER_REGISTRY:-"ghcr.io/lalcebo"}

# images
IMAGES="
    dnsmasq
    php:7.2-fpm-alpine-nginx
    php:7.4-fpm-alpine-nginx
    php:8.0-fpm-alpine-nginx
    php:8.2-fpm-alpine-nginx
    php:8.3-fpm-alpine-nginx
"

# options
OPTIONS=""

read -p "You want to build the images, will this take a while? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo
    read -p "You want to push the images after build? " -n 1 -r
    echo
    echo 'Building images...'
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        OPTIONS="--push"
    fi
    for IMAGE in $IMAGES; do
        docker buildx build $OPTIONS --provenance false --platform "$BUILD_PLATFORM" -t "$DOCKER_REGISTRY/$IMAGE" -f "builds/$(echo "$IMAGE" | tr ':' '-')/Dockerfile" builds/
    done
fi
