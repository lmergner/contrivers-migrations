#!/usr/bin/env bash
dropdb contrivers-tmp
createdb -O contrivers contrivers-tmp
pg_dump -U contrivers -d contrivers | psql -U contrivers contrivers-tmp
