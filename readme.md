# serveur PXE pour auto install windows
## creer serveur PXE
*install fait sur ubuntu serveur*
### install pihole
need static ip (ubuntu -> edit netplan)

### lighthttpd enable  dir-listing
`lighthttpd-enable-mod`  
choisir dir-listing


### setup config
[20-pxeconfig.conf](pxe-config/20-pxeconfig.conf) copy dans /etc/dnsmaq.d  
[install.ipxe](pxe-config/install.ipxe) copy dans /var/www/html
regler pihole avec dhcp activé

### creer /srv/tftpboot
`sudo mkdir -p /srv/tftpboot`
### symlink dans serveur web
`sudo ln -s /var/lib/tftpboot /var/www/html/tftpboot`

### generer les boot ipxe
undionly.kpxe
ipxe.efi
wimboot
les mettre dans tftpboot

https://github.com/ipxe/wimboot
https://github.com/ipxe/ipxe
https://ipxe.org/appnote/buildtargets
https://ipxe.org/download

```
git clone https://github.com/ipxe/ipxe.git
cd ipxe/src
make bin/undionly.kpxe
make bin-x86_64-efi/ipxe.efi
```

## winPE

[utiliser winPE](winpe.md)

pour le serveur on copy le contenu de `C:\WinPE_amd64\media` quelque part dans tftpboot, là ou install.ipxe le cherche

## customisation de windows
fresh install windows + update + programme
run Sysprep dans `c:\windows\system32\sysprep` audit mode + redemmarer
on est sur le compte admin local on delete le compte utilisateur qu'on utilisait 
rerun sysprep OOBE +shutdown
boot sur winpe 
generer le fichier .wim image de l'install windows


## installation windows custom


## customisation post install
les fichier pourrait etre inclu directement dans le fichier .wim, mais ça nécéssite de le modifier a chaque fois que je change un petit truc
[customisation ](personnalisation.md)


