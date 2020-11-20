#!/bin/bash

dir=$(pwd)
echo "Working directory: $dir"

# ----------------------------------------------------------------
# mysql-client@5.7 is keg-only, which means it was not symlinked into /usr/local,
# because this is an alternate version of another formula.

# If you need to have mysql-client@5.7 first in your PATH run:
#   echo 'export PATH="/usr/local/opt/mysql-client@5.7/bin:$PATH"' >> ~/.zshrc

# For compilers to find mysql-client@5.7 you may need to set:
#   export LDFLAGS="-L/usr/local/opt/mysql-client@5.7/lib"
#   export CPPFLAGS="-I/usr/local/opt/mysql-client@5.7/include"

# For pkg-config to find mysql-client@5.7 you may need to set:
#   export PKG_CONFIG_PATH="/usr/local/opt/mysql-client@5.7/lib/pkgconfig"
function checkDependencies() {
    echo '=== Check dependencies and automatically installs them when required ==='

    if ! type mysql >/dev/null 2>&1; then
        echo 'Install mysql-client 5.7 ...'
        brew install mysql-client@5.7
        # echo 'export PATH="/usr/local/opt/mysql-client@5.7/bin:$PATH"' >> ~/.zshrc
        echo 'export PATH="/usr/local/opt/mysql-client@5.7/bin:$PATH"' >> ~/.bash_profile
        source ~/.bash_profile
    else
        echo 'mysql-client already installed.';
    fi

    echo -e "=== Dependency checking completed === \n"
}

# check first
checkDependencies

echo '=== Starting minikube ==='
minikube start --driver=virtualbox \
    --image-mirror-country cn \
    --iso-url=https://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/iso/minikube-v1.13.0.iso \
    --registry-mirror=https://ncf649yh.mirror.aliyuncs.com \
    --mount --mount-string=".:/data" \
    --memory=3096
echo -e "=== minikube started === \n"

echo '=== Deploy mysql... ==='
minikube kubectl -- apply -f resources/mysql-service.yaml
echo -e "=== Deploy mysql finished \n"

echo '=== Deploy redis... ==='
minikube kubectl -- apply -f resources/redis-service.yaml
echo -e "=== Deploy redis finished \n"

echo -e "=== Deploy RocketMQ... === \n"

# echo 'Start Spirng Cloud Config...'
# https://hub.docker.com/r/hyness/spring-cloud-config-server

echo -e "=== Deploy Spring Euraka ==="
# https://github.com/BitInit/eureka-on-kubernetes
minikube kubectl -- apply -f resources/eureka-service.yaml
echo -e "=== Deploy Eureka finished === \n"

echo '=== Start XXL-JOB Scheduler Center...'
# Sleep 30s waiting for mysql to start successfully
echo "Sleep 30s waiting for mysql to start successfully"
sleep 30s

echo 'Kube init'
. kube-init.sh
echo -e "Kube init finished"

minikube kubectl -- apply -f resources/xxl-service.yaml
echo -e "=== Deploy XXL-JOB finished === \n"

echo "Deploy finished."