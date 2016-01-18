#!/bin/sh

source /conf/common_settings.sh

#################################
# create system directory
#################################
f_eecho "================================================================="
f_eecho "Start creating system-admins' directories."
f_necho "Do you want to execute this operation? (Y/n): "

read yesno
yesno=${yesno:-Y}
while [ 1 ]; do
	if [ \( "${yesno}" = "y" \) -o \( "${yesno}" = "Y" \) ]; then
		if [ -d /var/tmp ]; then
			f_eecho "creating /var/tmp/infrawork/{src,log,rpm,bkup}"
			mkdir -p /var/tmp/infrawork/{src,log,rpm,bkup}
			f_eecho "creating /var/tmp/infrawork/src/{archived,extracted}"
			mkdir -p /var/tmp/infrawork/src/{archived,extracted}
			f_eecho "change mode of directories"
			chmod -R 777 /var/tmp/infrawork/
			f_eecho "\e[1;30;42m SUCCESS! \e[m"
			f_eecho "created directories list. (result of ls -ld)"
			f_eecho "`ls -ld /var/tmp/infrawork/{src,log,rpm,bkup} /var/tmp/infrawork/src/{archived,extracted}`"
		else
			f_eecho "\e[1;37;41m Cannot find /var/tmp directory. skipping.... \e[m"
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

f_eecho "Finished creating directories. Continuing...."


exit 0

