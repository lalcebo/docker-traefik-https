#!/usr/bin/env sh

# npm
if [ -n "$(command -v npm)" ]; then
    echo "$(datetime) INFO set global NPM home directory"
    mkdir -p "$NPM_HOME"
    npm config set cache "$NPM_HOME" --global
    # permissions
    chmod -R ugo+rw "$NPM_HOME"
fi
