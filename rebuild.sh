#!/bin/bash

echo "start!"

docker stop greenplum_6.8

echo "stoped!"

docker rm greenplum_6.8

echo "removed!"

docker rmi redash_greenplum_6.8:latest

echo "delete image!"


docker-compose -f docker-compose.yml up -d  --build

echo "builded!"

sleep 5

docker logs greenplum_6.8
