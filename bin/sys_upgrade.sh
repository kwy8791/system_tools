#!/bin/sh

source ${myscript_home}/conf/common_settings.sh

#################################
# yum upgrade
#################################
f_eecho "================================================================="
f_eecho "Start 'yum -y upgrade' command."
f_eecho "(Maybe execute 'dnf' command.)"
f_necho "Do you want to execute this operation? (Y/n): "

read yesno
yesno=${yesno:-Y}
while [ 1 ]; do
	if [ \( "${yesno}" = "y" \) -o \( "${yesno}" = "Y" \) ]; then
		
		if [ -x `which dnf` ]; then
			dnf -y upgrade
		elif [ -x `which yum` ]; then
			yum -y upgrade
		else
			f_eecho "......Sorry. I don't know how to update this system. Please update manually after finishing this script. X( "
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

f_eecho "Finished executing system upgrade."

