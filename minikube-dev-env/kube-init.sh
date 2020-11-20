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

while [ "$1" != "" ]; do
    case $1 in
        --init-database   )         initDatabase
                                    ;;
        -h | --help       )         usage
                                    exit 0
                                    ;;
        *                 )         usage
                                    exit 1
    esac
    shift
done