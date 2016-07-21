#!/usr/bin/env python

import os
import subprocess
import shlex
from datetime import datetime
import click


def do(cmd, ignore=False):
    cmd = shlex.split(cmd.format(**defaults))
    try:
        subprocess.check_call(cmd)
    except subprocess.CalledProcessError as e:
        if not ignore:
            raise e
        pass


defaults = dict(
    server='localhost',
    app_name='contrivers',
    db_name='contrivers-develop',
    db_user='contrivers',
    bucket='contrivers-staging',
    datefmt = '%m-%d-%Y.%H.%M',
    backup_name = 'latest-{now}.dump'
)

def url():
    return 'postgres://{db_user}@localhost/{db_name}'.format(**defaults)

def now():
    return datetime.now()

@click.group()
def cli():
    pass

@cli.command()
def config():
    for key in defaults.keys():
        click.echo('{} => {}'.format(key, defaults[key]))

@cli.command()
def init():
    """ setup the database """
    do('dropdb {db_name}', ignore=True)
    do('heroku pg:pull DATABASE_URL postgres://{db_user}@localhost/{db_name} --app {app_name}')
    do('psql -c "create extension pgtap;" -U {db_user} -d {db_name}')

@cli.command()
def up():
    """ run alembic upgrade """
    os.environ['DATABASE_URL'] = url()
    do('alembic upgrade head')

@cli.command()
def test():
    """ run pg_prove """
    do('pg_prove -U {db_user} -d {db_name} tests/test_*.sql')

@cli.command()
def deploy():
    """ deploy the database to production """
    do('pg_dump -Fc -d {db_name} -h {server} -U {db_user} --clean --no-acl --no-owner > backups/{backups_name}')
    do('aws s3 cp backups/{backup_name} s3://{bucket}/{backup_name} --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers')
    do('heroku pg:backups restore https://{bucket}.s3.amazonaws.com/{backup_name} DATABASE_URL --app={app_name} --confirm {app_name}')
    do('aws s3 rm s3://{bucket}/{backup_name}')
@cli.command()
def stage():
    """ deploy the database to staging """
    pass

if __name__ == '__main__':
    cli()
