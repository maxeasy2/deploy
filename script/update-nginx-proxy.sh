# !/bin/bash
source /home/docker/docker-script/deploy/config/env.sh

NGINX_LIVE_CONT=`docker ps -f status=running -f name=${NGINX_CONTAINER_NAME} --format "{{.Ports}}" | wc -l`

if [ -f "$NGINX_REVERSE_PROXY_TARGET_FILE" ]; then
  # upstream 설정변경
  cat $NGINX_REVERSE_PROXY_TARGET_FILE > $NGINX_UPSTREAM_CONF_FILEPATH

  if [ $NGINX_LIVE_CONT -eq 1 ]; then
    # nginx reload
    docker exec ${NGINX_CONTAINER_NAME} nginx -s reload
  fi

#  exit 0
else
  echo "file not exist"
fi
