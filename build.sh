#!/bin/sh
set -xe

mkdir -p sources
cd sources
apt source $1
cd ..

cowbuilder build --configfile pbuilderrc sources/*.dsc

rm -rf sources

