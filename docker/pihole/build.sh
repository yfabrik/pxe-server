#!/bin/bash
echo "update repo"
apt update && apt upgrade -y

echo "install requirement"
apt install git build-essential wget liblzma-dev -y

mkdir -p /src && cd /src

echo "download wimboot"
wget https://github.com/ipxe/wimboot/releases/latest/download/wimboot

echo "ipxe"
git clone https://github.com/ipxe/ipxe.git
cd ./ipxe/src || (echo "no such dir " && exit)
make bin/undionly.kpxe
make bin-x86_64-efi/ipxe.efi
make bin-x86_64-efi/snponly.efi
