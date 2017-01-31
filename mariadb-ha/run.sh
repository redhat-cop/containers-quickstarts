#!/bin/bash

#set -e
set -u
set -vx
source ./mariadb-functions.sh

echo 'runnung as:' `whoami` 

# User-provided env variables
MARIADB_USER=${MARIADB_USER:="admin"}
MARIADB_PASS=${MARIADB_PASS:-$(pwgen -s 12 1)}

# Other variables
VOLUME_HOME="/var/lib/mysql"
ERROR_LOG="$VOLUME_HOME/error.log"
MYSQLD_PID_FILE="$VOLUME_HOME/mysql.pid"

# Trap INT and TERM signals to do clean DB shutdown
trap terminate_db SIGINT SIGTERM

install_db
tail -F $ERROR_LOG & # tail all db logs to stdout 

#If it's the first instance and there are no other instances running
if [ "$POD_NAME" == "$POD_PREFIX-0" ] && [ "`nslookup -type=srv $HEADLESS_SVC_NAME | grep '=' | wc -l`" -le "1" ]; then
#then initialize the cluster
	/usr/bin/mysqld_safe --wsrep-new-cluster &
else
#else join the cluster
	pets=`nslookup -type=srv $HEADLESS_SVC_NAME | grep '=' | awk '{print $7}' | sed 's/.$//'`
	pets=$( IFS=$','; echo "${pets[*]}" )
	/usr/bin/mysqld_safe --gcomm://$pets &
fi

#/usr/bin/mysqld_safe & # Launch DB server in the background
MYSQLD_SAFE_PID=$!

wait_for_db
secure_and_tidy_db
show_db_status
create_admin_user

# Do not exit this script untill mysqld_safe exits gracefully
wait $MYSQLD_SAFE_PID