#!/bin/sh

source ${myscript_home}/conf/common_settings.sh

#################################
# reboot
#################################
f_eecho "================================================================="
f_eecho  "Start reboot OS operation."
f_necho "Do you want to execute this operation? (Y/n): "

read yesno
yesno=${yesno:-Y}
while [ 1 ]; do
	if [ \( "${yesno}" = "y" \) -o \( "${yesno}" = "Y" \) ]; then
		f_eecho "GOOD BY. SEE YOU AGAIN!"
		if [ -x `which init` ]; then
			init 6
		elif [ -x `which reboot` ]; then
			reboot
		elif [ -x `which shutdown` ]; then
			shutdonw -r now
		else
			f_eecho "......Sorry. I don't know how to reboot this system. Please reboot manually after finishing this script. X( "
		fi
		break
	elif [ \( "${yesno}" = "n" \) -o \( "${yesno}" = "N" \) ]; then
		f_eecho "Operation passed. Continuing...."
		break
	else
		f_eecho  "Please input y|Y|n|N."
		fnf_eecho "Do you want to execute this operation? (Y/n): "
		read yesno
	fi
done

f_eecho "Finish All Operations. See You Again someday, somewhere...."

