#!/usr/bin/env sh

# Initialize script
. ./initscripts.sh

echo
echo '---------------------------------------------------------------------------'
echo '--- Removing Running Containers'
echo '---------------------------------------------------------------------------'
echo

docker-compose down --remove-orphans
echo

# Execute stop hooks
executeStopHooks "$ENABLE_APPS"
executeStopHooks "$ENABLE_SERVERS"

# Execute pre hooks
executePreHooks "$ENABLE_APPS"
executePreHooks "$ENABLE_SERVERS"

echo
echo '---------------------------------------------------------------------------'
echo '--- Starting Containers'
echo '---------------------------------------------------------------------------'
echo

docker-compose up -d --remove-orphans
echo

# Execute post hooks
executePostHooks "$ENABLE_APPS"
executePostHooks "$ENABLE_SERVERS"

docker ps
echo
