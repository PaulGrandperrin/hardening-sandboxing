#!/bin/bash
set -xe


mkdir -p repo/dists/buster/main/binary-amd64
mkdir -p repo/pool/main

mv debs/*.deb repo/pool/main/
cd repo
dpkg-scanpackages . > dists/buster/main/binary-amd64/Packages

cat <<EOF > dists/buster/Release
Origin: Debian
Label: Debian
Suite: stable
Codename: buster
Components: main contrib non-free
SHA256:
$(sha256sum dists/buster/main/binary-amd64/Packages |cut -d' ' -f1) $(ls -l dists/buster/main/binary-amd64/Packages|cut -d' ' -f5) main/binary-amd64/Packages
EOF

