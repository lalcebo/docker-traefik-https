#!/usr/bin/env sh

# Initialize script
. ./initscripts.sh

# Execute pre hooks
executeHooks pre "$ENABLE_SERVICES"

echo '---------------------------------------------------------------------------'
echo '--- Recreating Containers'
echo '---------------------------------------------------------------------------'
docker-compose up -d --remove-orphans
echo

# Execute post hooks
executeHooks post "$ENABLE_SERVICES"
