#!/bin/bash
source /home/docker/docker-script/deploy/config/env.sh
IMAGE_COUNT=`docker images ${IMAGE_NAME} -q | wc -l`

if [ $IMAGE_COUNT -gt $BACKUP_COUNT ]; then
  target_container_id=`docker images ${IMAGE_NAME} -q | head -${BACKUP_COUNT} | tail -1`
  docker rmi -f $(docker images -f "before=${target_container_id}" ${IMAGE_NAME} -q) > /dev/null 2>&1 &
fi

