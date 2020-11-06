#!/bin/bash

echo 'minikube start...'
minikube start --driver=virtualbox \
    --image-mirror-country cn \
    --iso-url=https://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/iso/minikube-v1.13.0.iso \
    --registry-mirror=https://ncf649yh.mirror.aliyuncs.com \
    --memory=3096