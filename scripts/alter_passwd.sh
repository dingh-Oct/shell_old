#!/bin/bash

# 查看当前目录下信息文件(info.txt)是否存在
if [ ! -f 'info.txt' ];then
    echo -e "\033[31;40m info.txt file does not exist \033[0m"
    echo -e "file format: 远程主机   登录用户 登录密码 修改用户 修改密码\nexample    : 192.168.1.1 root    rootpass text     testpass"
    exit 0
fi

while read line
do
    host=$(echo $line|awk '{print $1}')
    user=$(echo $line|awk '{print $2}')
    pass=$(echo $line|awk '{print $3}')
    port=$(echo $line|awk '{print $4}')
    user2=$(echo $line|awk '{print $5}')
    pass2=$(echo $line|awk '{print $6}')

    $(which expect) << EOF
    set timeout 10
 
    spawn ssh -p$port $user@$host
    expect {
        "(yes/no)?" { 
            send "yes\r"
            expect "*password"
            send "$pass\r"
        }
        "*password" {
            send "$pass\r"
        }
    }
    
    expect {
        "*#*" {
            send "passwd $user2\r"
            expect "*password:"
            send "$pass2\r"
            expect "*password:"
            send "$pass2\r"
            send "exit 1\r"
            expect eof
        }
        "*\$*" {
            send "sudo su -\r"
            expect "$user:"
            send "$pass\r"
            expect "#"
            send "passwd $user2\r"
            expect "*password:"
            send "$pass2\r"
            expect "*password:"
            send "$pass2\r"
            send "exit 1\r"
            expect eof
        }
    }
EOF
done < info.txt
