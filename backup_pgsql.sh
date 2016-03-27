#!/bin/bash
QUERY="SELECT datname FROM pg_database;"
DATABASES=$(psql -p 5432 -U postgres -t -c "$QUERY")
BACKUP_DIR="/var/backup/pgsql/"

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
    # don't backup template databases
    re='template[01]'
    if ! [[ "$db" =~ $re ]];
    then
        /bin/su - postgres -c "/usr/bin/pg_dump -p 5432 $db > "$BACKUP_DIR"pg_dump_"$db"_$(date +"%Y%m%d").sql"
        gzip $BACKUP_DIR"pg_dump_"$db"_$(date +"%Y%m%d").sql"
    fi
done

