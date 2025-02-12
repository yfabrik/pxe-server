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

echo "tweak ipxe"
sed -i "/define POWEROFF_CMD/s|^//||" config/general.h
sed -i "/define REBOOT_CMD/s|^//||" config/general.h
sed -i "/define PING_CMD/s|^//||" config/general.h

sed -i "/define KEYBOARD_MAP/s/\s\+\S\+$/ fr/" config/console.h
echo "tweak done"

make bin/undionly.kpxe
make bin-x86_64-efi/ipxe.efi
make bin-x86_64-efi/snponly.efi
