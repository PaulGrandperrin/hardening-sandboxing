#!/bin/sh
set -xe

if [ -d linux-hardened ]; then
  cd linux-hardened
  git fetch
else
  git clone https://github.com/anthraxx/linux-hardened.git
  cd linux-hardened
fi

git checkout 5.5
git reset --hard origin/5.5

./scripts/kconfig/merge_config.sh -m -r -O . ../config-firecracker-4.14.72 ../config-linux-hardened
make olddefconfig
make vmlinux -j8
