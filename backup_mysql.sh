#!/bin/bash
QUERY="SHOW DATABASES;"
USER="root"
PWD="password"
DATABASES=$(mysql -u $USER --password="$PWD" -e "$QUERY" -N -s)
BACKUP_DIR="/var/backup/mysql/"

# create directory if it doesn't exists yet
if [ ! -d "$BACKUP_DIR" ]; 
then
    mkdir -p "$BACKUP_DIR"
fi

# delete backups older than 7 days
find "$BACKUP_DIR" -type f -ctime +7 -exec rm {} \;

# do backup for every database
for db in $DATABASES
do
    # don't backup template0 database
    if [ "$db" != "template0" ] && [ "$db" != "information_schema" ];
    then
        mysqldump --skip-lock-tables -u $USER --password=$PWD $db > "$BACKUP_DIR""mysqldump_"$db"_$(date +"%Y%m%d").sql"
        gzip "$BACKUP_DIR""mysqldump_"$db"_$(date +"%Y%m%d").sql"
    fi
done

