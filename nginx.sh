#!/bin/bash

source /home/docker/docker-script/deploy/config/env.sh

TASK=${1:-'start'}

if [ $TASK == 'start' ]; then
  docker pull ${NGINX_IMAGE}
  docker run -d --restart=unless-stopped --net=host \
  -e PUID=0 \
  -e PGID=0 \
  -e TZ=Asia/Seoul \
  -e LANG=ko_KR.UTF-8 \
  -v ${NGINX_LOG_PATH}:${CONTINER_NGINX_LOG_PATH} \
  -v ${NGINX_RESOURCE_PATH}:${CONTINER_NGINX_RESOURCE_PATH} \
  -v ${NGINX_CONFIG_PATH}:${CONTINER_NGINX_CONFING_PATH} \
  --name ${NGINX_CONTAINER_NAME} \
  ${NGINX_IMAGE} 
#> /dev/null 2>&1 &
elif [ $TASK == 'stop' ]; then
  (docker stop ${NGINX_CONTAINER_NAME} && docker rm ${NGINX_CONTAINER_NAME})
elif [ $TASK == 'reload' ]; then
  docker exec -it ${NGINX_CONTAINER_NAME} nginx -s reload
elif [ $TASK == 'restart' ]; then
  docker restart ${NGINX_CONTAINER_NAME}
fi

