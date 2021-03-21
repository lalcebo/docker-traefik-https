#!/usr/bin/env sh

# Initialize script
. ./initscripts.sh

echo '---------------------------------------------------------------------------'
echo '--- Starting Containers'
echo '---------------------------------------------------------------------------'
docker-compose up -d --remove-orphans
echo

echo '---------------------------------------------------------------------------'
echo '--- Displaying Running Containers'
echo '---------------------------------------------------------------------------'
docker ps
echo
