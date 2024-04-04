#!/usr/bin/env sh

# common functions
. /usr/local/bin/docker-functions.sh

# npm
if [ -n "$(command -v npm)" ]; then
    echo "$(datetime) INFO set global NPM home directory"
    mkdir -p "$NPM_HOME"
    npm config set cache "$NPM_HOME" --global

    # owner & permissions
    chgrp -R users "$NPM_HOME"
    chmod -R ugo+rw "$NPM_HOME"
fi
