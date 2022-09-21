#!/usr/bin/env sh

# shellcheck disable=SC2046
# shellcheck disable=SC2005
# shellcheck disable=SC2039

datetime() {
    local FORMAT=${1:-"%Y-%m-%d %T %Z"}
    echo $(date +"$FORMAT")
}
