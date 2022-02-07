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
# Execute pre hooks scripts
# @usage executePreHooks $hooks
##
executePreHooks() {
    local HOOKS=($@)
    for i in "${HOOKS[@]}"; do
        test -f "./hooks/apps/pre-$i" && . "./hooks/apps/pre-$i"
        test -f "./hooks/servers/pre-$i" && . "./hooks/servers/pre-$i"
    done
}

##
# Execute post hooks scripts
# @usage executePostHooks $hooks
##
executePostHooks() {
    local HOOKS=($@)
    for i in "${HOOKS[@]}"; do
        test -f "./hooks/apps/post-$i" && . "./hooks/apps/post-$i"
        test -f "./hooks/servers/post-$i" && . "./hooks/servers/post-$i"
    done
}

##
# Execute stop hooks scripts
# @usage executeStopHooks $hooks
##
executeStopHooks() {
    local HOOKS=($@)
    for i in "${HOOKS[@]}"; do
        test -f "./hooks/apps/stop-$i" && . "./hooks/apps/stop-$i"
        test -f "./hooks/servers/stop-$i" && . "./hooks/servers/stop-$i"
    done
}
