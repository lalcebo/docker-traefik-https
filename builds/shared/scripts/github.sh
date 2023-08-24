#!/usr/bin/env sh

# shellcheck disable=SC2030
# shellcheck disable=SC2039

# common functions
. /usr/local/bin/commons.sh

# github auth
if [ -n "$GITHUB_TOKEN" ] && [ -n "$(command -v git)" ]; then
    echo "$(datetime) INFO generating git config and credentials file in ${HOME}"
    echo -e "[credential]\n\thelper = store --file ~/.git-credentials" >~/.gitconfig
    echo "https://$GITHUB_TOKEN:x-oauth-basic@github.com" >~/.git-credentials
fi
