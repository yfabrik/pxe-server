# serveur PXE pour auto install windows
permet de démarrer un PC à partir de la carte réseaux et d'installer automatiquement une image personnalisé de windows 

- [serveur PXE pour auto install windows](#serveur-pxe-pour-auto-install-windows)
  - [SERVEUR HOW TO](#serveur-how-to)
    - [prerequis :](#prerequis-)
    - [installer pihole](#installer-pihole)
    - [activer dir-listing de lighttpd](#activer-dir-listing-de-lighttpd)
    - [setup du serveur DHCP](#setup-du-serveur-dhcp)
    - [creer /srv/tftpboot](#creer-srvtftpboot)
    - [symlink dans serveur web](#symlink-dans-serveur-web)
    - [generer les boot ipxe](#generer-les-boot-ipxe)
  - [winPE](#winpe)
  - [customisation de windows](#customisation-de-windows)
  - [installation windows custom](#installation-windows-custom)
      - [version clé usb](#version-clé-usb)
  - [customisation post install](#customisation-post-install)

## SERVEUR HOW TO
### prerequis :
- serveur ubuntu
- ip fixe sur le serveur ubuntu(editer netplan)
- wget, curl, git, build-essential   ``apt install wget curl build-essential git``

### installer pihole
https://pi-hole.net/  
```curl -sSL https://install.pi-hole.net | bash```  
pihole = serveur DNS et DHCP (c'est le serveur DHCP qui permet de fournir les info pour démarrer à partir du réseau)


### activer dir-listing de lighttpd 
pour pouvoir telecharger les fichier du serveur web  
```lighttpd-enable-mod```  
choisir dir-listing


### setup du serveur DHCP
[20-pxeconfig.conf](pxe-config/20-pxeconfig.conf) copy dans /etc/dnsmaq.d,  
[install.ipxe](pxe-config/install.ipxe) copy dans /var/www/html:  
```
wget -P /etc/dnsmasq.d/ https://raw.githubusercontent.com/yfabrik/pxe-server/main/pxe-config/20-pxeconfig.conf   
wget -P /var/www/html/ https://raw.githubusercontent.com/yfabrik/pxe-server/main/pxe-config/install.ipxe
```

dans l'interface web de pihole activer le dhcp (setting>DHCP>enable et definir range,gateway et ajouter un domain genre "fabrik.lan" parce que c'est bien de pouvoir acceder au serveur avec le nom )

### creer /srv/tftpboot
l'endroit ou le serveur pxe va aller chercher les fichier  
```sudo mkdir -p /srv/tftpboot```
### symlink dans serveur web
pour que tftpboot soit accessible depuis le serveur web  
```sudo ln -s /srv/tftpboot /var/www/html/tftpboot```

### generer les boot ipxe
undionly.kpxe, ipxe.efi, wimboot  
les mettre dans tftpboot  
wimboot:  
```wget -P /srv/tftpboot https://github.com/ipxe/wimboot/releases/latest/download/wimboot```

https://github.com/ipxe/wimboot

pour les 2 autres il faut les build:
```
git clone https://github.com/ipxe/ipxe.git
cd ipxe/src
make bin/undionly.kpxe ##bios
make bin-x86_64-efi/ipxe.efi ##uefi
sudo cp {bin/undionly.kpxe,bin-x86_64-efi/ipxe.efi} /srv/tftpboot/
```

https://ipxe.org/appnote/buildtargets  
https://ipxe.org/download


## winPE
[utiliser winPE](winpe.md)

pour le serveur on copy le contenu de `C:\WinPE_amd64\media` quelque part dans tftpboot, là ou install.ipxe le cherche

## customisation de windows

[personnalisation windows](windows-personnalisé.md)  
- fresh install windows + update + programme  
- run Sysprep dans `c:\windows\system32\sysprep` audit mode + redemmarer  
- on est sur le compte admin local on delete le compte utilisateur qu'on utilisait   
- rerun sysprep OOBE +shutdown
- boot sur winpe 
- generer le fichier .wim image de l'install windows


## installation windows custom
on donne des fichier au moment du boot sur winpe  
au choix: 
  - 1 startnet.cmd
  - winpeshl.ini et un install_*.bat (le winpeshl.ini lance install.bat, c'est le install_* qui à été rename au moment du boot)

#### version clé usb
https://github.com/yfabrik/scripts-install-windows

## customisation post install
les fichier pourrait etre inclu directement dans le fichier .wim, mais ça nécéssite de le modifier a chaque fois que je change un petit truc
[customisation ](personnalisation.md)


