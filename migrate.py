#!/usr/bin/env python
"""
    migrate.py

    Simple click app that proxies some shell commands
"""
# pylint: disable=invalid-name

import os
import shlex
import subprocess
import glob
import os.path
from datetime import datetime
import click

class Error(click.ClickException):
    pass

class log(object):
    debug = True

    @classmethod
    def err(cls, msg):
        if cls.debug:
            click.echo(click.style('ERROR: ', fg='red') + msg)

    @classmethod
    def info(cls, msg):
        click.echo(click.style('INFO: ', fg='green') + msg)

    @classmethod
    def th(cls, msg):
        click.echo(click.style(msg, fg='yellow'))


def do(orig, ignore=False):
    """ Wrapper for subprocess.check_call """
    cmd = shlex.split(orig.format(**defaults))
    out, err = subprocess.Popen(
        cmd,
        stderr=subprocess.PIPE,
        stdout=subprocess.PIPE).communicate()
    if not ignore and err:
        log.err(orig.format(**defaults))
        log.err(err)
        raise Error(err)
    if out:
        log.info(orig.format(**defaults))
        log.info(out)

def now():
    """ return datetime.now() as a string """
    return datetime.now().strftime(defaults.get('datefmt'))

def name():
    """ return a backup name with the current time """
    return defaults.get('backup_name').format(now())

defaults = dict(
    server='localhost',
    app_name='contrivers',
    db_name='contrivers-develop',
    db_user='contrivers',
    bucket='contrivers-staging',
    url='postgres://{db_user}@localhost/{db_name}',
    backup_name='latest-{}.dump',
    datefmt='%m-%d-%Y.%H.%M',
)

@click.group()
def cli():
    os.environ['DATABASE_URL'] = defaults.get('url').format(**defaults)

@cli.command()
def config():
    for key in defaults.keys():
        click.echo('{} => {}'.format(key, defaults[key]))

@cli.command()
def get():
    """ setup the database """
    do('dropdb {db_name}', ignore=True)
    do('heroku pg:pull DATABASE_URL postgres://{db_user}@localhost/{db_name} --app {app_name}')
    do('psql -c "create extension pgtap;" -U {db_user} -d {db_name}')

@cli.command()
def up():
    """ run alembic upgrade """
    do('alembic upgrade head')

@cli.command()
def test():
    """ run pg_prove """
    if not os.path.isdir('./tests'):
        raise Error('No test directory')
    files = glob.glob('tests/test_*.sql')
    do('pg_prove -U {db_user} -d {db_name} ' + ' '.join(files))

@cli.command()
def deploy():
    """ deploy the database to production """
    do('pg_dump -Fc -d {db_name} -h {server} -U {db_user} --clean --no-acl --no-owner > backups/{backup_name}')
    do('aws s3 cp backups/{backup_name} s3://{bucket}/{backup_name} --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers')
    do('heroku pg:backups restore https://{bucket}.s3.amazonaws.com/{backup_name} DATABASE_URL --app={app_name} --confirm {app_name}')
    do('aws s3 rm s3://{bucket}/{backup_name}')

@cli.command()
def stage():
    """ deploy the database to staging """
    pass

if __name__ == '__main__':
    cli()
