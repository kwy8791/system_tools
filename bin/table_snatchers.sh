#!/bin/sh

# initial settings
source /etc/profile
source ${HOME}/.bash_profile

# check wheter command exists
if [ `which echo` -ne 0 ] ;then
  echo "echo command not found!"
  exit 1
fi

if [ `which read` -ne 0 ] ;then
  echo "read command not found!"
  exit 1
fi

if [ `which mkdir` -ne 0 ] ;then
  echo "mkdir command not found!"
  exit 1
fi

if [ `which mysql` -ne 0 ] ;then
  echo "mysql command not found !"
  exit 1
fi

if [ `which mysqldump` -ne 0 ] ;then
  echo "mysqldump command not found!"
fi

# set variables(interacrive)
echo -n "input database user name: "
read DB_USER
echo -n "input database host name: "
read DB_HOST
echo -n "input database name: "
read DB_NAME
echo -n "input database password: "
read DB_PASS

# set variables(non-interacrive)
DEST_DIR="/var/tmp/create_table_DDL/${DB_NAME}_`date +'%Y%m%d'`"
TBL_LIST=${DEST_DIR}/tablename.list

# create directory
if [ ! -d ${DEST_DIR} ]; then
  mkdir -p ${DEST_DIR}
fi

# MySQL command for get all table names
GET_TBLNAME_CMD="show tables ;"

# get all table names
mysql --user=${DB_USER} \
  --host=${DB_HOST} \
  --database=${DB_NAME} \
  --silent \
  --execute="${GET_TBLNAME_CMD}" \
  --password=${DB_PASS} > ${TBL_LIST}

# GET "CREATE TABLE DDL" on each tables
for TBL_NAME in `cat ${TBL_LIST}` ;do
  TBL_DDL=${DEST_DIR}/${TBL_NAME}.sql
  mysqldump -u${DB_USER} \
    --host=${DB_HOST} \
    ${DB_NAME} ${TBL_NAME} \
    --no-data \
    --single-transaction \
    --password=${DB_PASS} > ${TBL_DDL}
done


