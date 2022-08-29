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
executeHooks stop "$ENABLE_SERVICES"

# Execute pre hooks
executeHooks pre "$ENABLE_SERVICES"

echo
echo '---------------------------------------------------------------------------'
echo '--- Starting Containers'
echo '---------------------------------------------------------------------------'
echo

docker-compose up -d --remove-orphans
echo

# Execute post hooks
executeHooks post "$ENABLE_SERVICES"

docker ps
echo
