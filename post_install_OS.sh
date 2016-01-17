#!/bin/sh

PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:./bin"

#################################
# define variables, invariables, and functions.
#################################
datetime_cmd="date +%Y-%m-%d_%H:%M:%S"


function write_log() {
	echo -e "`${datetime_cmd}`\t$@" 


#################################
# Check whether you are root?
#################################
echo "================================================================="
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Start User Checking..."
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t *** This script is required to be executed by 'root' user. ***"
echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Press Enter to Continue."

read foobar

which whoami 1>/dev/null 2>/dev/null
whoami_rtn=$?
which id 1>/dev/null 2>/dev/null
id_rtn=$?

if [ ${whoami_rtn} -eq 0 ]; then
	if [ ! `whoami` = "root" ]; then
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t \e[1;37;41m YOU ARE NOT 'root' USER! This script must be executed by 'root'. \e[m"
	fi

elif [ ${id_rtn} -eq 0 ]; then
	if [ ! `id -u` = "root" ]; then
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t \e[1;37;41m YOU ARE NOT 'root' USER! This script must be executed by 'root'. \e[m"
	fi

else
	echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t \e[1;37;41m Cannot identify your user type. Please install 'whoami' or 'id' command. \e[m"
fi

echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t \e[1;30;42m O.K. \e[m You are 'root' user."
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t \e[1;30;42m Check passed! \e[m"
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Finished User Checking. Continuing...."

#################################
# create system directory
#################################
echo "================================================================="
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Start creating system-admins' directories."
echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "

read yesno
yesno=${yesno:-Y}
while [ 1 ]; do
	if [ \( "${yesno}" = "y" \) -o \( "${yesno}" = "Y" \) ]; then
		if [ -d /var/tmp ]; then
			echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t creating /var/tmp/infrawork/{src,log,rpm,bkup}"
			mkdir -p /var/tmp/infrawork/{src,log,rpm,bkup}
			echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t creating /var/tmp/infrawork/src/{archived,extracted}"
			mkdir -p /var/tmp/infrawork/src/{archived,extracted}
			echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t change mode of directories"
			chmod -R 777 /var/tmp/infrawork/
			echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t \e[1;30;42m SUCCESS! \e[m"
			echo -e "created directories are below. (result of ls -ld)"
			echo -e "`ls -ld /var/tmp/infrawork/{src,log,rpm,bkup} /var/tmp/infrawork/src/{archived,extracted}`"
		else
			echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t \e[1;37;41m Cannot find /var/tmp directory. skipping.... \e[m"
		fi
		break
	elif [ \( "${yesno}" = "n" \) -o \( "${yesno}" = "N" \) ]; then
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Operation passed. Continuing...."
		break
	else
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Please input y|Y|n|N."
		echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "
		read yesno
	fi
done

echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Finished creating directories. Continuing...."

#################################
# enable yum cache
#################################
echo "================================================================="
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Start configuration for save rpm files...."
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t *** But files vanish and never restore, when you will type ... uh like 'yum clean all' / 'yum clean packages' e.t.c.... ***"
echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "

read yesno
yesno=${yesno:-Y}
while [ 1 ]; do
	if [ \( "${yesno}" = "y" \) -o \( "${yesno}" = "Y" \) ]; then
		if [ -e /etc/yum.conf ]; then
			cp -ip --parents /etc/yum.conf /var/tmp/infrawork/bkup
			sed -i -e "s/^keepcache=0/keepcache=1/" /etc/yum.conf
			diff /etc/yum.conf /var/tmp/infrawork/bkup/etc/yum.conf
		else
			echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Cannot find /etc/yum.conf. skipping...."
		fi
		break
	elif [ \( "${yesno}" = "n" \) -o \( "${yesno}" = "N" \) ]; then
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Operation passed. Continuing...."
		break
	else
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Please input y|Y|n|N."
		echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "
		read yesno
	fi
done

echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Finished change setting of yum cache."

#################################
# disable selinux
#################################
echo "================================================================="
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Start setting to selinux be disabled."
echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "


read yesno
yesno=${yesno:-Y}
while [ 1 ]; do
	if [ \( "${yesno}" = "y" \) -o \( "${yesno}" = "Y" \) ]; then
		if [ -e /etc/selinux/config ];then
			cp -ip --parents /etc/selinux/config /var/tmp/infrawork/bkup
			sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config
			diff /etc/selinux/config /var/tmp/infrawork/bkup/etc/selinux/config
		else
			echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Cannot find /etc/selinux/config file. try to execute 'setenforce' command."
			if [ -x `which setenforce` ]; then
				setenforce 0
			else
				echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Cannot find 'setenforce' command. skipping...."
			fi
		fi
		break
	elif [ \( "${yesno}" = "n" \) -o \( "${yesno}" = "N" \) ]; then
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Operation passed. Continuing...."
		break
	else
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Please input y|Y|n|N."
		echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "
		read yesno
	fi
done

echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Finished selinux disabled. (But need reboot)"

#################################
# start sshd
#################################
echo "================================================================="
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Start sshd and set autostart on."
echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "

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
			echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t ......Sorry. I don't know how to operate daemon on this system. Please operate manually after finishing this script. X( "
		fi
		break
	elif [ \( "${yesno}" = "n" \) -o \( "${yesno}" = "N" \) ]; then
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Operation passed. Continuing...."
		break
	else
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Please input y|Y|n|N."
		echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "
		read yesno
	fi
done

echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Finished sshd operation."

#################################
# create user
#################################
echo "================================================================="
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Start creating OS users."
echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "

read yesno
yesno=${yesno:-Y}
while [ 1 ]; do
	if [ \( "${yesno}" = "y" \) -o \( "${yesno}" = "Y" \) ]; then
		while [ 1 ]; do
			echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t enter username or finish (press 'nomoreusersplz' to finish useradding)"
			echo -n "username: "
			read user_name
			if [ "${user_name}" = "nomoreusersplz" ]; then
				break
			fi

			echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Enter userid (default: system decided)"
			echo -n "userid: "
			read user_id
			if [ ! -z ${user_id} ]; then
				user_id_opt=" -u ${user_id}"
			fi

			echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t enter primary groupid (default: system decided)"
			echo -n "primary groupid: "
			read primary_group_id
			if [ ! -z ${primary_group_id} ]; then
				primary_group_id_opt=" -g ${primary_group_id}$"
			fi

			echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t enter secondary groupid (default: none. e.g. users,wheel)"
			echo -n "secondary groupid: "
			read secondary_group_id
			if [ ! -z ${secondary_group_id} ]; then
				secondary_group_id_opt=" -G ${secondary_group_id}"
			fi

			useradd ${user_id_opt} ${primary_group_id_opt}  ${secondary_group_id_opt} ${user_name} 
			if [ $? -eq 0 ]; then
				echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t user ${user_name} created!"
			else
				echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t +++++user ${user_name} failed! Please check details.+++++"
			fi
		done
		break
	elif [ \( "${yesno}" = "n" \) -o \( "${yesno}" = "N" \) ]; then
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Operation passed. Continuing...."
		break
	else
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Please input y|Y|n|N."
		echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "
		read yesno
	fi
done

echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Finished user creation."

#################################
# setting for ssh client
#################################
echo "================================================================="
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Start setting ssh keys for users from remote clients."
echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "

read yesno
yesno=${yesno:-Y}
while [ 1 ]; do
	if [ \( "${yesno}" = "y" \) -o \( "${yesno}" = "Y" \) ]; then
		while [ 1 ]; do
			# whom for setting
			echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t which user do you want to configure ssh setting? or finish (press 'nomoreplz' to finish useradding)"
			echo -e -n "username: "
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
			echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t input your ssh key"
			echo -n "ssh key: "
			read "sshkeychane"
			echo "${sshkeychane}" >> "${user_dir}"/.ssh/authorized_keys
			chown -R ${user_name} ${user_dir}/.ssh
			chmod -R 700 "${user_dir}"/.ssh
		done
		break
	elif [ \( "${yesno}" = "n" \) -o \( "${yesno}" = "N" \) ]; then
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Operation passed. Continuing...."
		break
	else
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Please input y|Y|n|N."
		echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "
		read yesno
	fi
done

echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Finished about users' ssh-key settings"


#################################
# format and size setting for history command
#################################
echo "================================================================="
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Start changing format of 'history' command."
echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "

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
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Finished changing format of 'history' command."
		break
	elif [ \( "${yesno}" = "n" \) -o \( "${yesno}" = "N" \) ]; then
		break
	else
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Please input y|Y|n|N."
		echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "
		read yesno
	fi
done

echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Finish changing history format. Continuing...."

#################################
# set auto logging
#################################
echo "================================================================="
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Start setting of auto-logging on ssh-login."
echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "
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
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Operation passed. Continuing...."
		break
	else
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Please input y|Y|n|N."
		echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "
		read yesno
	fi
done

echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Finished auto-logging setting."

#################################
# yum upgrade
#################################
echo "================================================================="
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Start 'yum -y upgrade' command."
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t (Maybe execute 'dnf' command.)"
echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "

read yesno
yesno=${yesno:-Y}
while [ 1 ]; do
	if [ \( "${yesno}" = "y" \) -o \( "${yesno}" = "Y" \) ]; then
		if [ -x `which dnf` ]; then
			dnf -y upgrade
		elif [ -x `which yum` ]; then
			yum -y upgrade
		else
			echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t ......Sorry. I don't know how to update this system. Please update manually after finishing this script. X( "
		fi
		break
	elif [ \( "${yesno}" = "n" \) -o \( "${yesno}" = "N" \) ]; then
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Operation passed. Continuing...."
		break
	else
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Please input y|Y|n|N."
		echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "
		read yesno
	fi
done

echo "Finished executing system upgrade."

#################################
# reboot
#################################
echo "================================================================="
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Start reboot OS operation."
echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "

read yesno
yesno=${yesno:-Y}
while [ 1 ]; do
	if [ \( "${yesno}" = "y" \) -o \( "${yesno}" = "Y" \) ]; then
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t GOOD BY. SEE YOU AGAIN!"
		if [ -x `which init` ]; then
			init 6
		elif [ -x `which reboot` ]; then
			reboot
		elif [ -x `which shutdown` ]; then
			shutdonw -r now
		else
			echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t ......Sorry. I don't know how to reboot this system. Please reboot manually after finishing this script. X( "
		fi
		break
	elif [ \( "${yesno}" = "n" \) -o \( "${yesno}" = "N" \) ]; then
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Operation passed. Continuing...."
		break
	else
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Please input y|Y|n|N."
		echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to execute this operation? (Y/n): "
		read yesno
	fi
done

echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Finish All Operations. See You Again someday, somewhere...."
exit 0

