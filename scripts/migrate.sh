#!/usr/bin/env bash

# Backup and restore a database from heroku

HELP=$(cat <<EOF

migrate

grab a heroku backup and pg_restore it to the current
localhost database.

Usage: migrate [command] [options]

Commands
    push
    pull
    sync

# TODO:  combine all scripts into a single with arg parsing
# TODO:  get fs root from env or arg

EOF)

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

while [ ${#} -gt 0 ]; do
    case "${1}" in
        -h | --help)
        echo "help!"
        exit 0
        ;;

        --unittests)
            UPDATE_UNITTESTS=true
            shift
            ;;

        pull)

            shift
            ;;

        push)
            shift
            ;;


        *)
            ;;
    esac
    shift
done


# Colors
Color_Off='\e[0m'       # Text Reset
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow

# Logger
msg() {
    printf "[${Yellow} $(date +"%X") ${Color_Off}] ${1}\n"
}


msg "backup heroku database"
heroku pg:backups capture --app ${app_name}

msg "Download from heroku"
curl -o ${backup_name} `heroku pg:backups public-url --app=${app_name}`

msg "Restore to the dev db"
pg_restore --clean --no-acl --no-owner -h ${server} -U ${username} -d ${dev_database} ${backup_name}

msg "Apply any migrations"
alembic upgrade head

msg "Restore to the pgtap db"
pg_restore --clean --no-acl --no-owner -h ${server} -U ${contrivers} -d ${testing_database} ${backup_name}

msg "Make sure pgtap is installed..."
echo \"\\x CREATE EXTENSION IF NOT EXISTS pgtap \" | psql -d ${testing_database} -U ${username}

msg "Backup the schema"
pg_dump -s -d ${dev_database} --clean --no-acl --no-owner > ${schema_backups_name}

msg "Recreate the existing unittest db"
dropdb ${unittests_database}
createdb -O ${owner} ${unittests_database}

msg "Setup the test db with schema"
psql -d ${testing_database} -U ${username} -f ${schema_backups_name}
