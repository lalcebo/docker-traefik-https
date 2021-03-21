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

echo
echo '---------------------------------------------------------------------------'
echo '--- Starting Containers'
echo '---------------------------------------------------------------------------'
echo

docker-compose up -d --remove-orphans
echo

docker ps
echo
