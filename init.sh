#!/bin/sh
set -xe

. ./pbuilderrc
mkdir -p $APTCACHE
mkdir -p $BUILDPLACE
mkdir -p $BASEPATH
cowbuilder create --configfile pbuilderrc

