#!/bin/sh
set -xe

#ip tuntap add tap0 mode tap
#ip addr add 172.16.0.1/24 dev tap0
#ip link set tap0 up
#sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
#iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
#iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#iptables -A FORWARD -i tap0 -o eth0 -j ACCEPT
#
#
#echo "in guest:"
#echo "ip addr add 172.16.0.2/24 dev eth0"
#echo "ip link set eth0 up"
#echo "ip route add default via 172.16.0.1 dev eth0"
#echo "echo 'nameserver 8.8.8.8' >> /etc/resolv.conf"
#

cp microvm/90-microvm.network /etc/systemd/network/
systemctl enable systemd-networkd
systemctl restart systemd-networkd

umount -q mdir || true
rm -f rootfs.ext4
dd if=/dev/zero of=rootfs.ext4 bs=1M count=1000
mkfs.ext4 rootfs.ext4
mkdir -p mdir
mount rootfs.ext4 mdir
container=mdir

debootstrap --include=ca-certificates buster $container
echo 'deb http://security.debian.org/ buster/updates main contrib non-free' >> $container/etc/apt/sources.list
echo 'deb http://deb.debian.org/debian buster-updates main contrib non-free' >> $container/etc/apt/sources.list
#echo 'deb [trusted=yes] file:///repo ./' >> $container/etc/apt/sources.list
#cp -rv repo $container/
systemd-nspawn -D $container -E DEBIAN_FRONTEND=noninteractive apt update -y
systemd-nspawn -D $container -E DEBIAN_FRONTEND=noninteractive apt upgrade -y
systemd-nspawn -D $container -E DEBIAN_FRONTEND=noninteractive apt dist-upgrade -y
systemd-nspawn -D $container systemctl enable systemd-networkd.service
systemd-nspawn -D $container systemctl enable systemd-resolved.service
cp microvm/eth0.network $container/etc/systemd/network/ # override default conf to remove LinkLocalAddressing which conflicts with GCP internal DNS address #sad
cp microvm/serial-getty@ttyS0.service $container/etc/systemd/system/
ln -sf /run/systemd/resolve/stub-resolv.conf $container/etc/resolv.conf

umount mdir

wget https://github.com/firecracker-microvm/firecracker/releases/download/v0.19.0/firecracker-v0.19.0 -O firecracker
chmod +x firecracker
./firecracker --no-api --config-file microvm/config.json
