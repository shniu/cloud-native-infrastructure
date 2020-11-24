#!/bin/bash

dir=$(pwd)
echo "Workdir: $dir"

function initDatabase() {
    echo "Initialize xxl-job..."

    ip=$(minikube ip)
    # mysql -h $ip -u root -P 30306 -p123456
    mysql -h $ip -u root -P 30306 -p123456 < $dir/resources/sql/xxl_job.sql
    # mysql --defaults-file=$dir/mysql-client.cnf -h $ip -u root -P 30306  < $dir/resources/sql/xxl_job.sql

    echo -e "Init database finished"
}

function addOrReplaceLocalDevDomain() {
    ip=$(minikube ip)

    echo -e "Does the configuration of /etc/hosts have a dev.svc.local configuration? As below:"
    sed -n '/dev.svc.local/p' /etc/hosts
    echo -e ""
    
    echo -e "Delete dev.svc.local in /etc/hosts, input sudo password:"
    sudo sed -i "" '/dev.svc.local/d' /etc/hosts
    echo "$ip  dev.svc.local" >> /etc/hosts

    echo -e "\nContent of /etc/hosts:"
    cat /etc/hosts
}

function usage() {
    echo -e "kube-init provides the following features: \n"
    echo -e "Options"
    echo -e "    --init-database              执行初始化数据库的操作"
    echo -e "    --add-local-dev-domain       将 minikube ip 对应的地址加入到本地域名解析，/etc/hosts"
    echo -e "    -h, --help                   查看帮助"
}

while [ "$1" != "" ]; do
    case $1 in
        --init-database   )         initDatabase
                                    ;;
        --add-local-dev-domain )    addOrReplaceLocalDevDomain
                                    ;;
        -h | --help       )         usage
                                    exit 0
                                    ;;
        *                 )         usage
                                    exit 1
    esac
    shift
done