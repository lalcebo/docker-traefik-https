#!/usr/bin/env sh

# shellcheck disable=SC2039
# shellcheck disable=SC1090

##
# Check if the OS is Microsoft Windows
# @usage isWinPlatform
##
isWinPlatform() {
    [ "$OSTYPE" == 'cygwin' ] || [ "$OSTYPE" == 'msys' ] || [ "$OSTYPE" == 'win32' ]
}

##
# Execute hooks scripts
# @usage executeHooks type $hooks
##
executeHooks() {
    local EVENT=$1
    shift 1
    local HOOKS=($@)
    for this in "${HOOKS[@]}"; do
        if [[ -n "$this" && -f "./hooks/$EVENT-$this" ]]; then
            echo "Executing $EVENT hooks for $this..."
            source "./hooks/$EVENT-$this"
        fi
    done
}
