#!/bin/sh

PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:./bin"

#################################
# define variables, invariables, and functions.
#################################
datetime_cmd="date +%Y-%m-%d_%H:%M:%S"


function f_eecho() {
	echo -e "`${datetime_cmd}`\t$@" 
}

function f_necho() {
	echo -e -n "`${datetime_cmd}`\t$@" 
}

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
			diff /etc/yum.conf /var/tmp/infrawork/bkup/etc/yum.conf
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

#################################
# create user
#################################
f_eecho "================================================================="
f_eecho "Start creating OS users."
f_necho " Do you want to execute this operation? (Y/n): "

read yesno
yesno=${yesno:-Y}
while [ 1 ]; do
	if [ \( "${yesno}" = "y" \) -o \( "${yesno}" = "Y" \) ]; then
		while [ 1 ]; do
			f_eecho "enter username or finish (press 'nomoreusersplz' to finish useradding)"
			f_necho "username: "
			read user_name
			if [ "${user_name}" = "nomoreusersplz" ]; then
				break
			fi

			f_eecho "Enter userid (default: system decided)"
			f_necho "userid: "
			read user_id
			if [ ! -z ${user_id} ]; then
				user_id_opt=" -u ${user_id}"
			fi

			f_eecho "enter primary groupid (default: system decided)"
			f_necho "primary groupid: "
			read primary_group_id
			if [ ! -z ${primary_group_id} ]; then
				primary_group_id_opt=" -g ${primary_group_id}$"
			fi

			f_eecho "enter secondary groupid (default: none. e.g. users,wheel)"
			f_necho "secondary groupid: "
			read secondary_group_id
			if [ ! -z ${secondary_group_id} ]; then
				secondary_group_id_opt=" -G ${secondary_group_id}"
			fi

			useradd ${user_id_opt} ${primary_group_id_opt}  ${secondary_group_id_opt} ${user_name} 
			if [ $? -eq 0 ]; then
				f_eecho "user ${user_name} created!"
			else
				f_eecho "+++++user ${user_name} failed!"
				f_eecho "Please check details.+++++"
			fi
		done
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

f_eecho "Finished user creation."

#################################
# setting for ssh client
#################################
f_eecho "================================================================="
f_eecho "Start setting ssh keys for users from remote clients."
f_necho "Do you want to execute this operation? (Y/n): "

read yesno
yesno=${yesno:-Y}
while [ 1 ]; do
	if [ \( "${yesno}" = "y" \) -o \( "${yesno}" = "Y" \) ]; then
		while [ 1 ]; do
			# whom for setting
			f_eecho "which user do you want to configure ssh setting?"
			f_eecho " or finish (press 'nomoreplz' to finish useradding)"
			f_necho "username: "
			read user_name
			if [ ${user_name} = "nomoreplz" ]; then
				break
			fi
			if [ ${user_name} = "root" ]; then
				user_dir=/root
			else
				user_dir=/home/${user_name}
			fi
			mkdir "${user_dir}"/.ssh
			f_eecho "input your ssh key"
			f_necho "ssh key: "
			read "sshkeychane"
			f_eecho "${sshkeychane}" >> "${user_dir}"/.ssh/authorized_keys
			chown -R ${user_name} ${user_dir}/.ssh
			chmod -R 700 "${user_dir}"/.ssh
		done
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

f_eecho "Finished about users' ssh-key settings"


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
exit 0

