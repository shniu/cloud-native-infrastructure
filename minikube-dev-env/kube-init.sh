#!/bin/bash

dir=$(pwd)
echo "workdir: $dir"

echo "Initialize xxl-job..."

ip=$(minikube ip)
# mysql -h $ip -u root -P 30306 -p123456
mysql -h $ip -u root -P 30306 -p123456 < $dir/resources/sql/xxl_job.sql