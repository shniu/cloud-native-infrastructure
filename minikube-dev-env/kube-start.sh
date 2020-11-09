#!/bin/bash

dir=$(pwd)
echo "$dir"

# mysql-client@5.7 is keg-only, which means it was not symlinked into /usr/local,
# because this is an alternate version of another formula.

# If you need to have mysql-client@5.7 first in your PATH run:
#   echo 'export PATH="/usr/local/opt/mysql-client@5.7/bin:$PATH"' >> ~/.zshrc

# For compilers to find mysql-client@5.7 you may need to set:
#   export LDFLAGS="-L/usr/local/opt/mysql-client@5.7/lib"
#   export CPPFLAGS="-I/usr/local/opt/mysql-client@5.7/include"

# For pkg-config to find mysql-client@5.7 you may need to set:
#   export PKG_CONFIG_PATH="/usr/local/opt/mysql-client@5.7/lib/pkgconfig"
if ! type mysql >/dev/null 2>&1; then
    echo 'Install mysql-client 5.7 ...'
    brew install mysql-client@5.7
    # echo 'export PATH="/usr/local/opt/mysql-client@5.7/bin:$PATH"' >> ~/.zshrc
    echo 'export PATH="/usr/local/opt/mysql-client@5.7/bin:$PATH"' >> ~/.bash_profile
    source ~/.bash_profile
else
    echo 'mysql-client already installed.';
fi

echo 'minikube start...'
minikube start --driver=virtualbox \
    --image-mirror-country cn \
    --iso-url=https://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/iso/minikube-v1.13.0.iso \
    --registry-mirror=https://ncf649yh.mirror.aliyuncs.com \
    --mount --mount-string=".:/data" \
    --memory=3096

echo 'Start mysql...'
minikube kubectl -- apply -f resources/mysql-service.yaml

echo 'Start redis...'
minikube kubectl -- apply -f resources/redis-service.yaml

echo 'Start XXL-JOB Scheduler Center...'

echo 'Start RocketMQ...'

echo 'Start Spirng Cloud Config...'

echo 'Start Spring Euraka...'