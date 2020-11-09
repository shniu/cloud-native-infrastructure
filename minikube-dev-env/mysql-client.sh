#!/bin/bash

# kubectl run -it --rm --image=mysql:5.7 --restart=Never mysql-client -- mysql -h mysql -p
# 用容器 kubernetes 的话，还是需要把 sql 文件映射到容器里
# 另外一个思路是在宿主机上安装一个 mysql 客户端，远程执行 sql 脚本
minikube kubectl -- run -i --rm --image=mysql:5.7 --restart=Never mysql-client -- mysql -h mysql -u root -p123456 -e "source /data/resources/sql/xxl_job.sql"