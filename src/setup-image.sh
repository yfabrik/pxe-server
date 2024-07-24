#!/bin/bash
# 1 command fail = script stop
set -e

function ask_user_yes_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
        [Yy]*) return 0 ;;
        [Nn]*)
            echo "Aborted"
            return 1
            ;;
        esac
    done
}

## TODO functions, git backup ou directory-backup, 
#section auto mounted pour pas placer l'item a la fin de toute la liste,
# boot ||goto failed

iso=$(basename "${1}")
echo iso = $iso
name="${iso%.*}"
echo name = $name
iso_directory=/srv/tftpboot/samba/install/disks/linux
echo iso_dir = $iso_directory
ipxe_file=/var/www/html/install.ipxe
echo ipxe = $ipxe_file
menu_name=$iso
path=$iso_directory/$name/
item="item $menu_name	$iso"

#ask umount if already mounted
if [[ $(findmnt -M "${path}") ]]; then
    ask_user_yes_no "iso aleady mount, UMOUNT it ?"
    sudo umount $path
    echo unmounted $path
    echo remove iso from install.ipxe
    echo backupfile
    echo backup install.ipxe === /var/www/html/install.ipxe-rm-${iso}-$(date +"%Y%m%d%H%M").bak
    sudo cp $ipxe_file /var/www/html/install.ipxe-${iso}-$(date +"%Y%m%d%H%M").bak
    echo removing
    sudo sed -i -e "/${item}/d" -e "/:${menu_name}/,+4d" $ipxe_file
    echo "done"
    ###
    exit 1

fi
# mount iso
echo mounting
sudo mkdir -p $path
sudo mount $1 $path

# emplacement des files de boot
vmlinuz=$(find $path -type f -name "vmlinuz*")
if [[ -z ${vmlinuz} ]]; then
    echo "pas trouvé vmlinuz"
    exit 1
fi
initrd=$(find $path -type f -name "initr*")
if [[ -z "${initrd}" ]]; then
    echo "pas trouvé initrd/initramfs"
    exit 1
fi

#backup install.ipxe
echo backup install.ipxe === /var/www/html/install.ipxe-${iso}.bak
sudo cp $ipxe_file /var/www/html/install.ipxe-${iso}-$(date +"%Y%m%d%H%M").bak

echo edit install.ipxe
# edit install.ipxe
# add entry dans le menu

sudo awk -i inplace -v item="$item" 'FNR==NR{ if (/^item/) p=NR; next} 1; FNR==p{ print item }' $ipxe_file $ipxe_file

#add le contenu de l'entry
cat <<EOF | sudo tee -a $ipxe_file >/dev/null

:$menu_name
kernel \${disks}/linux/$name/${vmlinuz:${#path}}
initrd \${disks}/linux/$name/${initrd:${#path}}
imgargs $(basename $(dirname $vmlinuz)) initrd=initrd root=/dev/nfs boot=$(basename $(dirname $vmlinuz)) netboot=nfs nfsroot=192.168.1.250:/srv/tftpboot/samba/install/disks/linux/$name ip=dhcp --
boot

EOF