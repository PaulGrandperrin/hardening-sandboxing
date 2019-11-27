#!/bin/sh
set -xe

# generic system setup
apt install -y debootstrap systemd-container
systemctl enable machines.target
echo 'kernel.unprivileged_userns_clone=1' > /etc/sysctl.d/nspawn.conf
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.d/nspawn.conf
systemctl restart systemd-sysctl.service
systemctl enable systemd-networkd
systemctl start systemd-networkd

# params
name=test
container=/var/lib/machines/$name/

# destroy existing setup
systemctl disable systemd-nspawn@$name.service
systemctl stop systemd-nspawn@$name.service
rm -f /etc/systemd/nspawn/$name.nspawn
rm -rf $container

# create new setup
debootstrap --include=systemd-container,ca-certificates buster $container
echo 'deb http://security.debian.org/ buster/updates main contrib non-free' >> $container/etc/apt/sources.list
echo 'deb http://deb.debian.org/debian buster-updates main contrib non-free' >> $container/etc/apt/sources.list
echo 'deb [trusted=yes] file:///repo ./' >> $container/etc/apt/sources.list
cp -rv repo $container/
systemd-nspawn -D $container -E DEBIAN_FRONTEND=noninteractive apt update -y
systemd-nspawn -D $container -E DEBIAN_FRONTEND=noninteractive apt upgrade -y
systemd-nspawn -D $container -E DEBIAN_FRONTEND=noninteractive apt dist-upgrade -y

systemd-nspawn -D $container systemctl enable systemd-networkd.service

mkdir -p /etc/systemd/nspawn/
echo "[Network]" > /etc/systemd/nspawn/$name.nspawn
echo "Zone=$name" >> /etc/systemd/nspawn/$name.nspawn
systemctl enable systemd-nspawn@$name.service
systemctl start systemd-nspawn@$name.service
