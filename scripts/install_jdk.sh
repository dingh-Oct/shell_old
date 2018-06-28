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
install_dir='/usr/local/java'

source_install_jdk()
{
    # 源码安装jdk
    
    # 如果位置参数为0则退出脚本
    if [ "$parameter" -eq 0 ];then
        echo -e "\033[31m scripts_format: sh install_jdk.sh jdk***.tar.gz \033[0m"
        exit 0
    fi
     
    tar xf ./"$packagename" && find ./ -maxdepth 1 -type d -amin -1 -name 'jdk*' -exec mv {} "$install_dir" \;

    # 修改环境变量
    path1=$(egrep '^JAVA_HOME' /etc/profile)
    if [ -z "$path1" ];then
        echo -e "JAVA_HOME="$install_dir"\nexport PATH=$JAVA_HOME/bin:$PATH" >> /etc/profile
    else
        sed -ir "s/^JAVA_HOME=(.*)/JAVA_HOME="$install_dir"/" /etc/profile
    fi

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

check_install()
{
    check_user
    # 检查本机是否安装java
    java -version &>/dev/null
    if [ $? -eq 0 ];then
        read -p "$(echo -e 'java already installed\n1. unstall\n任意键退出 >>>: ')" remove
        case $remove in
          1)
            yum remove java &>/dev/null
            mv $(egrep 'JAVA_HOME=(.*)' /etc/profile|awk -F'=' '{print $2}') /opt/
            sed -i '/JAVA_HOME=/d' /etc/profile
          ;;
          *)
            exit 0
          ;;
        esac
    fi
    source_install_jdk
}
check_install
