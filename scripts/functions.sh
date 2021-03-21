#!/usr/bin/env sh

# shellcheck disable=SC2039

##
# Check if the OS is Microsoft Windows
# @usage isWinPlatform
##
isWinPlatform() {
    [ "$OSTYPE" == 'cygwin' ] || [ "$OSTYPE" == 'msys' ] || [ "$OSTYPE" == 'win32' ]
}
