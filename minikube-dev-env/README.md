# Minikube

Building Local Development Environments with minikube.

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

1. [部署 Redis 单节点](http://www.mydlq.club/article/76/)

## Resources

- [Aliyun Minikube](https://github.com/AliyunContainerService/minikube)
- [Minikube](https://minikube.sigs.k8s.io/)
