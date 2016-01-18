#!/bin/sh

source /conf/common_settings.sh

#################################
# Check whether you are root?
#################################
f_eecho "================================================================="
f_eecho "Start User Checking..."
f_eecho "*** This script is required to be executed by 'root' user. ***"
f_necho "Press Enter to Continue."

read foobar

which whoami 1>/dev/null 2>/dev/null
whoami_rtn=$?
which id 1>/dev/null 2>/dev/null
id_rtn=$?

if [ ${whoami_rtn} -eq 0 ]; then
	if [ ! `whoami` = "root" ]; then
		f_eecho "\e[1;37;41m YOU ARE NOT 'root' USER! This script must be executed by 'root'. \e[m"
	fi

elif [ ${id_rtn} -eq 0 ]; then
	if [ ! `id -u` = "root" ]; then
		f_eecho "\e[1;37;41m YOU ARE NOT 'root' USER! This script must be executed by 'root'. \e[m"
	fi

else
	f_eecho "\e[1;37;41m Cannot identify your user type. Please install 'whoami' or 'id' command. \e[m"
fi

f_eecho "\e[1;30;42m O.K. \e[m You are 'root' user."
f_eecho "\e[1;30;42m Check passed! \e[m"
f_eecho "Finished User Checking. Continuing...."


exit 0

