#!/bin/bash

# Parameters
doInit=false
mysql=true
redis=true
eureka=true
xxlJob=true
rocketMQ=true
bitgo=false

demo="None"

function usage() {
    echo -e "kube-start provides the following features: \n"
    echo -e "Options"
    echo -e "    -i, --init            执行初始化操作，默认不执行"
    echo -e "    --disable-mysql       不启动 mysql service，默认启动"
    echo -e "    --disable-redis       不启动 redis service，默认启动"
    echo -e "    --disable-eureka      不启动 eureka service，默认启动"
    echo -e "    --disable-xxl-job     不启动 xxl-job service，默认启动"
    echo -e "    --disable-rocketmq    不启动 rocketMQ service，默认启动"
    echo -e "    --enable-bitgo        启动 BitGo service，默认不启动"
    echo -e "    -h, --help            查看帮助"
}

while [ "$1" != "" ]; do
    case $1 in
        -i | --init       )         doInit=true
                                    ;;
        --demo            )         shift
                                    demo="$1"
                                    ;;
        --disable-mysql   )         mysql=false
                                    ;;
        --disable-redis   )         redis=false
                                    ;;
        --disable-eureka  )         eureka=false
                                    ;;
        --disable-xxl-job )         xxlJob=false
                                    ;;
        --disable-xxl-job )         rocketMQ=false
                                    ;;
        --enable-bitgo    )         bitgo=true
                                    ;;
        -h | --help       )         usage
                                    exit 0
                                    ;;
        *                 )         usage
                                    exit 1
    esac
    shift
done

dir=$(pwd)
echo -e "Working directory: $dir \n"

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
    --mount=true \
    # --mount-string=".:/data" \
    --memory=3096mb
# minikube start --driver=docker \
#     --image-mirror-country cn \
#     --iso-url=https://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/iso/minikube-v1.13.0.iso \
#     --registry-mirror=https://ncf649yh.mirror.aliyuncs.com \
#     --mount=true \
#     --memory=3096mb \
#     --cpus=2
echo -e "=== minikube started === \n"

if $mysql ; then
    echo '=== Deploy mysql... ==='
    minikube kubectl -- apply -f resources/mysql-service.yaml
    echo -e "=== Deploy mysql finished === \n"
else
    minikube kubectl -- scale --replicas=0 deployment/mysql
    echo -e "=== Disable mysql service === \n"
fi

if $redis ; then
    echo '=== Deploy redis... ==='
    minikube kubectl -- apply -f resources/redis-service.yaml
    echo -e "=== Deploy redis finished === \n"
else
    minikube kubectl -- scale --replicas=0 deployment/redis
    echo -e "=== Disable redis service === \n"
fi

if $rocketMQ ; then
    echo -e "=== Deploy RocketMQ... === \n"
fi

# echo 'Start Spirng Cloud Config...'
# https://hub.docker.com/r/hyness/spring-cloud-config-server

if $eureka ; then
    echo -e "=== Deploy Spring Euraka ==="
    # https://github.com/BitInit/eureka-on-kubernetes
    minikube kubectl -- apply -f resources/eureka-service.yaml
    echo -e "=== Deploy Eureka finished === \n"
else
    minikube kubectl -- scale --replicas=0 statefulsets/eureka
    echo -e "=== Disable Eureka service === \n"
fi

if $xxlJob ; then
    echo '=== Start XXL-JOB Scheduler Center...'
    # Sleep 30s waiting for mysql to start successfully

    if $doInit ; then
        echo "Sleep 30s waiting for mysql to start successfully"
        sleep 30s

        echo 'Kube init'
        . kube-init.sh --init-database
        echo -e "Kube init finished"
    fi

    minikube kubectl -- apply -f resources/xxl-service.yaml
    echo -e "=== Deploy XXL-JOB finished === \n"
else
    minikube kubectl -- scale --replicas=0 deployment/xxl-job
    echo -e "=== Disable XXL-JOB === \n"
fi

if $bitgo ; then
    echo '=== Start BitGo express service...'
    minikube kubectl -- apply -f resources/bitgo-express-service.yaml
else
    minikube kubectl -- scale --replicas=0 deployment/bitgo
    echo -e "=== Disable bitgo express service === \n"
fi

echo "Deploy finished."