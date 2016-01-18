#!/bin/sh

source /conf/common_settings.sh

#################################
# format and size setting for history command
#################################
f_eecho "================================================================="
f_eecho "Start changing format of 'history' command."
f_necho "Do you want to execute this operation? (Y/n): "

read yesno
yesno=${yesno:-Y}
while [ 1 ]; do
	if [ \( "${yesno}" = "y" \) -o \( "${yesno}" = "Y" \) ]; then
		# /* ここは設定先が/etc/profileで良いのかな？ */
		cat <<- EOF >> /etc/profile
	
		# history command environment
		export HISTTIMEFORMAT='%y/%m/%d %H:%M:%S ';
		export HISTFILESIZE=
		export HISTSIZE=
		EOF

		f_eecho "Finished changing format of 'history' command."
		break
	elif [ \( "${yesno}" = "n" \) -o \( "${yesno}" = "N" \) ]; then
		break
	else
		f_eecho "Please input y|Y|n|N."
		f_necho "Do you want to execute this operation? (Y/n): "
		read yesno
	fi
done

f_eecho "Finish changing history format. Continuing...."


exit 0

