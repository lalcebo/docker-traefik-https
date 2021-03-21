#!/usr/bin/env sh

# Initialize script
. ./initscripts.sh

echo '---------------------------------------------------------------------------'
echo '--- Recreating Containers'
echo '---------------------------------------------------------------------------'
docker-compose up -d --remove-orphans
echo
