#!/bin/sh

# check if ~/.ssh/id_rsa exsits
function decide_key_path(){
	if [ -f ${HOME}/.ssh/id_rsa ] ;then
		KEY_PATH="${HOME}/.ssh/`whoami`_rsa"
	elif [ -f ${HOME}/.ssh/`whoami`_rsa ] ;then
		KEY_PATH="${HOME}/.ssh/uytrewq_rsa"
	else
		KEY_PATH="${HOME}/.ssh/id_rsa"
	fi
	echo "${KEY_PATH}"
}

# generate ssh key( 
function generate_key_pair(){
	KEY_PATH=$1
	if [ -z "${KEY_PATH}" ] ;then
		echo "Cannot get KEY_PATH in genarate_key_pair."
		exit 1
	fi
	# check if ssh-keygen exists
	type ssh-keygen >> /dev/null
	rtn_cd=$?
	if [ ${rtn_cd} -ne 0 ] ;then
		echo "'ssh-keygen' command not found!"
		exit 1
	else
		ssh-keygen -N "" -t rsa -b 4096 -f "${KEY_PATH}"
	fi
}

# type SSH public key
function type_public_key(){
	echo "以下の内容をアカウント管理者あてに送って下さい"
	echo "=================================================="
	if [ -f ${HOME}/.ssh/id_rsa.pub ] ;then
		cat ${HOME}/.ssh/id_rsa.pub
	elif [ -f ${HOME}/.ssh/`whoami`_rsa.pub ] ;then
		cat ${HOME}/.ssh/`whoami`_rsa.pub
	elif [ -f ${HOME}/.ssh/uytrewq_rsa.pub ] ;then
		cat ${HOME}/.ssh/uytrewq_rsa.pub
	else
		echo "SSH public key not found."
	fi
	echo "=================================================="
}

# main
KEY_PATH=`decide_key_path`
generate_key_pair ${KEY_PATH}
type_public_key

exit 0

