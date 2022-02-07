#!/usr/bin/env sh

# Initialize script
. ./initscripts.sh

# Execute pre hooks
executePreHooks "$ENABLE_APPS"
executePreHooks "$ENABLE_SERVERS"

echo '---------------------------------------------------------------------------'
echo '--- Starting Containers'
echo '---------------------------------------------------------------------------'
docker-compose up -d --remove-orphans

# Execute post hooks
executePostHooks "$ENABLE_APPS"
executePostHooks "$ENABLE_SERVERS"

echo '---------------------------------------------------------------------------'
echo '--- Displaying Running Containers'
echo '---------------------------------------------------------------------------'
docker ps
echo
