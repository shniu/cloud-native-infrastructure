#!/bin/bash

doInit=false

function usage() {
    echo -e "kube-scale provides the following features: \n"
    echo -e "Options"
    echo -e "    --enable-mysql                 启用 mysql service"
    echo -e "    --enable-mysql-with-init       启用 mysql service, 并执行初始化"
    echo -e "    --enable-redis                 启用 redis service"
    echo -e "    --enable-eureka                启用 eureka service"
    echo -e "    --enable-xxl-job               启用 xxl-job service"
    echo -e "    --enable-rocketmq              启用 rocketMQ service"
    echo -e "    -h, --help            查看帮助"
}

function enableMySQL() {
    echo -e "enable mysql"
    minikube kubectl -- scale --replicas=1 deployment/mysql

    if $doInit ; then
        echo "Sleep 15s waiting for mysql to start successfully"
        sleep 15s

        . kube-init.sh --init-database
    fi
}

function enableRedis() {
    echo -e "enable redis"
    minikube kubectl -- scale --replicas=1 deployment/redis
}

function enableEureka() {
    echo -e "enable eureka"
    minikube kubectl -- scale --replicas=1 statefulsets/eureka
}

function enableXXLJob() {
    echo -e "enable xxl-job"
    minikube kubectl -- scale --replicas=1 deployment/xxl-job
}

while [ "$1" != "" ]; do
    case $1 in
        --enable-mysql   )         enableMySQL
                                    ;;
        --enable-mysql-with-init )  doInit=true
                                    enableMySQL
                                    ;;
        --enable-redis   )         enableRedis
                                    ;;
        --enable-eureka  )         enableEureka
                                    ;;
        --enable-xxl-job )         enableXXLJob
                                    ;;
        -h | --help       )         usage
                                    exit 0
                                    ;;
        *                 )         usage
                                    exit 1
    esac
    shift
done
