# Etcd

## Install

- [play.etcd.io](http://play.etcd.io/install)
- [etcd releases](https://github.com/etcd-io/etcd/releases)
- 单机测试 

```shell
ETCD_VER=v3.4.13

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}

rm -f /tmp/etcd-${ETCD_VER}-darwin-amd64.zip
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-darwin-amd64.zip -o /tmp/etcd-${ETCD_VER}-darwin-amd64.zip
unzip /tmp/etcd-${ETCD_VER}-darwin-amd64.zip -d /tmp && rm -f /tmp/etcd-${ETCD_VER}-darwin-amd64.zip
mv /tmp/etcd-${ETCD_VER}-darwin-amd64/* /tmp/etcd-download-test && rm -rf mv /tmp/etcd-${ETCD_VER}-darwin-amd64

/tmp/etcd-download-test/etcd --version
/tmp/etcd-download-test/etcdctl version
```

## Etcd Clustering

```shell
# 下载并安装 etcd

# 合理规划集群，至少 3 个节点，最好 5 个或者 7 个
# 启动集群，分别执行
etcd --config-file clustering/s1.config.yml
etcd --config-file clustering/s2.config.yml
etcd --config-file clustering/s3.config.yml
```
