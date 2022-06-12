#!/usr/bin/env bash

# Composer Auth
if [[ -n ${GITHUB_TOKEN} && -n ${command -v composer} ]]; then
    echo "[ENTRYPOINT INFO]: Set global GitHub auth to PHP composer."
    composer -q global config github-oauth.github.com "$GITHUB_TOKEN"
fi
