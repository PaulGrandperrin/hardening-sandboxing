#!/bin/sh
set -xe

rm -rf sources
mkdir -p sources
cd sources
apt source $1
cd ..

cowbuilder build --configfile pbuilderrc sources/*.dsc

rm -rf sources

