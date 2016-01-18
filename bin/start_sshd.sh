#!/bin/sh

source /conf/common_settings.sh

#################################
# start sshd
#################################
f_eecho "================================================================="
f_eecho "Start sshd and set autostart on."
f_necho "Do you want to execute this operation? (Y/n): "

read yesno
yesno=${yesno:-Y}
while [ 1 ]; do
	if [ \( "${yesno}" = "y" \) -o \( "${yesno}" = "Y" \) ]; then
		which systemctl 1>/dev/null 2>/dev/null 
		sysctl_rtn=$?
		which service 1>/dev/null 2>/dev/null 
		service_rtn=$?
		which chkconfig 1>/dev/null 2>/dev/null 
		chkcfg_rtn=$?
	
		if [ ${sysctl_rtn} -eq 0 ]; then
			systemctl start sshd.service
			systemctl enable sshd.service
		elif [ ${service_rtn} -eq 0 ]; then
			service sshd start
			if [ ${chkcfg_rtn} -eq 0 ]; then
				chkconfig sshd on
			fi
		else
			f_eecho "......Sorry. I don't know how to operate daemon on this system. Please operate manually after finishing this script. X( "
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

f_eecho "Finished sshd operation."


exit 0

