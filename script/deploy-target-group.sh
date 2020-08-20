#!/bin/bash

source /home/docker/docker-script/deploy/config/env.sh

GROUP1_PROCESS_COUNT=`docker ps -f status=running -f name=${GROUP1}-${CONTAINER_NAME} --format "{{.Names}}" | wc -l`
GROUP2_PROCESS_COUNT=`docker ps -f status=running -f name=${GROUP2}-${CONTAINER_NAME} --format "{{.Names}}" | wc -l`

if [ $GROUP1_PROCESS_COUNT -gt 0 ] && [ $GROUP2_PROCESS_COUNT -gt 0 ]; then
  echo "fail" 
  exit 1
fi

if [ $GROUP1_PROCESS_COUNT -gt 0 ]; then
  echo "${GROUP2}"
  exit 0
fi

if [ $GROUP2_PROCESS_COUNT -gt 0 ]; then
  echo "${GROUP1}"
  exit 0
fi

echo "${GROUP1}"
