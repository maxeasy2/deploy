#!/bin/bash
CWD="$(dirname $0)"
cd $CWD
source /home/docker/docker-script/deploy/config/env.sh

if [ ${WARMUP_USE_YN} != 'Y' ]; then
  exit 0
fi

SERVER_LIST=$(cat ${NGINX_REVERSE_PROXY_TARGET_FILE} | awk '{print $2}')

if [ -n "${SERVER_LIST}" ]; then
  echo "Warmup..."
  for server in ${SERVER_LIST}
  do
    ab \
    -c ${WARMUP_THREAD} \
    -n ${WARMUP_NUM} \
    "http://${server}${WARMUP_URI}" #>/dev/null 2>&1 &
  done
fi

