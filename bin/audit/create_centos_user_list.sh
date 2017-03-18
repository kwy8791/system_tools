#!/bin/sh

source /etc/profile
source /home/`whoami`/.bash_profile

echo "user,last login, id" > /tmp/`date +'%F'`-OS-`hostname`.lst
for OS_USER in `grep -v '/sbin/nologin' /etc/passwd |awk -F':' '{print $1}'` ;do
	echo -n "`lastlog -u ${OS_USER} |grep -v '^Username'`   "
	id ${OS_USER}
done |sed -e "s/pts\/[0-9]\?//g" |sed -e "s/  \+/,/g" >> /tmp/`date +'%F'`-OS-hostname.lst

echo "List of OS user and privilege file: /tmp/`date +'%F'`-OS-hostname.lst"

exit 0
