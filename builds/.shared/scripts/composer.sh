#!/usr/bin/env bash

# include common functions
. /functions.sh

# composer auth
if [[ -n ${GITHUB_TOKEN} && -n $(command -v composer) ]]; then
    echo "$(datetime) INFO set global github auth to composer."
    composer -q global config github-oauth.github.com "$GITHUB_TOKEN"
fi
