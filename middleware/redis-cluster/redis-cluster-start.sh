#!/bin/bash

redis-server 7000/redis.conf
redis-server 7001/redis.conf

redis-server 7002/redis.conf
redis-server 7003/redis.conf

redis-server 7004/redis.conf
redis-server 7005/redis.conf

redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 \
  127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 --cluster-replicas 1