#!/bin/sh
set -xe

build_package () {
  rm -rf sources
  mkdir -p sources
  cd sources
  apt source $1
  cd ..

  cowbuilder build --configfile pbuilderrc sources/*.dsc

  rm -rf sources
}




# dpkg-buildpackage specific vars
#export DEB_VENDOR ?
export DEB_BUILD_PROFILES="nocheck nodoc noudeb nobiarch"
export DEB_BUILD_OPTIONS="nocheck nodoc hardening=+all"

# Toolchain selection
export CC=clang
export CPP=clang-cpp
export CXX=clang++
export LD=lld

# Toolchain flags
pie="-fPIE -fPIC -pie"
lto="-flto"

# Safe Stack
st="$pie -fsanitize=safe-stack"

# CFI
cfi="$lto -fsanitize=cfi -fvisibility=hidden"
# override flags to disable some features that might make the compilation fail
# -fvisibility=default
# -fno-sanitize=cfi-cast-strict
# -fno-sanitize=cfi-derived-cast
# -fno-sanitize=cfi-unrelated-cast
# -fno-sanitize=cfi-nvcall
# -fno-sanitize=cfi-vcall
# -fno-sanitize=cfi-icall # if it fails, try with -fsanitize-cfi-icall-generalize-pointers (incompat with cross-dso) and -fno-sanitize-cfi-canonical-jump-tables or replace with -fsanitize=function (slower, included in -fsanitize=undefined)
# -fno-sanitize=cfi-mfcall

# UBSAN
ub_int="-fsanitize-trap=integer"
ub_null="-fsanitize-trap=nullability"
ub_func="-fsanitize-trap=function"
ub_bound="-fsanitize-trap=bounds"
ub_po="-fsanitize-trap=pointer-overflow"
# defaults with minimum perf impact from Android: https://source.android.com/devices/tech/debug/sanitizers
ub_android="-fsanitize-trap=bool -fsanitize-trap=integer-divide-by-zero -fsanitize-trap=return -fsanitize-trap=returns-nonnull-attribute -fsanitize-trap=shift-exponent -fsanitize-trap=unreachable -fsanitize-trap=vla-bound"
ub_default="$ub_android $ub_int $ub_null $ub_bound"


# PACKAGES

FLAGS="$ub_default" # TODO try to enable some CFI
export DEB_CFLAGS_APPEND="$FLAGS"
export DEB_CXXFLAGS_APPEND="$FLAGS"
export DEB_LDFLAGS_APPEND="$FLAGS"
build_package openssl
build_package lz4
build_package bzip2
build_package icu
build_package lua5.3

FLAGS="$cfi $ub_default"
export DEB_CFLAGS_APPEND="$FLAGS"
export DEB_CXXFLAGS_APPEND="$FLAGS"
export DEB_LDFLAGS_APPEND="$FLAGS"
build_package opensmtpd

FLAGS="$st $cfi $ub_default"
export DEB_CFLAGS_APPEND="$FLAGS"
export DEB_CXXFLAGS_APPEND="$FLAGS"
export DEB_LDFLAGS_APPEND="$FLAGS"
build_package opensmtpd
