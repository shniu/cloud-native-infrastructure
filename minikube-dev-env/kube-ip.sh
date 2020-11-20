#!/bin/bash

ip=$(minikube ip)
echo "Your minikube node ip is $ip"

# doInit=false
# name="Null"

# function usage() {
#     echo -e "kube-start provides the following features: \n"
#     echo -e "Options"
#     echo -e "    -i, --init  执行初始化操作，默认不执行"
#     echo -e "    --name      指定名称, e.g. --name abc"
#     echo -e "    -h, --help  查看帮助"
# }

# while [ "$1" != "" ]; do
#     case $1 in
#         -i | --init )  doInit=true
#                        ;;
#         -a          )  shift
#                        name="$1"
#                        ;;
#         -h | --help )  usage
#                        exit 0
#                        ;;
#         * )            usage
#                        exit 1
#     esac
#     shift
# done

# if $doInit ; then
#     echo -e "do init"
# fi

# echo $name
