#!/bin/sh

source /conf/common_settings.sh

#################################
# set auto logging
#################################
f_eecho "================================================================="
f_eecho "Start setting of auto-logging on ssh-login."
f_necho "Do you want to execute this operation? (Y/n): "
read yesno
yesno=${yesno:-Y}
while [ 1 ]; do
	if [ \( "${yesno}" = "y" \) -o \( "${yesno}" = "Y" \) ]; then

		# /* ここは設定先が/etc/profileで良いのかな？ */
		cat <<- EOF >> /etc/profile

		# set auto logging all commands
		if [ ! -d /var/tmp/infrawork/log/history ]; then
			mkdir /var/tmp/infrawork/log/history
			chmod 777 /var/tmp/infrawork/log/history
		fi
		EOF
		echo '/var/tmp/infrawork/log/history/`date +%Y%m%d-%H%M%S`-${USER}.log' >> /etc/profile
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

f_eecho "Finished auto-logging setting."


exit 0

