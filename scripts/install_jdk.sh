#!/bin/bash

check_user()
{
    # 判断当前用户是否为root,如果不是则退出脚本
    if [ "$(whoami)" != 'root' ];then
        echo "please use root"
        exit
    fi
}

packagename="$1"
parameter="$#"

source_install_jdk()
{
    # 源码安装jdk
    
    # 如果位置参数为0则退出脚本
    if [ "$parameter" -eq 0 ];then
        echo -e "\033[31m scripts_format: sh install_jdk.sh jdk***.tar.gz \033[0m"
        exit 0
    fi
    
    tar xf ./"$packagename" && find ./ -maxdepth 1 -type d -amin -1 -name 'jdk*' -exec mv {} /usr/local/java \;
    echo -e 'export JAVA_HOME=/usr/local/java\nexport PATH=$JAVA_HOME/bin:$PATH' >> /etc/profile

    . /etc/profile
    java -version &>/dev/null
    if [ $? -eq 0 ] ;then
        echo "java install success"
        exit 0
    else
        echo "java install fail"
        exit 2
    fi
}
check_user
source_install_jdk
