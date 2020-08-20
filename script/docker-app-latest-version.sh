# !/bin/bash

source /home/docker/docker-script/deploy/config/env.sh
BUILD_NO=$(docker image inspect --format='{{ index .Config.Labels "build_no"}}' $(docker images ${IMAGE_NAME} -q  | head -1))

echo ${BUILD_NO}
