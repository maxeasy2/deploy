#!/bin/bash
source /home/docker/docker-script/deploy/config/env.sh

GROUP=$1

if [ -z "$GROUP" ]; then
  echo "Group is null"
  exit 1
fi

NGINX_LIVE_CONT=`docker ps -f status=running -f name=${NGINX_CONTAINER_NAME} --format "{{.Ports}}" | wc -l`

if [ $NGINX_LIVE_CONT -eq 0 ]; then
  echo "nginx is not running..."
  exit 2
fi
source_container_name=`docker ps -f name=${GROUP}-${CONTAINER_NAME} --format="{{.Names}}" | head -1`

if [ -n $source_container_name ]; then
  if [ -d ${NGINX_RESOURCE_PATH} ]; then
    rm -rf ${NGINX_RESOURCE_PATH}/*
  fi
  docker cp ${source_container_name}:${CONTAINER_INSIDE_SRC_FILEPATH} ${NGINX_RESOURCE_PATH}
  unzip ${NGINX_RESOURCE_PATH}/${JAR_FILE_NAME} -d ${NGINX_RESOURCE_PATH}  > /dev/null 2>&1 &
fi
