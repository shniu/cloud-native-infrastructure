#!/bin/bash

dir=$(pwd)

# Redis config
daemonize="yes"

# Features
init=true
newNode=""

### Function
function generateConfFile() {
    echo """
    port $1
    cluster-enabled yes
    cluster-config-file nodes.conf
    cluster-node-timeout 5000
    appendonly yes

    dir $dir/$1/data
    tcp-backlog 511
    bind 0.0.0.0
    appendfsync everysec
    protected-mode no
    daemonize $daemonize
    # requirepass 123456
    maxclients 1000
    pidfile $dir/$1/redis.pid
    """ > $1/redis.conf
}

function usage() {
    echo -e "redis-cluster provides the following features: \n"
    echo -e "Options"
    echo -e "    -i, --init                 执行初始化集群的操作"
    echo -e "    --new-node <node port>     创建新节点"
    echo -e "    -h, --help                 查看帮助"
}

while [ "$1" != "" ]; do
    case $1 in
        -i | --init       )         init=true
                                    ;;
        --new-node        )         shift
                                    init=false
                                    newNode="$1"
                                    ;;
        -h | --help       )         usage
                                    exit 0
                                    ;;
        *                 )         usage
                                    exit 1
    esac
    shift
done

if $init ; then
    # Init redis cluster, we plan to build a redis cluster, include 3 master and 3 slave.
    mkdir -p 7000/data 7001/data 7002/data 7003/data 7004/data 7005/data

    generateConfFile 7000
    generateConfFile 7001

    generateConfFile 7002
    generateConfFile 7003

    generateConfFile 7004
    generateConfFile 7005
fi

if [ "$newNode" != "" ] 
then 
    mkdir -p $newNode/data
    generateConfFile $newNode
    echo -e "New node $newNode created."
fi
