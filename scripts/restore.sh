#!/bin/bash


server='localhost'
app_name="contrivers"
username="contrivers"
owner="contrivers"
dev_database="contrivers"
fts="$(date +%m-%d-%Y.%H.%M)"
schema_backups_name="sql/schema-backup-${fts}.sql"
backup_name="backups/latest-${fts}.dump"

backups_dir='backups/'
latest_backup="${backups_dir}/$(ls -t $backups_dir | head -1)"

pg_restore --clean --no-acl --no-owner -h ${server} -U ${username} -d ${dev_database} ${latest_backup}
