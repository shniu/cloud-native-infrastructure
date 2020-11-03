# Kubernetes

Play with Kubernetes.

## Kubernetes Componments

### Install kubernetes client

如果要操作 kubernetes 集群，可以使用命令行工具 kubectl

```shell
# install kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl/

# 1. curl kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.19.0/bin/darwin/amd64/kubectl
chmod +x ./kubectl

# 2. move to user path
mv ./kubectl /usr/local/bin/kubectl

# 3. test kubectl
kubectl version

# 4. In order for kubectl to find and access a Kubernetes cluster, it needs a kubeconfig file
#  By default, kubectl configuration is located at ~/.kube/config
# https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/
# @see cloud-native-infrastructure/kubernetes-vagrant-centos-cluster/conf/admin.kubeconfig
```
