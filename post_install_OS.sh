#!/bin/sh

# set myscript_home
export myscript_home=`pwd`

# directory check
if [ ! -d ${myscript_home}/bin && ${myscript_home}/conf && ${myscript_home}/log ]; then
	echo "directories racked.exitting...."
	echo "retry after creating"
	echo "${myscript_home}/bin, ${myscript_home}/conf, ${myscript_home}/log"

	exit 1
fi

# read config file
source ${myscript_home}/conf/*.sh

# Check whether the user who executes this script is root
exec ${myscript_home}/bin/is_root_user.sh

# Create directories for system administrators.
# (/var/tmp/infrawork/{src,log,rpm,bkup}, 
#  /var/tmp/infrawork/src/{archived,extracted})
exec ${myscript_home}/bin/

# Enable yum cache
exec ${myscript_home}/bin/

# Set selinux disabled
exec ${myscript_home}/bin/

# Start and set autostart on sshd
exec ${myscript_home}/bin/

# Create OS users.
# ("username", "userid", "primary group id", "secondary group id")
exec ${myscript_home}/bin/

# Register OS users' ssh key to a file.
exec ${myscript_home}/bin/

# Modify setting of "history" command
exec ${myscript_home}/bin/

# Set auto logging via ssh login
exec ${myscript_home}/bin/

# Do System upgrade
exec ${myscript_home}/bin/

# Reboot
exec ${myscript_home}/bin/

exit 0

