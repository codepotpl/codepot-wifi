#!/bin/bash -ex

if [ "$(id -u)" != "0" ]; then
   echo "Sudo !" 1>&2
   exit 1
fi

ifconfig eth0 down
ifconfig eth0 192.168.1.2 netmask 255.255.255.0
sleep 10

ifconfig eth0
ping -c1 192.168.1.1
expect << EOF
   spawn telnet 192.168.1.1 23
   expect -re ".*#"
   set timeout 60
   send "\r"
   expect -re ".*#"
   send "firstboot\r"
   expect -re ".*#"
   send "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDOVOZf5o/ebmsYOSoHwMOH6R92K+mIU+sVWg5isar6VsPW9AM8x/BCmrDIS8RSQy6juLkPF5kMD+HXHOMX+oJc9AtLjYsS/R+qxalu2cgFbqNAYKwquq4Ob7JEgLKkWz5RkeLqDh4+8wRyl8WaBChwpsxoGwIWdLd46QARlUq0Mw== marcin@codepot.pl' > /etc/dropbear/authorized_keys\r"
   expect -re ".*#"
   send "exit\r"
EOF
