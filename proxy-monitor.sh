#!/bin/bash
source /home/docker/docker-script/deploy/config/env.sh
while (true); 
do 
  docker ps; 
  echo "";  
  cat ${NGINX_UPSTREAM_CONF_FILEPATH}
  echo ""; 
  ps -ef |grep deploy;
  echo "";
  sleep 2; 
done;
