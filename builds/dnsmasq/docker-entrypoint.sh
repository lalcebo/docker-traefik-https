#!/usr/bin/env bash

set -e

echo
echo "                    >'?'<"
echo "                  ª( o o )ª"
echo "----------------ooOO-(_)-OOoo-----------------"
echo ""
echo "                DNSMASQ Server"
echo

# include common functions
. /functions.sh

# run
echo "$(datetime) INFO docker container started"
exec "$@"
