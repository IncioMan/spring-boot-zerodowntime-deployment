#!/usr/bin/env bash

CONTAINER_NAME="complete_web_"
# lets find the first container
FIRST_NUM=`docker ps | awk '{print $NF}' | grep $CONTAINER_NAME | awk -F  "_" '{print $NF}' | sort | head -1`
NUM_OF_CONTAINERS=1
MAX_NUM_OF_CONTAINERS=2

gradle clean -p ../
gradle build -x test -p ../

docker-compose build web
docker-compose scale web=$MAX_NUM_OF_CONTAINERS

# FIXME waiting for new containers
sleep 40

# removing old containers
for ((i=$FIRST_NUM;i<$NUM_OF_CONTAINERS+$FIRST_NUM;i++))
do
   docker stop $CONTAINER_NAME$i
   docker rm $CONTAINER_NAME$i
done

docker-compose scale web=$NUM_OF_CONTAINERS