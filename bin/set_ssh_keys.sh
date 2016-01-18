#!/bin/sh

source ${myscript_home}/conf/common_settings.sh

#################################
# setting ssh key
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
			echo "${sshkeychane}" >> "${user_dir}"/.ssh/authorized_keys
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

