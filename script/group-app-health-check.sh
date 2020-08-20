# !/bin/bash
source /home/docker/docker-script/deploy/config/env.sh

GROUP=$1
CONTAINER_SCALE_NUM=${2:-4}
if [ -z "$GROUP" ]; then
  echo "Group is null"
  exit 0
fi
TARGET_HOST=`docker ps -f status=running -f name=${GROUP}-${CONTAINER_NAME} --format "{{.Ports}}"  | awk -F '->' '{print $1}' | sed s/0.0.0.0/localhost/g | xargs`
TARGET_HOST_RUNNING_COUNT=`docker ps -f status=running -f name=${GROUP}-${CONTAINER_NAME} --format "{{.Ports}}"  | awk -F '->' '{print $1}' | sed s/0.0.0.0/localhost/g | wc -l`
if [ $TARGET_HOST_RUNNING_COUNT -ne $CONTAINER_SCALE_NUM ]; then
  echo "fail"
  exit 2
fi  

RESULT='Y'

echo "[$GROUP Health Check]---------------------"
for value in $TARGET_HOST
do
 STATUS=`curl -sL -w "%{http_code}" -I "$value$HEALTH_CHECK_URL_PATH" -o /dev/null`

  if [ $STATUS -ne 200 ]; then
    RESULT='N'
    echo "$value......Fail"
    break
  fi
 echo "$value......Ok"
done

echo "------------------------------------------"

if [ $RESULT == 'Y' ]; then
  echo "success"
  exit 0
fi

echo "fail"


