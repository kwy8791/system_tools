#!/bin/sh

PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:./bin"
echo "================================================================="

#################################
# r_u_root?
#################################
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t We will check that 'Are you root user?'"
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t This script is expected to be executed by 'root' user."
echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Press Enter to Continue."

read foobar

if [ -x `which whoami` ]; then
	user_name=`whoami`
elif [ -x `which id` ]; then
	user_id=`id -u`
else
	echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Cannot identify your user type. Please install 'whoami' or 'id' command."
	exit 1
fi

if [ ! -z "${user_name}" ]; then
	if [ "${user_name}" != "root" ]; then
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t You are not root user. This script must be executed by root user."
		exit 1
	fi
fi

if [ ! -z "${user_id}" ]; then
	if [ "${user_id}" -ne 0 ]; then
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t You are not root user. This script must be executed by root user."
		exit 1
	fi
fi

echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t O.K. You are 'root' user."
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t" 'WELCOME to this setup script!!'

echo "================================================================="

#################################
# create system directory
#################################
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t We will Create system admin's directory."
echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Do you want to create? (Y/n)"

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
			echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Finished created directory '/var/tmp/infrawork/{src,log,rpm,bkup}, /var/tmp/infrawork/src/{archived,extracted}."
			break
		else
			echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Cannot find /var/tmp directory. skipping...."
			break
		fi
	elif [ \( "${yesno}" = "n" \) -o \( "${yesno}" = "N" \) ]; then
		break
	else
		echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Please input y|Y|n|N."
	fi
	break
done

echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Directories created (...or 'MAYBE' cannot create directories because of somewhat unpredictable causes...)."

echo "================================================================="

#################################
# enable yum cache
#################################
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t We will set yum config to save rpm files in /var/cache/yum directory."
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t But files vanish and never restore, when you will type ... uh like 'yum clean all' / 'yum clean packages' e.t.c...."
echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Press Enter to Continue."

read foobar

if [ -e /etc/yum.conf ]; then
	cp -ip --parents /etc/yum.conf /var/tmp/infrawork/bkup
	sed -i -e "s/^keepcache=0/keepcache=1/" /etc/yum.conf
	diff /etc/yum.conf /var/tmp/infrawork/bkup/etc/yum.conf
else
	echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Cannot find /etc/yum.conf. skipping...."
fi

echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Finished change setting of yum cache."

echo "================================================================="

#################################
# disable selinux
#################################
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t We will set selinux disabled."

echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Press Enter to Continue."

read foobar

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

echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Finished selinux disabled."

echo "================================================================="

#################################
# start sshd
#################################
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t We will start sshd."
echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Press Enter to Continue."

read foobar

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
	echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t cannot find systemctl/service command"
fi

echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Finished starting sshd section."

echo "================================================================="

#################################
# create user
#################################
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t We will create users."

echo -e -n "`date +'%Y-%m-%d_%H:%M:%S'`\t Press Enter to Continue."

read foobar

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

echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Finished user creation."

echo "================================================================="

#################################
# setting for ssh client
#################################
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t We will set ssh keys for users from remote clients."

while [ 1 ]; do
	# whom for setting
	echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t which user do you want to configure ssh setting? or finish (press 'nomoreplz' to finish useradding)"
	echo -e -n "username: "
	read user_name
	if [ ${user_name} = "nomoreplz" ]; then
		break
	fi
	user_dir=/home/${user_name}

	mkdir "${user_dir}"/.ssh
	echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t input your ssh key"
	echo -n "ssh key: "
	read "sshkeychane"
	# /* ↑ここ、スペース含んでもちゃんと動くか要確認 */
	echo "${sshkeychane}" >> "${user_dir}"/.ssh/authorized_keys
	chown -R ${user_name} ${user_dir}/.ssh
	chmod -R 700 "${user_dir}"/.ssh
done

echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Finished 'bout users' ssh key settings"

echo "================================================================="

#################################
# format and size setting for history command
#################################
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t We will change format of 'history' command."
# /* ここは設定先が/etc/profileで良いのかな？ */
cat << EOF >> /etc/profile

# history command environment
HISTTIMEFORMAT='%y/%m/%d %H:%M:%S ';
HISTFILESIZE=
HISTSIZE=
EOF
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Finished changing format of 'history' command."

echo "================================================================="

#################################
# set auto logging
#################################
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t We will change format of 'history' command."
# /* ここは設定先が/etc/profileで良いのかな？ */
cat << EOF >> /etc/profile

# set auto logging all commands
if [ ! -d /var/tmp/infrawork/log/history ]; then
    mkdir /var/tmp/infrawork/log/history
    chmod 777 /var/tmp/infrawork/log/history
fi

hostname
id
date
/usr/bin/script /var/tmp/infrawork/log/history/`date +%Y%m%d-%H%M%S`-${USER}.log
EOF

echo "================================================================="

#################################
# yum upgrade
#################################
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t We will execute 'yum -y upgrade' command."
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t \(Maybe execute 'dnf' command.\)"

if [ -x `which dnf` ]; then
	dnf -y upgrade
elif [ -x `which yum` ]; then
	yum -y upgrade
fi

echo "finished executing system upgrade."

echo "================================================================="

#################################
# reboot
#################################
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t We will reboot OS now."
echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t Press Enter to Continue."

read foobar

echo -e "`date +'%Y-%m-%d_%H:%M:%S'`\t GOOD BY. SEE YOU AGAIN!"
if [ -x `which init` ]; then
	init 6
elif [ -x `which reboot` ]; then
	reboot
elif [ -x `which shutdown` ]; then
	shutdonw -r now
fi

exit 0
# ↑要るのかな、このexit？

