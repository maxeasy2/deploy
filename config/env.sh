#!/bin/bash
################################################################################
### 스크립트 관련 설정
################################################################################

# deploy 스크립트 root
DEPLOY_FILE_PATH=/home/docker/docker-script/deploy

# deploy 내부 task 스크립트
SCRIPT_PATH=${DEPLOY_FILE_PATH}/script



################################################################################
### 도커 Spring Application 이미지 & 컨테이너 관련 설정
################################################################################

### 스프링앱 이미지
IMAGE_NAME=

### 컨테이너 명
CONTAINER_NAME=

### 스프링 어플리케이션 디폴트 포트
DEFAULT_PORT=8080

### Spring application jar파일명
JAR_FILE_NAME=

### 컨테이너 내 JAR 파일경로
CONTAINER_INSIDE_SRC_FILEPATH=/webapp/$JAR_FILE_NAME



################################################################################
### 도커 NGINX 이미지 & 컨테이너 관련 설정
################################################################################

### nginx 이미지
NGINX_IMAGE="nginx:latest"

### NGINX 컨테이너 명
NGINX_CONTAINER_NAME=nginx

## NGINX 호스트(볼륨) 루트
NGINX_PATH=/web

## NGINX 설정값 디렉터리 경로
NGINX_HOST_PATH=${NGINX_PATH}/nginx

## NGINX 리소스 경로
NGINX_RESOURCE_PATH=${NGINX_PATH}/resource

## NGINX 로그 경로
NGINX_LOG_PATH=${NGINX_PATH}/logs

## NGINX 컨테이너 실행시 리버스 프록시 설정값 생성
NGINX_REVERSE_PROXY_TARGET_FILE=${DEPLOY_FILE_PATH}/nginx-conf/nginx-reverse-proxy.conf

## NGINX 설정값(호스트)
NGINX_CONFIG_PATH=${NGINX_HOST_PATH}/reverse_proxy

## NGINX 리버스 프록시 업스트림 설정 파일(nginx-reverse-proxy.conf로 업데이트하면서 인입제어함)
NGINX_UPSTREAM_CONF_FILEPATH=${NGINX_CONFIG_PATH}/upstream.conf

# 컨테이너 내 NGINX 설정 루트경로
CONTAINER_NGINX_PATH=/etc/nginx

## 컨테이너 내 NGINX Upstream 디렉터리 경로
CONTINER_NGINX_CONFING_PATH=${CONTAINER_NGINX_PATH}/upstream

# 컨테이너 내 NGINX 로그 경로
CONTINER_NGINX_LOG_PATH=/var/log/nginx
 
## 컨테이너 내 NGINX WEB 리소스 경로
CONTINER_NGINX_RESOURCE_PATH=/web



################################################################################
### 배포 관련 설정
################################################################################

## 스프링 어플리케이션 기동 간격
JAVA_DEPOLY_INTERVAL=30

## health check 재시도 휫수
RETRY_COUNT=8

## health check 재시도 간격
RETRY_LOOP_INTERVAL=2

### 컨테이너 개수 설정
CONTAINER_SCALE_NUM=4

## 프록시 변경후 기존커넥션 종료 간격
WEB_CONN_CLOSE_INTERVAL=10

## 이전 이미지 백업 개수
BACKUP_COUNT=15

### 헬스체크 url
HEALTH_CHECK_URL_PATH=/healthcheck

## 기본포트 + 넘버링
BASE_PORT=8000

## 배포 그룹명 구분
GROUP1=group1
GROUP2=group2

## 웜업 설정
if [ -z ${WARMUP_USE_YN} ]; then
  WARMUP_USE_YN=N
fi

## 웜업 스레드 개수
if [ -z ${WARMUP_THREAD} ]; then
  WARMUP_THREAD=500
fi

## 웜업 카운트
if [ -z ${WARMUP_NUM} ]; then
  WARMUP_NUM=500
fi

## 웜업 URI
if [ -z ${WARMUP_URI} ]; then
  WARMUP_URI=/warmup
fi
