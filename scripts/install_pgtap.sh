#!/bin/sh
set -ex
version="0.95.0"
cwd="$(pwd)"
wget http://api.pgxn.org/dist/pgtap/${version}/pgtap-${version}.zip

if [ -f pgtap-${version}.zip ]; then
    unzip pgtap-0.95.0.zip
else
    printf "failed to find pgtap zip file"
    exit 1
fi

if [ -d "pgtap-${version}" ]; then
    cd pgtap-0.95.0
    make
    make installcheck
    sudo make install
else
    printf "failed to unzip pgtap or the directory went missing"
    exit 1
fi

cd "${cwd}"

exit
