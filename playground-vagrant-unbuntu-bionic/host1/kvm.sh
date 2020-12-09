#!/bin/bash

sudo virt-install -n "kvm01" \
  --description "kvm server"  \
  --os-type=linux \
  --os-variant=ubuntu18.04  \
  --ram=1024 \
  --vcpus=1  \
  # 磁盘位置，大小 5G
  --disk path=/var/lib/libvirt/images/kvm01.img,bus=virtio,size=5 \
  # 这里网络选择了桥接模式
  --network bridge:virbr0 \
  --accelerate \
  # VNC 监听端口，注意要选择 en-us 作为 key-map，否则键位布局可能会乱
  --graphics vnc,listen=0.0.0.0,keymap=en-us \
  # 安装 ISO 路径
  --cdrom /vagrant/ubuntu-18.04.5-live-server-amd64.iso