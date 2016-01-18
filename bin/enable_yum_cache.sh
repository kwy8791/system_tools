#!/bin/sh

source /conf/common_settings.sh

#################################
# enable yum cache
#################################
f_eecho "================================================================="
f_eecho "Start configuration for save rpm files...."
f_eecho "*** But files vanish and never restore, when you will type ... ***"
f_eecho "*** uh like 'yum clean all' / 'yum clean packages' e.t.c.... ***"
f_necho "Do you want to execute this operation? (Y/n): "

read yesno
yesno=${yesno:-Y}
while [ 1 ]; do
	if [ \( "${yesno}" = "y" \) -o \( "${yesno}" = "Y" \) ]; then
		if [ -e /etc/yum.conf ]; then
			cp -ip --parents /etc/yum.conf /var/tmp/infrawork/bkup
			sed -i -e "s/^keepcache=0/keepcache=1/" /etc/yum.conf
			diff /etc/yum.conf /var/tmp/infrawork/bkup/etc/yum.conf || echo -n
		else
			f_eecho "Cannot find /etc/yum.conf. skipping...."
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

f_eecho "Finished change setting of yum cache."


exit 0

