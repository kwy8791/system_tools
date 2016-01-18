#!/bin/sh

source ${myscript_home}/conf/common_settings.sh

#################################
# create system directory
#################################

SYS_ROOTDIR=/var/tmp

f_eecho "================================================================="
f_eecho "Start creating system-admins' directories."
f_necho "Do you want to execute this operation? (Y/n): "

read yesno
yesno=${yesno:-Y}
while [ 1 ]; do
	if [ \( "${yesno}" = "y" \) -o \( "${yesno}" = "Y" \) ]; then
		if [ -d ${SYS_ROOTDIR} ]; then
			for mdir in src log rpm bkup ;do
				f_eecho "creating ${SYS_ROOTDIR}/${mdir}"
				if [ -d ${SYS_ROOTDIR}/${mdir} ] ; then
					f_eecho "${SYS_ROOTDIR}/${mdir} alread exists. Skipping...."
				else
					mkdir -p ${SYS_ROOTDIR}/${mdir}
					rtn_cd=$?
					if [ ${rtn_cd} -ne 0 ]; then
						f_eecho "\e[1;37;41m cannot created ${SYS_ROOTDIR}/${mdir}. exit. \e[m"
						exit 1
					else
						f_eecho "created ${SYS_ROOTDIR}/${mdir}."
					fi
				fi
			done

			for mdir in archived extracted ;do
				if [ -d ${SYS_ROOTDIR}/src/${mdir} ]; then
					f_eecho "${SYS_ROOTDIR}/src/${mdir} already exitsts. Skipping...."
				else
					mkdir ${SYS_ROOTDIR}/src/${mdir}
					rtn_cd=$?
					if [ ${rtn_cd} -ne 0 ]; then
						f_eecho "\e[1;37;41m cannot created ${SYS_ROOTDIR}/src/${mdir}. exit \e[m""
					else
						f_eecho "created ${SYS_ROOTDIR}/src/${mdir}"
					fi
				fi
			done

			mkdir -p ${SYS_ROOTDIR}/src/{archived,extracted}
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

