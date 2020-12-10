
```shell

minikube kubectl -- exec -it redis-cluster-0 -- redis-cli --cluster create --cluster-replicas 1 $(minikube kubectl -- get pods -l app=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP}:6379 ' | awk '{$NF="";print}')

# 获取到 redis cluster 所有节点的 ip:port
minikube kubectl -- get pods -l app=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP}:6379 ' | awk '{$NF="";print}'

for x in $(seq 0 5); do echo "redis-cluster-$x"; minikube kubectl -- exec redis-cluster-$x -- redis-cli role; echo; done

# 检测集群状态
minikube kubectl -- exec -it redis-cluster-0 -- redis-cli --cluster check redis-cluster-0.redis-cluster:6379

minikube kubectl -- exec -it redis-cluster-0 -- redis-cli --cluster check redis-cluster-0.redis-cluster.default.svc.cluster.local:6379

minikube kubectl -- exec -it redis-cluster-4 -- redis-cli --cluster check redis-cluster-2.redis-cluster.default.svc.cluster.local:6379

minikube kubectl -- exec -it redis-cluster-4 -- redis-cli --cluster check 172.17.0.11:6379

# via: https://kubernetes.io/zh/docs/concepts/workloads/controllers/statefulset/

for i in $(seq 0 5); do minikube kubectl -- exec redis-cluster-$i -- sh -c 'hostname'; done

# 一个提供 nslookup 命令的容器，该命令来自于 dnsutils 包。通过对 Pod 的主机名执行 nslookup，你可以检查他们在集群内部的 DNS 地址
minikube kubectl -- run -i --tty --image busybox:1.28 dns-test --restart=Never --rm
/ # nslookup redis-cluster-0.redis-cluster
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      redis-cluster-0.redis-cluster
Address 1: 172.17.0.10 redis-cluster-0.redis-cluster.default.svc.cluster.local
/ # nslookup redis-cluster-3.redis-cluster
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      redis-cluster-3.redis-cluster
Address 1: 172.17.0.13 redis-cluster-3.redis-cluster.default.svc.cluster.local

# 监控 pods 的变动情况
kubectl get po -l app=redis-cluster -w
```

### Resource

- https://kubernetes.io/zh/docs/tutorials/stateful-application/basic-stateful-set/
- https://kubernetes.io/zh/docs/tasks/run-application/run-replicated-stateful-application/
- https://www.infoq.cn/article/lurk0tgtgkc9iwcl7sqm