#!/bin/bash

ip=$(minikube ip)
echo $ip

# minikube start --driver=docker \
#     --image-mirror-country cn \
#     --iso-url=https://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/iso/minikube-v1.13.0.iso \
#     --registry-mirror=https://ncf649yh.mirror.aliyuncs.com \
#     --mount=true \
#     --memory=3096mb \
#     --cpus=2