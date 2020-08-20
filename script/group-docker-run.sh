# !/bin/bash
CWD="$(dirname $0)"
cd $CWD
source /home/docker/docker-script/deploy/config/env.sh

GROUP=$1
TAG=${3:-latest}
CONTAINER_SCALE_NUM=${2:-4}

if [ -z "$GROUP" ]; then
  echo "Group is null"
  exit 1
fi

if [ $TAG == "latest" ]; then
  docker pull ${IMAGE_NAME}:${TAG}
fi

# 프록시 대상 초기화
cat /dev/null > ${NGINX_REVERSE_PROXY_TARGET_FILE}
for ((i=1;i<=$CONTAINER_SCALE_NUM;i++))
  do
    TASK_ID=$i
    if [ "$GROUP" != "group1" ]; then
      TASK_ID=`expr $i + $CONTAINER_SCALE_NUM`
    fi
    TASK_PORT=`expr $BASE_PORT + $TASK_ID`
    docker run -d --restart=unless-stopped \
    -u root \
    --name ${GROUP}-${CONTAINER_NAME}-${TASK_ID} \
    -p ${TASK_PORT}:${DEFAULT_PORT} \
    -e TZ=Asia/Seoul \
    -e LANG=ko_KR.UTF-8 \
    -e PROFILE=prod \
    -e TASK_ID=${TASK_ID} \
    -e HOST_NAME=`hostname` \
    -v /webapp/logs/node${TASK_ID}:/webapp/logs \
    ${IMAGE_NAME}:${TAG} > /dev/null 2>&1 &

    echo "server localhost:${TASK_PORT} max_fails=3 fail_timeout=15s;" >> ${NGINX_REVERSE_PROXY_TARGET_FILE}
  done
