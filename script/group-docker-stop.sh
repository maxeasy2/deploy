#!/bin/bash

GROUP=$1
if [ -z "$GROUP" ]; then
  echo "Group is null"
  exit 0
fi

CONTAINER_IDS=`docker ps | grep ${GROUP}-${CONTAINER_NAME} | awk '{print \$1}' | xargs`
for container_id in $CONTAINER_IDS
do
  (docker stop $container_id && docker rm $container_id) > /dev/null 2>&1 &
 # docker rm $container_id  > /dev/null 2>&1 &
done
#echo "complete"
