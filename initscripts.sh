#!/usr/bin/env sh

# shellcheck disable=SC2046
# shellcheck disable=SC2164
# shellcheck disable=SC2006

# Change directory to script path
cd `dirname $(readlink -f "$0")`

# Common scripts
. ./scripts/common.sh
. ./scripts/services.sh
