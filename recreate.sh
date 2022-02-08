#!/usr/bin/env sh

# Initialize script
. ./initscripts.sh

# Execute pre hooks
executeHooks pre "$ENABLE_APPS,$ENABLE_SERVERS"

echo '---------------------------------------------------------------------------'
echo '--- Recreating Containers'
echo '---------------------------------------------------------------------------'
docker-compose up -d --remove-orphans
echo

# Execute post hooks
executeHooks post "$ENABLE_APPS,$ENABLE_SERVERS"
