#!/bin/bash

dir=$(pwd)

# Redis config
daemonize="yes"

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

# Init redis cluster, we plan to build a redis cluster, include 3 master and 3 slave.
mkdir -p 7000/data 7001/data 7002/data 7003/data 7004/data 7005/data

generateConfFile 7000
generateConfFile 7001

generateConfFile 7002
generateConfFile 7003

generateConfFile 7004
generateConfFile 7005