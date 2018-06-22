#!/bin/bash

check_user
{
    # 判断当前用户是否为root,如果不是则退出脚本
    if [ "$(whoami)" != 'root' ];then
        echo "please use root"
        exit
    fi
}

source_install_jdk()
{
# 源码安装jdk-1.8
packname='jdk-8u60-linux-x64.tar.gz'
tar xf ./"$packname" && mv jdk1.8.0_60 /usr/local/java
cat >> /etc/profile << EOF
export JAVA_HOME=/usr/local/java
export PATH=$JAVA_HOME/bin:$PATH
EOF
. ./etc/profile
if java -version &>/dev/null ;then
    echo "jdk-1.8 install success"
    exit 0
else
    echo "jdk-1.8 install fail"
    exit 2
fi
}
check_user
source_install_jdk
