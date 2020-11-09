#!/bin/bash

if ! type mysql >/dev/null 2>&1; then
    echo 'mysql 未安装';
else
    echo 'mysql 已安装';
fi