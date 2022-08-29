#!/usr/bin/env sh

# Initialize script
. ./initscripts.sh

# Execute pre hooks
executeHooks pre "$ENABLE_SERVICES"

echo '---------------------------------------------------------------------------'
echo '--- Starting Containers'
echo '---------------------------------------------------------------------------'
docker-compose up -d --remove-orphans

# Execute post hooks
executeHooks post "$ENABLE_SERVICES"

echo '---------------------------------------------------------------------------'
echo '--- Displaying Running Containers'
echo '---------------------------------------------------------------------------'
docker ps
echo
