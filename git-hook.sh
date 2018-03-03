#!/bin/bash
# Call this script with you trigger token from docker hub!
git fetch
git checkout 1.2.0
git pull upstream
git push origin
git checkout debian-1.2
git push origin
http post https://registry.hub.docker.com/u/jrabbit/taskserver/trigger/"$0"/ build=true
