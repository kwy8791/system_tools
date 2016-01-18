#!/bin/sh

# set myscript_home
export myscript_home=`pwd`

# directory check
for dir_name in bin log conf ;do
	if [ ! -d ${myscript_home}/${dir_name} ]; then
		mkdir ${myscript_home}/${dir_name}
		rtn_cd=$?
		if [ ${rtn_cd} != 0 ]; then
			echo "Error cannot create ${myscript_home}/${dir_name}!"
			exit 1
		fi
	fi
done

PATH=${PATH}:${myscript_home}/bin

# read config file
source ${myscript_home}/conf/*.sh

# Check whether the user who executes this script is root
${myscript_home}/bin/is_root_user.sh

# Create directories for system administrators.
# (/var/tmp/infrawork/{src,log,rpm,bkup}, 
#  /var/tmp/infrawork/src/{archived,extracted})
${myscript_home}/bin/create_sysdir.sh

# Enable yum cache
${myscript_home}/bin/enable_yum_cache.sh

# Set selinux disabled
${myscript_home}/bin/disable_selinux.sh

# Start and set autostart on sshd
${myscript_home}/bin/start_sshd.sh

# Create OS users.
# ("username", "userid", "primary group id", "secondary group id")
${myscript_home}/bin/create_os_user.sh

# Register OS users' ssh key to a file.
${myscript_home}/bin/set_ssh_keys.sh

# Modify setting of "history" command
${myscript_home}/bin/set_history_settings.sh

# Set auto logging via ssh login
${myscript_home}/bin/set_auto_logging.sh

# Do System upgrade
${myscript_home}/bin/sys_upgrade.sh

# Reboot
${myscript_home}/bin/sys_reboot.sh

exit 0

