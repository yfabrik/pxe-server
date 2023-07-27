pi-hole c'est un serveur dns qui permet de bloquer les pubs https://pi-hole.net/
il est basé sur dnsmasq
c'est comme si on utilisait dnsmasq normal sauf qu'on a une interface graphique
faut activer le serveur dhcp 
et pour rajouter le support de pxe suffit de rajouter un fichier config dans 
` /etc/dnsmasq.d/20-copyipxe.conf `
```

dhcp-option=vendor:PXEClient,6,2b

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

```


creer un dossier pour le serveur tftp
`sudo mkdir -p /srv/tftpboot`

créer les fichiers undionly.kpxe, ipxe.efi, wimboot
