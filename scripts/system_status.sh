#!/bin/bash

# 查看当前操作系统版本
system=$(cat /etc/issue|egrep -i -o 'os|ubuntu'|tr [A-Z] [a-z])
case $system in
    os)
        echo -e "\t\tCentos\n"
    ;;
    ubuntu)
        echo -e "\t\tUbuntu\n"
    ;;
esac

# 内存使用情况
free -m|awk 'NR==2{print "内存:\ntotal: " $2"M  used: "$3"M  free: "$4"M"} END {print "--------------------------------------------"}'

# 磁盘使用情况
df -h|awk '{printf "%-10s %-10s\n",$1,$5} END {print "--------------------------------------------"}'


