#!/usr/bin/env sh

# common functions
. /usr/local/bin/docker-functions.sh

if [ -n "$(command -v composer)" ]; then
    echo "$(datetime) INFO set global PHP composer home directory"
    mkdir -p "$COMPOSER_HOME"

    # composer auth
    if [ -n "$GITHUB_TOKEN" ]; then
        echo "$(datetime) INFO set global github auth to PHP composer"
        composer -q global config github-oauth.github.com "$GITHUB_TOKEN"
    fi

    # owner & permissions
    chgrp -R users "$COMPOSER_HOME"
    chmod -R ugo+rw "$COMPOSER_HOME"
fi
