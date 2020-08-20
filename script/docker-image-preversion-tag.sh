# !/bin/bash

source /home/docker/docker-script/deploy/config/env.sh

CONTAINER_ID=`docker images $IMAGE_NAME -q | head -2 | tail -1`
BUILD_NO=`docker image inspect --format='{{ index .Config.Labels "build_no"}}' $CONTAINER_ID`

docker tag $CONTAINER_ID $IMAGE_NAME:$BUILD_NO
