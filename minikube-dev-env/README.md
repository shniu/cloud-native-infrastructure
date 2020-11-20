# Minikube

Building Local Development Environments with minikube.

## Environments

1. MySQL: 30306
2. Redis: 30379
3. XXL-Job: 31080
4. Eureka: 30761

使用 `kube-ip.sh` 来获取服务的 ip 地址：

```shell
$ ./kube-ip.sh
192.168.99.100
```

## Preparing Minikube

- Install

```shell
chmod +x macos-install.sh
./macos-install.sh
```

- Start

```shell
chmod +x kube-start.sh
./kube-start.sh
```

- SSH

ssh user is docker, password is tcuser

```shell
# Query minikube node ip
minikube ip

# Option 1: ssh
ssh docker@192.168.99.100
# or
ssh docker@$(minikube ip)
# password is tcuser

# Option 2
minikube ssh
```

## Building local development environment

- redis

```
// Usage:
//  Clean
./kube-clean-redis.sh
```

Ref:

1. [部署 Redis 单节点](http://www.mydlq.club/article/76/)

- xxl-job

[TODO] 目前的问题是如何初始化 xxl-job-admin 的 sql 脚本，可以考虑在创建 mysql 时把 sql 脚本挂载进去，然后在宿主机执行 mysql 客户端远程执行

## Resources

- [Aliyun Minikube](https://github.com/AliyunContainerService/minikube)
- [Minikube](https://minikube.sigs.k8s.io/)
- [有同样想法的一个项目](https://github.com/foxiswho/k8s-nacos-sentinel-rocketmq-zipkin-elasticsearch-redis-mysql)
