#!/usr/bin/env sh

# Initialize script
. ./initscripts.sh

# Execute pre hooks
executePreHooks "$ENABLE_APPS"
executePreHooks "$ENABLE_SERVERS"

echo '---------------------------------------------------------------------------'
echo '--- Recreating Containers'
echo '---------------------------------------------------------------------------'
docker-compose up -d --remove-orphans
echo

# Execute post hooks
executePostHooks "$ENABLE_APPS"
executePostHooks "$ENABLE_SERVERS"
