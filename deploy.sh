#!/bin/bash
source /home/docker/docker-script/deploy/config/env.sh

DEPLOY_TEMP_FILENAME=.deploy.tmp
HEALTH_CHECK_RESULT="fail"
RESULT='Y'
FORCE_RECOVERY_PASS=N
TAG_USE=N
GROUP=`${SCRIPT_PATH}/deploy-target-group.sh`
ROLLING_UPDATE_YN=N

# 옵션 파라미터별 처리
while getopts "ft:" opt
do
  case $opt in
    f) FORCE_RECOVERY_PASS='Y';;
    t) TAG_USE='Y'
       TAG=$OPTARG
       ;;
  esac
done
shift `expr $OPTIND - 1`

if [ $TAG_USE == 'Y' ] && [ -z $TAG ]; then
  echo "option argument error"
  exit 1;
fi

if [ $GROUP == 'fail' ]; then
  echo "컨테이너 개수를 확인 해주세요! 문제있는 컨테이너는 아래와 같이 내려주세요"
  echo "/home/docker/docker-script/deploy/script/group-docker-stop.sh 그룹명(group1,group2)"
  exit 2;
fi
# Nginx proxy group별 update 
#$SCRIPT_PATH/update-nginx-proxy.sh $GROUP
#echo "Nginx Proxy Update..."
$SCRIPT_PATH/group-docker-run.sh $GROUP $CONTAINER_SCALE_NUM $TAG

echo "Spring Boot Loading..."
echo ""
sleep $JAVA_DEPOLY_INTERVAL

# Spring Application Health Check loop
for ((i=1;i<=$RETRY_COUNT;i++))
do
  echo "Trying...$i"
  $SCRIPT_PATH/group-app-health-check.sh $GROUP $CONTAINER_SCALE_NUM > $SCRIPT_PATH/$DEPLOY_TEMP_FILENAME
  echo ""
  cat $SCRIPT_PATH/$DEPLOY_TEMP_FILENAME
  HEALTH_CHECK_RESULT=`tail -1 $SCRIPT_PATH/$DEPLOY_TEMP_FILENAME`
  if [ $HEALTH_CHECK_RESULT == 'fail' ]; then
    sleep $RETRY_LOOP_INTERVAL
    RESULT='N'
  else
    RESULT='Y'
    break
  fi
done

if [ ! -z $SCRIPT_PATH ] && [ ! -z $DEPLOY_TEMP_FILENAME ]; then
  rm -rf $SCRIPT_PATH/$DEPLOY_TEMP_FILENAME
fi

if [ $RESULT == 'Y' ]; then
  
  # warmup 처리
  $SCRIPT_PATH/warmup.sh

  if [ $GROUP == "group1" ]; then
    UPDATE_GROUP="group2"
  else 
    UPDATE_GROUP="group1"
  fi
 
 # 배포완료 전체 컨테이너 proxy update
  # porxy 대상 upstream 설정파일은 group정보가 반대로 들어가있음
  $SCRIPT_PATH/update-nginx-proxy.sh
  echo "Nginx Update..."

  # nginx proxy 변경 후 커넥션 CLOSE 하는 시간 대기
  sleep $WEB_CONN_CLOSE_INTERVAL

  # static 리소스 반영 , 반영시간에의한 차이를 줄이기위해 proxy update후 반영함 proyx동안은 was리소스를 봄
  $SCRIPT_PATH/deploy-web.sh $GROUP

  # 이전 빌드버전 이미지 태깅
  $SCRIPT_PATH/docker-image-preversion-tag.sh

  # 이미지 히스토리 관리 (15개)
  $SCRIPT_PATH/docker-image-remove.sh

  # 이전 버전  컨테이너 다운
  $SCRIPT_PATH/group-docker-stop.sh $UPDATE_GROUP
#  echo "docker tag update..."
  echo "complete"
  exit 0
fi 

echo "fail"
exit 1
