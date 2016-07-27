#!/bin/sh

#	ヘッダの書き出し
echo "| uid(username) | primary gid(group name) | secondary gid(group name) |"
echo "| --------------|-------------------------|---------------------------|"

# list user in variable user_name
for user_name in `cut -f1 -d: /etc/passwd`; do

#	整形前の情報を出力
	raw_line=`id ${user_name}`

#	ユーザー情報の取り出し
	user_info=`echo $raw_line |cut -f1 -d' '`

#	プライマリグループ情報の取り出し
	pgroup_info=`echo $raw_line |cut -f2 -d' '`

#	セカンダリグループ情報の取り出し
	sgroup_info=`echo $raw_line |cut -f3 -d' '`

#	出力
	echo "| ${user_info} | ${pgroup_info} | ${sgroup_info} |"
done
 

