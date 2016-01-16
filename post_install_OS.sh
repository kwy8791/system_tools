#!/bin/sh

#################################
# is_root?
#################################

#################################
# is_admin?
#################################

#################################
# enable yum cache
#################################

#################################
# create system directory
#################################
mkdir -p /var/tmp/infrawork/{src,log,rpm,bkup}
mkdir -p /var/tmp/infrawork/src/{archived,extracted}
chmod -R 777 /var/tmp/infrawork/

#################################
# disable selinux
#################################
/usr/sbin/setenforce 0
/usr/bin/sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config

#################################
# start sshd
#################################
/usr/bin/systemctl start sshd.service
/usr/bin/systemctl enable sshd.service

#################################
# create user
#################################
# loop
#   new group?
#   username?
#   uid?
#   gid?
# loop


#################################
# setting for ssh client
#################################
# whom for setting
/usr/bin/echo "whom for ssh setting?"
/usr/bin/read user_name
user_dir=/home/${user_name}

/usr/bin/mkdir ${user_dir}/.ssh
/usr/bin/echo "input your ssh key"
/usr/bin/read "$sshkeychane"
# /* ↑ここ、スペース含んでもちゃんと動くか要確認 */
/usr/bin/echo ${sshkeychane} >> ${user_dir}/.ssh/authorized_keys
/usr/bin/chown -R ${user_name} ${user_dir}/.ssh
/usr/bin/chmod -R 700 ${user_dir}/.ssh

#################################
# format and size setting for history command
#################################
# /* ここは設定先が/etc/profileで良いのかな？ */
cat << EOF >> /etc/profile

# history command environment
HISTTIMEFORMAT='%y/%m/%d %H:%M:%S ';
HISTFILESIZE=
HISTSIZE=
EOF

#################################
# yum upgrade
#################################
/usr/bin/yum upgrade

#################################
# reboot
#################################
/usr/sbin/init 6


