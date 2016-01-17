# system_tools
system tools for me. mainly on RHEL/CentOS.

## post_install_OS.sh
This script is executed after installing Linux.
This scripts works about
- Check whether the user who executes this script is root.
- Create directories for system administrators.(/var/tmp/infrawork/{src,log,rpm,bkup}, /var/tmp/infrawork/src/{archived,extracted})
- Enable yum cache.(set keepcache=1 in /etc/yum.conf)
- Set selinux disabled.(set SELINUX=disabled in /etc/selinux/config)
- Start and set autostart on sshd.
- Create OS users.(you can designate "username", "userid", "primary group id", "secondary group id")
- Register OS users' ssh key to a file.(create [or append if file exists] ${HOME}/.ssh/authorized_keys)
- Modify setting of "history" command by editing /etc/profile.(unlimited size, view as '%y/%m/%d %H:%M:%S <command>' format)
- Set auto logging via ssh login by editing /etc/profile.(logfile=/var/tmp/infrawork/log/history/'%Y%m%d-%H%M%S'-${USER}.log)
- Do System upgrade.(execute "dnf -y upgrade" or "yum -y upgrade"
- Reboot.(because of enabling selinux-disabled)
