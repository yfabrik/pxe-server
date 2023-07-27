besoins:
- ubuntu serveur
- serveur dhcp
- serveur tftp
- serveur web (pour ipxe)
-  serveur samba (pour que winpe recup les image windows custom et autres)

# serveur dhcp
y'a plusieur posiblité :
https://doc.ubuntu-fr.org/ipxe
avec dhcpcd

https://wiki.archlinux.org/title/Dnsmasq
dnsmasq

https://pi-hole.net/
ou pihole qui en fait utilise dnsmasq 

j'ai choisi pi-hole parce que:
- bloqueur de pub
- serveur http
- interface graphique/track le reseau
- dnsmasq inclu le serveur tftp

avec pi-hole faut activer le serveur dhcp 
faut rajouter un fichier config pour enable les fonctions pxe et tftp
` /etc/dnsmasq.d/20-copyipxe.conf `
```
# Known working dnsmasq version 2.85 config for iPXE proxydhcp usage
# Debug logging
#log-debug

# Disable DNS server
#port=0

# send disable multicast and broadcast discovery, and to download the boot file immediately
# DHCP_PXE_DISCOVERY_CONTROL, should be vendor option? Needs more understanding and source
dhcp-option=vendor:PXEClient,6,2b

# This range(s) is for the public interface, where dnsmasq functions
# as a proxy DHCP server providing boot information but no IP leases.
# Any ip in the subnet will do, so you may just put your server NIC ip here.
#dhcp-range=192.168.1.0,proxy
#dhcp-range=192.168.1.250,proxy
#dhcp-range=192.168.1.5,192.168.1.100,255.255.255.0
#interface=enp2s0
# bind-dynamic - remove interface and use this instead to listen everywhere?
# Disable re-use of the DHCP servername and filename fields as extra
# option space. That's to avoid confusing some old or broken DHCP clients.
#dhcp-no-override

#dhcp-match=set:<tag>,<option number>|option:<option name>|vi-encap:<enterprise>[,<value>]
#dhcp-boot=[tag:<tag>,]<filename>,[<servername>[,<server address>|<tftp_servername>]]

# Based on logic in https://gist.github.com/robinsmidsrod/4008017
# iPXE sends a 175 option, checking suboptions
dhcp-match=set:ipxe-http,175,19
dhcp-match=set:ipxe-https,175,20
dhcp-match=set:ipxe-menu,175,39
# pcbios specific
dhcp-match=set:ipxe-pxe,175,33
dhcp-match=set:ipxe-bzimage,175,24
dhcp-match=set:ipxe-iscsi,175,17
# efi specific
dhcp-match=set:ipxe-efi,175,36
# combination
# set ipxe-ok tag if we have correct combination
# http && menu && iscsi ((pxe && bzimage) || efi)
tag-if=set:ipxe-ok,tag:ipxe-http,tag:ipxe-menu,tag:ipxe-iscsi,tag:ipxe-pxe,tag:ipxe-bzimage
tag-if=set:ipxe-ok,tag:ipxe-http,tag:ipxe-menu,tag:ipxe-iscsi,tag:ipxe-efi

#pxe-service=[tag:<tag>,]<CSA>,<menu text>[,<basename>|<bootservicetype>][,<server address>|<server_name>]
#pxe-prompt=[tag:<tag>,]<prompt>[,<timeout>]
# these create option 43 cruft, which is required in proxy mode
# TFTP IP is required on all dhcp-boot lines (unless dnsmasq itself acts as tftp server?)

###### need parce que le uefi marche pas de base faudra peut etre voir a faire mieux 
dhcp-match=set:efi-x86_64,option:client-arch,7
dhcp-match=set:efi-x86_64,option:client-arch,9
dhcp-match=set:efi-x86,option:client-arch,6
#dhcp-match=set:bios,option:client-arch,0
dhcp-boot=tag:efi-x86_64,ipxe.efi
#dhcp-boot=tag:efi-x86,ipxe32.efi
#dhcp-boot=tag:bios,undionly.kpxe
########
pxe-service=tag:!ipxe-ok,X86PC,PXE,undionly.kpxe,192.168.1.250
pxe-service=tag:!ipxe-ok,IA32_EFI,PXE,snponlyx32.efi,192.168.1.250
pxe-service=tag:!ipxe-ok,BC_EFI,PXE,ipxe.efi,192.168.1.250
pxe-service=tag:!ipxe-ok,X86-64_EFI,PXE,ipxe.efi,192.168.1.250

#pxe-service=PC98, “Boot from network” ipxe.efi
#pxe-service=IA64_EFI, “Boot from network”, ipxe.efi
#pxe-service=Alpha, “Boot from network”, ipxe.efi
#pxe-service=Arc_x86, “Boot from network”, ipxe.efi
#pxe-service=Intel_Lean_Client, “Boot from network”, ipxe.efi
#pxe-service=Xscale_EFI, “Boot from network”, ipxe.efi

# later match overrides previous, keep ipxe script last
# server address must be non zero, but can be anything as long as iPXE script is not fetched over TFTP
dhcp-boot=tag:ipxe-ok,http://192.168.1.250/install.ipxe

# To use internal TFTP server enabled these, recommended is otherwise atftp
enable-tftp
tftp-root=/srv/tftpboot/

#dhcp-option=3,192.168.1.254
#dhcp-option=option:netmask,255.255.255.0
#dhcp-option=6,192.168.1.254
#domain=fabrik.lan
#server=1.1.1.1
#server=1.0.0.1
#dhcp-host=00:1e:c9:45:99:a8,192.168.1.3
#expand-hosts
```

# serveur tftp
creation du dossier
`sudo mkdir -p /srv/tftpboot`

créer les fichier wimboot, undionly.kpxe et ipxe.efi dedans
https://github.com/ipxe/wimboot
https://github.com/ipxe/ipxe
https://ipxe.org/appnote/buildtargets
https://ipxe.org/download
pour ipxe 
```
git clone https://github.com/ipxe/ipxe.git
cd ipxe/src
make bin/undionly.kpxe
make bin-x86_64-efi/ipxe.efi
```

# serveur web
pihole utilise lighthttp
faut activer le dir listing pour que le pc qui utilise pxe puisse recup les fichiers qu'il a besoin
`/etc/lighttpd/conf-enabled/10-dir-listing.conf` 
dir-listing.encoding = "utf-8"
server.dir-listing   = "enable"

et à la fin de  `/etc/lighttpd/lighttpd.conf`
server.modules += (
	"mod_dirlisting",
	"mod_staticfile",
)

et faire un lien vers tftpboot
	`sudo ln -s /srv/tftpboot /var/www/html/tftpboot`

ajouter le fichier install.ipxe
`/var/www/html/install.ipxe `
```

#!ipxe

set menu-timeout 300000
set submenu-timeout ${menu-timeout}
isset ${menu-default} || set menu-default famille
set server_ip http://192.168.1.250/tftpboot
set disks ${server_ip}/samba/install/disks
set scripts ${server_ip}/samba/install/scripts/internal
:start
menu
item --gap --           -------------WINPE----------------
item winpe           	winpe	
item massdriver		winpe avec mass de driver
item acer		winpe pour les acer
item install_acer	install ++ acer
item tmp		install acer UEFI
item --gap --           -------------INSTALL WINDOWS AUTO----------------
item famille		auto install PC Famille
item famille-bios	auto install PC famille en BIOS
item famille-uefi	auto install PC famille en UEFI
item install-withapp	auto install window avec MAJ et APPS
item --gap --           -------------LINUX----------------
item mint      		linux mint
item kali		kali linux
item --gap --           -------------UTILS----------------
item pxelinux		pxelinux
item shell              Shell iPXE
item reboot		reboot
item shutdown		stop
item exit              	Exit

choose --timeout ${menu-timeout} --default ${menu-default} target && goto ${target}

:winpe
kernel ${server_ip}/wimboot
initrd ${disks}/winPE/winpefr/Boot/BCD		BCD
initrd ${disks}/winPE/winpefr/Boot/boot.sdi	boot.sdi
initrd ${disks}/winPE/winpefr/sources/boot.wim	boot.wim
boot

:massdriver
kernel ${server_ip}/wimboot
initrd ${disks}/winPE/winpe_massdriver/Boot/BCD		BCD
initrd ${disks}/winPE/winpe_massdriver/Boot/boot.sdi	boot.sdi
initrd ${disks}/winPE/winpe_massdriver/sources/boot.wim	boot.wim
boot

:acer
kernel ${server_ip}/wimboot
initrd ${disks}/winPE/winpe_acer/Boot/BCD		BCD
initrd ${disks}/winPE/winpe_acer/Boot/boot.sdi		boot.sdi
initrd ${disks}/winPE/winpe_acer/sources/boot.wim	boot.wim
boot

:install_acer
initrd ${scripts}/install_withapp.bat		install.bat
initrd ${scripts}/winpeshl.ini   		winpeshl.ini
goto acer

:tmp
initrd ${scripts}/install_withapp_uefi.bat	install.bat
initrd ${scripts}/winpeshl.ini   		winpeshl.ini
goto acer



:mint
kernel ${disks}/linux/mint/casper/vmlinuz
initrd ${disks}/linux/mint/casper/initrd.lz
imgargs vmlinuz initrd=initrd root=/dev/nfs boot=casper netboot=nfs nfsroot=192.168.1.250:/srv/tftpboot/samba/install/disks/linux/mint ip=dhcp --
boot

:kali
kernel ${server_ip}/kali/live/vmlinuz
initrd ${server_ip}/kali/live/initrd.img
imgargs vmlinuz initrd=initrd root=/dev/nfs boot=live netboot=nfs nfsroot=192.168.1.250:/srv/tftpboot/samba/install/disks/linux/kali ip=dhcp --
boot

:install-withapp
initrd ${scripts}/install_withapp.bat		install.bat
initrd ${scripts}/winpeshl.ini   		winpeshl.ini
goto massdriver

:famille
initrd ${scripts}/install_famille.bat		install.bat
initrd ${scripts}/winpeshl.ini			winpeshl.ini
goto massdriver

:famille-uefi
initrd ${scripts}/install_famille_uefi.bat	install.bat
initrd ${scripts}/winpeshl.ini			winpeshl.ini
goto massdriver

:famille-bios
initrd ${scripts}/install_famille_bios.bat	install.bat
initrd ${scripts}/winpeshl.ini			winpeshl.ini
goto massdriver

:pxelinux
dhcp net0
set 210:string tftp://192.168.1.250/
#set 210:string tftp://${dhcp-server}/
chain ${210:string}pxelinux.0 || goto failed
goto start


:reboot
reboot

:shutdown
poweroff

:shell
shell

:exit
exit

```
et normalement ça doit boot dessus

# serveur samba
pour que winPE puisse installer windows il doit le recuperer sur un dossier partagé
`/etc/samba/smb.conf`
```
# Global parameters
[global]
	log file = /var/log/samba/log.%m
	logging = file
	map to guest = Bad User
	max log size = 1000
	obey pam restrictions = Yes
	pam password change = Yes
	panic action = /usr/share/samba/panic-action %d
	passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
	passwd program = /usr/bin/passwd %u
	server role = standalone server
	server string = %h server (Samba, Ubuntu)
	unix password sync = Yes
	usershare allow guests = Yes
	idmap config * : backend = tdb


[printers]
	browseable = No
	comment = All Printers
	create mask = 0700
	path = /var/spool/samba
	printable = Yes


[print$]
	comment = Printer Drivers
	path = /var/lib/samba/printers


[install]
	comment = share pour network install
	guest ok = Yes
	path = /srv/tftpboot/samba/install

```
ajouter les fichiers dans le partage
les scripts
les images windows