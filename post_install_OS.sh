#!/bin/sh

# set myscript_home
export myscript_home=`pwd`

# directory check
for dir_name in bin log conf ;do
	if [ ! -d ${myscript}/${dir_name} ]; then
		mkdir ${myscript}/${dir_name}
		rtn_cd=$?
		if [ ${rtn_cd} != 0 ]; then
			echo "Error cannot create ${myscript}/${dir_name}!"
			exit 1
		fi
	fi
done

# read config file
source ${myscript_home}/conf/*.sh

# Check whether the user who executes this script is root
exec ${myscript_home}/bin/is_root_user.sh

# Create directories for system administrators.
# (/var/tmp/infrawork/{src,log,rpm,bkup}, 
#  /var/tmp/infrawork/src/{archived,extracted})
exec ${myscript_home}/bin/create_sysdir.sh

# Enable yum cache
exec ${myscript_home}/bin/enable_yum_cache.sh

# Set selinux disabled
exec ${myscript_home}/bin/disable_selinux.sh

# Start and set autostart on sshd
exec ${myscript_home}/bin/start_sshd.sh

# Create OS users.
# ("username", "userid", "primary group id", "secondary group id")
exec ${myscript_home}/bin/create_os_user.sh

# Register OS users' ssh key to a file.
exec ${myscript_home}/bin/set_ssh_keys.sh

# Modify setting of "history" command
exec ${myscript_home}/bin/set_history_settings.sh

# Set auto logging via ssh login
exec ${myscript_home}/bin/set_auto_logging.sh

# Do System upgrade
exec ${myscript_home}/bin/sys_upgrade.sh

# Reboot
exec ${myscript_home}/bin/sys_reboot.sh

exit 0

