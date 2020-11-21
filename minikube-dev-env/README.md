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

# 查看 kube-start.sh 提供的功能
./kube-start.sh -h
kube-start provides the following features: 

Options
    -i, --init            执行初始化操作，默认不执行
    --disable-mysql       不启动 mysql service，默认启动
    --disable-redis       不启动 redis service，默认启动
    --disable-eureka      不启动 eureka service，默认启动
    --disable-xxl-job     不启动 xxl-job service，默认启动
    --disable-rocketmq    不启动 rocketMQ service，默认启动
    -h, --help            查看帮助

# 比如不启动 eureka
./kube-start.sh --disable-eureka
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


## Resources

- [Aliyun Minikube](https://github.com/AliyunContainerService/minikube)
- [Minikube](https://minikube.sigs.k8s.io/)
- [有同样想法的一个项目](https://github.com/foxiswho/k8s-nacos-sentinel-rocketmq-zipkin-elasticsearch-redis-mysql)
