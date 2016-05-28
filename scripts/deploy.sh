#!/usr/bin/env bash

cat <<EOF

Dump the staging database and deploy it to heroku.

EOF

server='localhost'
app_name="contrivers"
username="contrivers"
owner="contrivers"
dev_database="contrivers"
fts="$(date +%m-%d-%Y.%H.%M)"
backup_name="latest-${fts}.dump"
staging_backup="local-${fts}.dump"
bucket="contrivers-staging"
host='localhost'
# Colors
Color_Off='\e[0m'       # Text Reset
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow

function ts {
    date +"%X"
}

# Logger
msg() {
    printf "[${Yellow} $(ts) ${Color_Off}] ${1}\n"
}

msg "Dump the staging database"
pg_dump -Fc -d "${dev_database}" -h "${host}" -U ${username} --clean --no-acl --no-owner > backups/${staging_backup}

msg "Upload the database to our staging server"
aws s3 cp "backups/${staging_backup}" "s3://${bucket}/${staging_backup}" --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers

msg "show s3 permissions"
aws s3api get-object-acl --bucket ${bucket} --key ${staging_backup}

msg "Restore the production db from the s3 backup"
url="https://${bucket}.s3.amazonaws.com/${staging_backup}"
heroku pg:backups restore "${url}" DATABASE_URL --app=${app_name} --confirm ${app_name}

msg "Delete the staged db dump file"
aws s3 rm "s3://${bucket}/${staging_backup}"
