# Redis Cluster

Redis Cluster 搭建流程以及集群变更流程等。

## Install & Create Redis Cluster

### Install Redis

可以去 https://redis.cn 去下载 Redis 的安装包，或者源码，然后编译安装，安装过程省略

### 规划集群

在正式安装集群之前我们需要规划好整个集群的容量、实例数、端口划分、槽的分配等问题，比如计划搭建一个 3 主 3 从的集群，端口号从7000开始，依次递增

```shell
$ mkdir redis-cluster-home & cd redis-cluster-home
$ mkdir -p 7000/data 7001/data 7002/data 7003/data 7004/data 7005/data

$ vim redis-cluster-init.sh
#!/bin/bash
dir=$(pwd)
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

generateConfFile 7000
generateConfFile 7001

generateConfFile 7002
generateConfFile 7003

generateConfFile 7004
generateConfFile 7005

# 初始化 6 Redis 的配置
$ chmod +x redis-cluster-init.sh & ./redis-cluster-init.sh

$ vim redis-cluster-start.sh
#!/bin/bash
redis-server 7000/redis.conf
redis-server 7001/redis.conf

redis-server 7002/redis.conf
redis-server 7003/redis.conf

redis-server 7004/redis.conf
redis-server 7005/redis.conf

# 启动 6 个 Redis 实例，目前为止这 6 个实例之间还未形成集群
$ chmod +x redis-cluster-start.sh & ./redis-cluster-start.sh
```

### 创建集群

完成上面的步骤后，已经得到了 6 个运行着的 Redis 实例，开始创建集群：

```shell
# 创建集群
$ redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 \
      127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 --cluster-replicas 1
$ 
```

## Reference


