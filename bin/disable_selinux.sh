#!/bin/sh

source /conf/common_settings.sh

#################################
# disable selinux
#################################
f_eecho "================================================================="
f_eecho "Start setting to selinux be disabled."
f_necho "Do you want to execute this operation? (Y/n): "


read yesno
yesno=${yesno:-Y}
while [ 1 ]; do
	if [ \( "${yesno}" = "y" \) -o \( "${yesno}" = "Y" \) ]; then
		if [ -e /etc/selinux/config ];then
			cp -ip --parents /etc/selinux/config /var/tmp/infrawork/bkup
			sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config
			diff /etc/selinux/config /var/tmp/infrawork/bkup/etc/selinux/config
		else
			f_eecho "Cannot find /etc/selinux/config file. try to execute 'setenforce' command."
			if [ -x `which setenforce` ]; then
				setenforce 0
			else
				f_eecho "Cannot find 'setenforce' command. skipping...."
			fi
		fi
		break
	elif [ \( "${yesno}" = "n" \) -o \( "${yesno}" = "N" \) ]; then
		f_eecho "Operation passed. Continuing...."
		break
	else
		f_eecho "Please input y|Y|n|N."
		f_necho "Do you want to execute this operation? (Y/n): "
		read yesno
	fi
done

f_eecho "Finished selinux disabled. (But need reboot)"


exit 0

