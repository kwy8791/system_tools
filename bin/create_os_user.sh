#!/bin/sh

source /conf/common_settings.sh

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


exit 0

