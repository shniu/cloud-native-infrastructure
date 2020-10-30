
# Install kubernetes cluster using vagrant and VirtualBox

参考：[rootsongjc/kubernetes-vagrant-centos-cluster](https://github.com/rootsongjc/kubernetes-vagrant-centos-cluster/blob/master/README-cn.md)，特别感谢 https://jimmysong.io/ (@jimmysong, Github https://github.com/rootsongjc)


## Required

1. 使用3个虚拟节点
2. centos7 操作系统
3. vagrant + virtualbox

## Install

- 准备工作

```shell
# clone 项目
git clone https://github.com/shniu/kubernetes-vagrant-centos-cluster.git

# Note: 几个准备工作
1. 下载 virtualbox，并安装, 使用的版本是 v6.1.14
2. 下载 vagrant 并安装，使用的版本是 Vagrant 2.2.10
3. 下载 centos7 的 box
wget -c http://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7-x86_64-Vagrant-1801_02.VirtualBox.box
vagrant box add CentOS-7-x86_64-Vagrant-1801_02.VirtualBox.box --name centos/7

4. 下载 kubernetes-server-linux-amd64.tar.gz, 并放在 kubernetes-vagrant-centos-cluster 目录下
cd kubernetes-vagrant-centos-cluster
wget https://storage.googleapis.com/kubernetes-release/release/v1.15.0/kubernetes-server-linux-amd64.tar.gz

5. 在宿主件安装 kubectl 命令，在宿主机新建一个目录，然后
wget https://storage.googleapis.com/kubernetes-release/release/v1.15.0/kubernetes-client-darwin-amd64.tar.gz
tar xvf kubernetes-client-darwin-amd64.tar.gz && cp kubernetes/client/bin/kubectl /usr/local/bin

# 配置 kubectl 的默认行为
mkdir -p ~/.kube
# conf/admin.kubeconfig 是 clone 下来的 kubernetes-vagrant-centos-cluster 中的文件
cp conf/admin.kubeconfig ~/.kube/config
```

- 修改项目中的配置文件

1. 添加 vm 中的 dns，否则无法正常下载包

```shell
echo 'set nameserver'
echo "nameserver 8.8.8.8">/etc/resolv.conf
# New added
echo "nameserver 192.168.154.1" > /etc/resolv.conf
cat /etc/resolv.conf
```

其中 echo "nameserver 192.168.154.1" > /etc/resolv.conf 是新加的，192.168.154.1 是自己宿主机上的出口网关，这样可以解决 Could not resolve host: mirrors.163.com 的问题

2. 由于项目中使用的镜像无法下载，更改为速度更快的阿里云上的镜像，会加速部署过程
阿里云的镜像地址前缀为 registry.aliyuncs.com/google_containers，等同于 k8s.gcr.io 和 gcr.io/google_containers

替换 node1/kubelet, node2/kubelet, node3/kubelet 中的 KUBELET_POD_INFRA_CONTAINER="--pod-infra-container-image=jimmysong/pause-amd64:3.0" 为 KUBELET_POD_INFRA_CONTAINER="--pod-infra-container-image=registry.aliyuncs.com/google_containers/pause-amd64:3.0"

- 启动

```shell
$ vagrant up
```

- 访问

1. 在宿主机上访问，可以使用在准备工作中已经配置好的 kubectl，推荐的方式

```shell
// run
$ kubectl get nodes
NAME    STATUS   ROLES    AGE    VERSION
node1   Ready    <none>   127m   v1.15.0
node2   Ready    <none>   125m   v1.15.0
node3   Ready    <none>   122m   v1.15.0

$ kubectl get pods -n kube-system
NAME                                              READY   STATUS              RESTARTS   AGE
coredns-5b8f74cc56-4txzv                          0/1     ContainerCreating   0          122m
coredns-5b8f74cc56-5tzc5                          1/1     Running             0          122m
heapster-v1.5.0-85b799b7f6-wx5nb                  0/4     ContainerCreating   0          39m
kubernetes-dashboard-55cf6d9484-qspqm             1/1     Running             0          110m
monitoring-influxdb-grafana-v4-7fcb5bb859-n6prs   0/2     ContainerCreating   0          82m
traefik-ingress-controller-l4g85 
```

2. 虚拟机内部访问，这样太麻烦，不推荐

3. 使用 dashboard
在 vagrant up 启动成功后，会获得一个 token，复制这个token，打开 https://172.17.8.101:8443 ，输入 token 即可访问

- 关闭集群

```shell
# 在宿主机上执行
$ vagrant halt
```

## 问题列表

- 什么是 pause container ? 看这里：https://github.com/rootsongjc/kubernetes-handbook/blob/master/concepts/pause-container.md 为了解决 pod 中的共享网络问题，是一个最基础的容器

- 查看状态的几个命令

```shell
# 查询节点
kubectl get nodes

# 查询 pods
kubectl get pods -n kube-system

# 查看某个 pod 的详情
kubectl describe pod heapster-v1.5.0-85b799b7f6-wx5nb -n kube-system

# 查看 pod 日志
kubectl logs -f pods/kubernetes-dashboard-55cf6d9484-qspqm -n kube-system
```
