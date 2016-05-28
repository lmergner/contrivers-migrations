#!/usr/bin/env bash


server='localhost'
app_name="contrivers-review-v2"
username="contrivers"
owner="contrivers"
dev_database="contrivers"
testing_database="contrivers-pgtap"
unittests_database="contrivers-testing"
fts="$(date +%m-%d-%Y.%H.%M)"
schema_backups_name="sql/schema-backup-${fts}.sql"
backup_name="backups/latest-${fts}.dump"

tmp_backup='/tmp/contrivers-backup.dump'

dropdb ${testing_database} || { echo "dropdb failed"; exit 1; }
createdb -O ${owner} ${testing_database} || { echo "createdb failed"; exit 1; }
pg_dump -Fc --clean --no-acl --no-owner -h ${server} -Fc ${dev_database} > ${tmp_backup} || { echo "pg_dump failed"; exit 1; }
pg_restore --clean --no-acl --no-owner -h ${server} -U ${username} -d ${testing_database} ${tmp_backup} > /dev/null || { echo "pg_restore failed"; exit 1; }
echo "\x \\ CREATE EXTENSION IF NOT EXISTS pgtap;" | psql -d ${testing_database} || { echo "create extension failed"; exit 1; }

rm ${tmp_backup}
