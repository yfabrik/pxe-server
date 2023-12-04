# serveur PXE pour auto install windows
permet de démarrer un PC à partir de la carte réseaux et d'installer automatiquement une image personnalisé de windows 


## HOW TO
### prerequis :
- serveur ubuntu
- ip fixe sur le serveur ubuntu(editer netplan)

### installer pihole
https://pi-hole.net/  
`curl -sSL https://install.pi-hole.net | bash`  
pihole = serveur DNS et DHCP (c'est le serveur DHCP qui permet de fournir les info pour démarrer à partir du réseau)


### activer dir-listing de lighthttpd 
pour pouvoir telecharger les fichier du serveur web
`lighthttpd-enable-mod`  
choisir dir-listing


### setup du serveur DHCP
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
wimboot:
wget https://github.com/ipxe/wimboot/releases/latest/download/wimboot

https://github.com/ipxe/wimboot

git clone https://github.com/ipxe/ipxe
cd ipxe/src
pour bios `make bin/undionly.kpxe`
pour uefi `make bin-x86_64-efi/ipxe.efi`

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
on file des fichier au moment du boot sur winpe
soit 1 startnet.cmd
soit winpeshl.ini et un install_*.bat (le winpeshl.ini lance install.bat, c'est le install_* qui à été rename au moment du boot)

#### version clé usb
https://github.com/yfabrik/scripts-install-windows

## customisation post install
les fichier pourrait etre inclu directement dans le fichier .wim, mais ça nécéssite de le modifier a chaque fois que je change un petit truc
[customisation ](personnalisation.md)


