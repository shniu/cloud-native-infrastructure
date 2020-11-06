#!/bin/bash

echo 'Download minikube and install'
curl -Lo minikube https://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/releases/v1.13.0/minikube-darwin-amd64 
chmod +x minikube 
sudo mv minikube /usr/local/bin/
