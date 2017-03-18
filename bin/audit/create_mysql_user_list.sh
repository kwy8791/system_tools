#!/bin/sh

DB_USER=<db user>
DB_PASS=<password>
DB_HOST=<db host>

source /etc/profile
source /home/`whoami`/.bash_profile

# if mysql client exists
which mysql
rtn_cd=$?
if [ ${rtn_cd} -ne 0 ] ;then
	echo "MySQL Client does not exsits!"
	echo "exitting...."
	exit 1
else
	mysql -N -q -s -h${DB_HOST} -u${DB_ADM} -p${DB_PASS} -e "select concat ('show grants for\'', user, '\'@\'', host, '\' ;') from mysql.user order by user, host;" > /tmp/$$.sql
	mysql -N -q -s -h${DB_HOST} -u${DB_ADM} -p${DB_PASS} < ./$$.sql |sed -e "s/^GRANT //g" |sed -e "s/IDENTIFIED BY PASSWORD.*//g" > /tmp/`date +'%F'`-DB-${DB_HOST}.lst
	echo "List of DB user and privilege file: /tmp/`date +'%F'`-DB-${DB_HOST}.lst
fi

exit 0

