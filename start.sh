#!/usr/bin/env sh

# Initialize script
. ./initscripts.sh

# Execute pre hooks
executeHooks pre "$ENABLE_APPS,$ENABLE_SERVERS"

echo '---------------------------------------------------------------------------'
echo '--- Starting Containers'
echo '---------------------------------------------------------------------------'
docker-compose up -d --remove-orphans

# Execute post hooks
executeHooks post "$ENABLE_APPS,$ENABLE_SERVERS"

echo '---------------------------------------------------------------------------'
echo '--- Displaying Running Containers'
echo '---------------------------------------------------------------------------'
docker ps
echo
