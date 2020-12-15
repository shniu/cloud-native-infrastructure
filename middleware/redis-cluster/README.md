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
# 执行上面的命令后会进入自动创建集群的流程中 
```

### 重新分片

重新分片就是槽的迁移，将哈希槽从一个或几个节点迁移到另一个节点

```shell
$ redis-cli --cluster reshard 127.0.0.1:7000
>>> Performing Cluster Check (using node 127.0.0.1:7000)
M: e1503c4405a7027eb887d38b68d629fb778d119b 127.0.0.1:7000
   slots:[166-5460] (5295 slots) master
   1 additional replica(s)
S: 5a9186c4f68a0226353527463daf882518b16fcf 127.0.0.1:7005
   slots: (0 slots) slave
   replicates e1503c4405a7027eb887d38b68d629fb778d119b
M: a58509e8a4ca949bf0b73ff3ab7125f7ca41bc58 127.0.0.1:7002
   slots:[11089-16383] (5295 slots) master
   1 additional replica(s)
M: 403a66881dba0b04d1adfa512b1a831adc4a85ac 127.0.0.1:7001
   slots:[0-165],[5461-11088] (5794 slots) master
   1 additional replica(s)
S: 07cff5344bd37c0547cb34549ab136232b4fff26 127.0.0.1:7003
   slots: (0 slots) slave
   replicates 403a66881dba0b04d1adfa512b1a831adc4a85ac
S: 7f19412540f133a759c7482f6c619857ca40763e 127.0.0.1:7004
   slots: (0 slots) slave
   replicates a58509e8a4ca949bf0b73ff3ab7125f7ca41bc58
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
How many slots do you want to move (from 1 to 16384)? 600
What is the receiving node ID? a58509e8a4ca949bf0b73ff3ab7125f7ca41bc58
Please enter all the source node IDs.
  Type 'all' to use all the nodes as source nodes for the hash slots.
  Type 'done' once you entered all the source nodes IDs.
Source node #1:
```

首先会测试集群的运行状态，然后询问你要重新分配多少个槽(假如指定 600 个槽)：
How many slots do you want to move (from 1 to 16384)?

然后需要指定重新分片的目标 ID (也就是指定哪个节点来接收这些重新分配的槽)，可以通过以下命令来查看某个节点的信息(里面包括了节点的 ID)。

### 故障转移

- 自动故障转移

```shell
$ redis-cli --cluster info 127.0.0.1:7000
127.0.0.1:7000 (e1503c44...) -> 1 keys | 5295 slots | 1 slaves.
127.0.0.1:7002 (a58509e8...) -> 0 keys | 5295 slots | 1 slaves.
127.0.0.1:7001 (403a6688...) -> 1 keys | 5794 slots | 1 slaves.
[OK] 2 keys in 3 masters.
0.00 keys per slot on average.

$ redis-cli --cluster check 127.0.0.1:7000
127.0.0.1:7000 (e1503c44...) -> 1 keys | 5295 slots | 1 slaves.
127.0.0.1:7002 (a58509e8...) -> 0 keys | 5295 slots | 1 slaves.
127.0.0.1:7001 (403a6688...) -> 1 keys | 5794 slots | 1 slaves.
[OK] 2 keys in 3 masters.
0.00 keys per slot on average.
>>> Performing Cluster Check (using node 127.0.0.1:7000)
M: e1503c4405a7027eb887d38b68d629fb778d119b 127.0.0.1:7000
   slots:[166-5460] (5295 slots) master
   1 additional replica(s)
S: 07cff5344bd37c0547cb34549ab136232b4fff26 127.0.0.1:7003
   slots: (0 slots) slave
   replicates 403a66881dba0b04d1adfa512b1a831adc4a85ac
S: 7f19412540f133a759c7482f6c619857ca40763e 127.0.0.1:7004
   slots: (0 slots) slave
   replicates a58509e8a4ca949bf0b73ff3ab7125f7ca41bc58
M: a58509e8a4ca949bf0b73ff3ab7125f7ca41bc58 127.0.0.1:7002
   slots:[11089-16383] (5295 slots) master
   1 additional replica(s)
S: d83159b4ce61e0155d727a4f0363752471d4404d 127.0.0.1:7005
   slots: (0 slots) slave
   replicates e1503c4405a7027eb887d38b68d629fb778d119b
M: 403a66881dba0b04d1adfa512b1a831adc4a85ac 127.0.0.1:7001
   slots:[0-165],[5461-11088] (5794 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.

$ redis-cli -h 127.0.0.1 -p 7001 debug segfault
Error: Server closed the connection

$ redis-cli --cluster check 127.0.0.1:7000
Could not connect to Redis at 127.0.0.1:7001: Connection refused
127.0.0.1:7000 (e1503c44...) -> 1 keys | 5295 slots | 1 slaves.
127.0.0.1:7003 (07cff534...) -> 1 keys | 5794 slots | 0 slaves.
127.0.0.1:7002 (a58509e8...) -> 0 keys | 5295 slots | 1 slaves.
[OK] 2 keys in 3 masters.
0.00 keys per slot on average.
>>> Performing Cluster Check (using node 127.0.0.1:7000)
M: e1503c4405a7027eb887d38b68d629fb778d119b 127.0.0.1:7000
   slots:[166-5460] (5295 slots) master
   1 additional replica(s)
M: 07cff5344bd37c0547cb34549ab136232b4fff26 127.0.0.1:7003
   slots:[0-165],[5461-11088] (5794 slots) master
S: 7f19412540f133a759c7482f6c619857ca40763e 127.0.0.1:7004
   slots: (0 slots) slave
   replicates a58509e8a4ca949bf0b73ff3ab7125f7ca41bc58
M: a58509e8a4ca949bf0b73ff3ab7125f7ca41bc58 127.0.0.1:7002
   slots:[11089-16383] (5295 slots) master
   1 additional replica(s)
S: d83159b4ce61e0155d727a4f0363752471d4404d 127.0.0.1:7005
   slots: (0 slots) slave
   replicates e1503c4405a7027eb887d38b68d629fb778d119b
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.

```

关闭 `127.0.0.1:7001`, 等待一段时间，会发现已经自动完成了故障转移, `07cff5344bd37c0547cb34549ab136232b4fff26 127.0.0.1:7003` 成为了新的 Master

```shell
$ redis-server 7001/redis.conf
83727:C 15 Dec 2020 14:19:47.548 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
83727:C 15 Dec 2020 14:19:47.548 # Redis version=5.0.5, bits=64, commit=00000000, modified=0, pid=83727, just started
83727:C 15 Dec 2020 14:19:47.548 # Configuration loaded

$ redis-cli --cluster check 127.0.0.1:7000
127.0.0.1:7000 (e1503c44...) -> 1 keys | 5295 slots | 1 slaves.
127.0.0.1:7003 (07cff534...) -> 1 keys | 5794 slots | 1 slaves.
127.0.0.1:7002 (a58509e8...) -> 0 keys | 5295 slots | 1 slaves.
[OK] 2 keys in 3 masters.
0.00 keys per slot on average.
>>> Performing Cluster Check (using node 127.0.0.1:7000)
M: e1503c4405a7027eb887d38b68d629fb778d119b 127.0.0.1:7000
   slots:[166-5460] (5295 slots) master
   1 additional replica(s)
M: 07cff5344bd37c0547cb34549ab136232b4fff26 127.0.0.1:7003
   slots:[0-165],[5461-11088] (5794 slots) master
   1 additional replica(s)
S: 7f19412540f133a759c7482f6c619857ca40763e 127.0.0.1:7004
   slots: (0 slots) slave
   replicates a58509e8a4ca949bf0b73ff3ab7125f7ca41bc58
M: a58509e8a4ca949bf0b73ff3ab7125f7ca41bc58 127.0.0.1:7002
   slots:[11089-16383] (5295 slots) master
   1 additional replica(s)
S: d83159b4ce61e0155d727a4f0363752471d4404d 127.0.0.1:7005
   slots: (0 slots) slave
   replicates e1503c4405a7027eb887d38b68d629fb778d119b
S: 403a66881dba0b04d1adfa512b1a831adc4a85ac 127.0.0.1:7001
   slots: (0 slots) slave
   replicates 07cff5344bd37c0547cb34549ab136232b4fff26
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```

启动 `127.0.0.1:7001` 后，会自动加入到集群中，并作为 slave 的角色存在

- 手动故障转移

有的时候在主节点没有任何问题的情况下强制手动故障转移也是很有必要的，比如想要升级主节点的Redis进程，我们可以通过故障转移将其转为slave再进行升级操作来避免对集群的可用性造成很大的影响。

Redis集群使用 `cluster failover` 命令来进行故障转移，不过要被转移的主节点的从节点上执行该命令 手动故障转移比主节点失败自动故障转移更加安全，因为手动故障转移时客户端的切换是在确保新的主节点完全复制了失败的旧的主节点数据的前提下下发生的，所以避免了数据的丢失。

其基本过程如下：客户端不再链接我们淘汰的主节点，同时主节点向从节点发送复制偏移量,从节点得到复制偏移量后故障转移开始,接着通知主节点进行配置切换,当客户端在旧的master上解锁后重新连接到新的主节点上。

```shell
$ redis-cli -h 127.0.0.1 -p 7001 cluster failover
OK

$ redis-cli --cluster check 127.0.0.1:7000
127.0.0.1:7000 (e1503c44...) -> 1 keys | 5295 slots | 1 slaves.
127.0.0.1:7002 (a58509e8...) -> 0 keys | 5295 slots | 1 slaves.
127.0.0.1:7001 (403a6688...) -> 1 keys | 5794 slots | 1 slaves.
[OK] 2 keys in 3 masters.
0.00 keys per slot on average.
>>> Performing Cluster Check (using node 127.0.0.1:7000)
M: e1503c4405a7027eb887d38b68d629fb778d119b 127.0.0.1:7000
   slots:[166-5460] (5295 slots) master
   1 additional replica(s)
S: 07cff5344bd37c0547cb34549ab136232b4fff26 127.0.0.1:7003
   slots: (0 slots) slave
   replicates 403a66881dba0b04d1adfa512b1a831adc4a85ac
S: 7f19412540f133a759c7482f6c619857ca40763e 127.0.0.1:7004
   slots: (0 slots) slave
   replicates a58509e8a4ca949bf0b73ff3ab7125f7ca41bc58
M: a58509e8a4ca949bf0b73ff3ab7125f7ca41bc58 127.0.0.1:7002
   slots:[11089-16383] (5295 slots) master
   1 additional replica(s)
S: d83159b4ce61e0155d727a4f0363752471d4404d 127.0.0.1:7005
   slots: (0 slots) slave
   replicates e1503c4405a7027eb887d38b68d629fb778d119b
M: 403a66881dba0b04d1adfa512b1a831adc4a85ac 127.0.0.1:7001
   slots:[0-165],[5461-11088] (5794 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```

可以看到 `127.0.0.1:7001` 重新成为了 Master 节点.

### 移除节点

- 删除从节点

```shell
$ redis-cli --cluster del-node 127.0.0.1:7000 5a9186c4f68a0226353527463daf882518b16fcf
>>> Removing node 5a9186c4f68a0226353527463daf882518b16fcf from cluster 127.0.0.1:7000
>>> Sending CLUSTER FORGET messages to the cluster...
>>> SHUTDOWN the node

# 添加节点
$ redis-server 7005/redis.conf
$ redis-cli --cluster add-node --cluster-slave --cluster-master-id e1503c4405a7027eb887d38b68d629fb778d119b 127.0.0.1:7005 127.0.0.1:7000
>>> Adding node 127.0.0.1:7005 to cluster 127.0.0.1:7000
>>> Performing Cluster Check (using node 127.0.0.1:7000)
M: e1503c4405a7027eb887d38b68d629fb778d119b 127.0.0.1:7000
   slots:[166-5460] (5295 slots) master
S: 07cff5344bd37c0547cb34549ab136232b4fff26 127.0.0.1:7003
   slots: (0 slots) slave
   replicates 403a66881dba0b04d1adfa512b1a831adc4a85ac
S: 7f19412540f133a759c7482f6c619857ca40763e 127.0.0.1:7004
   slots: (0 slots) slave
   replicates a58509e8a4ca949bf0b73ff3ab7125f7ca41bc58
M: a58509e8a4ca949bf0b73ff3ab7125f7ca41bc58 127.0.0.1:7002
   slots:[11089-16383] (5295 slots) master
   1 additional replica(s)
M: 403a66881dba0b04d1adfa512b1a831adc4a85ac 127.0.0.1:7001
   slots:[0-165],[5461-11088] (5794 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
>>> Send CLUSTER MEET to node 127.0.0.1:7005 to make it join the cluster.
Waiting for the cluster to join

>>> Configure node as replica of 127.0.0.1:7000.
[OK] New node added correctly.

$ redis-cli -p 7001 cluster nodes
07cff5344bd37c0547cb34549ab136232b4fff26 127.0.0.1:7003@17003 slave 403a66881dba0b04d1adfa512b1a831adc4a85ac 0 1608013671000 10 connected
7f19412540f133a759c7482f6c619857ca40763e 127.0.0.1:7004@17004 slave a58509e8a4ca949bf0b73ff3ab7125f7ca41bc58 0 1608013670000 5 connected
403a66881dba0b04d1adfa512b1a831adc4a85ac 127.0.0.1:7001@17001 myself,master - 0 1608013670000 10 connected 0-165 5461-11088
a58509e8a4ca949bf0b73ff3ab7125f7ca41bc58 127.0.0.1:7002@17002 master - 0 1608013671146 3 connected 11089-16383
d83159b4ce61e0155d727a4f0363752471d4404d 127.0.0.1:7005@17005 slave e1503c4405a7027eb887d38b68d629fb778d119b 0 1608013670000 1 connected
e1503c4405a7027eb887d38b68d629fb778d119b 127.0.0.1:7000@17000 master - 0 1608013669000 1 connected 166-5460
```

删除的同时会关闭掉 Redis 服务; 如果重新启动被关闭的节点，然后再启动，使用 add-node 加入到集群中会出问题，需要将节点的数据和集群信息清空掉之后加入到集群中。

- 节点迁移

在Redis集群中会存在改变一个从节点的主节点的情况，需要执行如下命令 :

```shell
$ redis-cli -h 127.0.0.1 -p 7006 cluster replicate <master-id>
```

在特定的场景下，不需要系统管理员的协助下，自动将一个从节点从当前的主节点切换到另一个主节 的自动重新配置的过程叫做复制迁移, 从节点的迁移能够提高整个 Redis 集群的可用性.

## Reference

- [Redis 官方文档 - Redis 集群搭建教程](http://redis.cn/topics/cluster-tutorial.html) 这个文档里的 redis-rb-cluster 命令有些落后了，比较新的 Redis 的 Cluster 功能都集成到了 redis-cli 命令中
- [Redis 集群规范](http://redis.cn/topics/cluster-spec.html)
