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
        test -n "$this" && echo "Executing $EVENT hooks for $this..." || continue
        test -f "./hooks/apps/$EVENT-$this" && . "./hooks/apps/$EVENT-$this"
        test -f "./hooks/servers/$EVENT-$this" && . "./hooks/servers/$EVENT-$this"
    done
}
