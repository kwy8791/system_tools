#!/bin/sh

source /etc/profile
source /home/`whoami`/.bash_profile

# if aws command exists
which aws
rtn_cd=$?
if [ ${rtn_cd} -ne 0 ] ;then
	echo "aws-cli does not exsit!"
	echo "exitting...."
	exit 1
else
	DATESTR=`date +'%F'`

	# user names and last login datetime(to console)
#	echo "username" > /tmp/`date +'%F'`-AWS-user.lst
	aws iam list-users --output text |awk '{print $NF}' >> /tmp/`date +'%F'`-AWS-user.lst

	# user names and last login datetime (lon into console)
	aws iam list-users --output json |jq -r '.Users[].UserName + "," + .Users[].PasswordLastUsed' > /tmp/`date +'%F'`-AWS-user-and-last-logindate.lst

	# user names and access key ids
#	echo "username,access key ID" > /tmp/`date +'%F'`-AWS-user-accesskey.lst
	aws iam list-access-keys --output text |awk '{print $NF","$2}' >> /tmp/`date +'%F'`-AWS-user-accesskey.lst

	# access key ids and last used days
	for IAM_KEY_ID in `awk -F',' '{print $NF}' /tmp/${DATESTR}-AWS-user-accesskey.lst` ;do
#	echo "iam key id, last used"
		aws iam get-access-key-last-used --access-key-id ${IAM_KEY_ID} \
			--output json |jq -r '.UserName + "," + .AccessKeyLastUsed.LastUsedDate' > /tmp/${DATESTR}-AWS-accesskey-last-used.lst
	done

	# group names
#	echo "groupname"
	aws iam list-groups |jq -r '.Groups[].GroupName' > /tmp/`date +'%F'`-AWS-group.lst

	# group nemes and policies
	for IAM_GRP in `cat /tmp/${DATESTR}-AWS-group.lst` ;do
#		echo "group policy"
		aws iam list-group-policies --group-name ${IAM_GRP} |jq -r '.PolicyNames[]' > /tmp/`date +'%F'`-AWS-${IAM_GRP}-Gpolicy.lst
#		echo ""
	done

	# groups and users 
	for IAM_USR in `cat /tmp/${DATESTR}-AWS-user.lst` ;do
		aws iam list-groups-for-user --user-name ${IAM_USR} --output text |awk '{print $(NF-1)}' > /tmp/`date +'%F'`-AWS-${IAM_USR}-grp.lst
	done

	# roles
	aws iam list-roles --output json |jq -r '.Roles[].RoleName' > /tmp/`date +'%F'`-AWS-role.lst

	# role policies
	for IAM_ROLE in `cat /tmp/${DATESTR}-AWS-role.lst` ;do
		aws iam list-role-policies --role-name ${IAM_ROLE} --output json |jq -r '.PolicyNames[]' >> /tmp/${DATESTR}-AWS-${IAM_ROLE}-Rpolicy.lst
	done

	# policy names and ids
	aws iam list-policies --output text |awk '{print $(NF-1)","$(NF-2)}' |sort > /tmp/`date +'%F'`-AWS-policy.lst

	# attached group policies
	for IAM_GRP in `cat /tmp/${DATESTR}-AWS-group.lst` ;do
		aws iam list-attached-group-policies --group-name ${IAM_GRP} | \
			jq -r '.AttachedPolicies[].PolicyName' \
			> /tmp/`date +'%F'`-AWS-${IAM_GRP}-attached-Gpolicy.lst
	done

	# 
	for IAM_USR in `cat /tmp/${DATESTR}-AWS-user.lst` ;do
# 		echo -n "${IAM_USR},"
		aws iam list-attached-user-policies --user-name ${IAM_USR} --output json |jq -r '.AttachedPolicies[].PolicyName' > /tmp/`date +'%F'`-AWS-${IAM_USR}-attached-Upolicy.lst
# 		echo ""
	done

	# instance profiles for role
	for IAM_ROLE in `cat /tmp/${DATESTR}-AWS-role.lst` ;do
		aws iam list-instance-profiles-for-role --role-name ${IAM_ROLE} --output json |jq -r '.InstanceProfiles[]' >> /tmp/`date +'%F'`-AWS-${IAM_ROLE}-instance-profiles-for-role.lst
	done

	# groups and users who belong to them
	for IAM_GRP in `cat /tmp/${DATESTR}-AWS-group.lst` ;do
		aws iam get-group --group-name ${IAM_GRP} --output json |jq -r '.Group.GroupName + "," + .Users[].UserName'
	done > /tmp/`date +'%F'`-AWS-groups-and-users-belong-to-them.lst

	# 
	


