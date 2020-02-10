#!/bin/sh
set -xe

apt install -y build-essential flex bison bc libssl-dev libelf-dev

if [ -d linux-hardened ]; then
  cd linux-hardened
else
  git clone https://github.com/anthraxx/linux-hardened.git
  cd linux-hardened
  git remote add stable git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
  git checkout -b custom
fi

git fetch --all
git checkout custom
git reset --hard origin/5.5
git rebase stable/linux-5.5.y

./scripts/kconfig/merge_config.sh -m -r -O . ../config-firecracker-4.14.72 ../config-linux-hardened
make olddefconfig
make vmlinux -j8
