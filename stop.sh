#!/usr/bin/env sh

# Initialize script
. ./initscripts.sh

echo '---------------------------------------------------------------------------'
echo '--- Removing Running Containers'
echo '---------------------------------------------------------------------------'
docker-compose down --remove-orphans
echo

# Execute stop hooks
executeStopHooks "$ENABLE_APPS"
executeStopHooks "$ENABLE_SERVERS"

echo '---------------------------------------------------------------------------'
echo '--- Displaying Running Containers'
echo '---------------------------------------------------------------------------'
docker ps
echo
