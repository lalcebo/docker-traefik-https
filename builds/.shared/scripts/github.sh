#!/usr/bin/env bash

# include common functions
. /functions.sh

# github auth
if [[ -n ${GITHUB_TOKEN} &&  -n $(command -v git) ]]; then
    echo "$(datetime) generating git config and credentials file in ${HOME}"
    echo -e "[credential]\n\thelper = store --file ~/.git-credentials" > ~/.gitconfig
    echo "https://${GITHUB_TOKEN}:x-oauth-basic@github.com" > ~/.git-credentials
fi
