# creer serveur PXE
### serveur ubuntu
### install pihole
### lighthttpd enable  dir-listing
    lighthttpd-enable-mod
    dir-listing


### copy files
[20-pxeconfig.conf](pxe-config/20-pxeconfig.conf) copy dans /etc/dnsmaq.d
[install.ipxe](pxe-config/install.ipxe) copy dans /var/www/html

creer /srv/tftpboot
symlink dans serveur web
`sudo ln -s /var/lib/tftpboot /var/www/html/tftpboot`

### generer les boot ipxe
undionly.kpxe
ipxe.efi

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

# winpe


install 
```powershell
winget install -e --id Microsoft.WindowsADK;winget install -e --id Microsoft.ADKPEAddon
```


open  **Environnement de déploiement et d’outils de création d’images** en tant qu’administrateur.
```cmd
copype amd64 C:\WinPE_amd64
```


mount .wim
```powershell
Dism /Mount-Image /ImageFile:"C:\WinPE_amd64\media\sources\boot.wim" /index:1 /MountDir:"C:\WinPE_amd64\mount"
```

add drivers
```powershell
#get drivers from current windows
Export-WindowsDriver -online -destination c:\drivers

#add them to winpe
Dism /Add-Driver /Image:"C:\WinPE_amd64\mount" /Driver:"C:\drivers" /recurse
```

change lang 
```powershell

Dism /Add-Package /Image:"C:\WinPE_amd64\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\fr-fr\lp.cab"

Dism /Set-AllIntl:fr-FR /Image:"C:\WinPE_amd64\mount"
```

unmount
```powershell
Dism /Unmount-Image /MountDir:"C:\WinPE_amd64\mount" /commit
```
use /discard au lieu de /commit si on veut pas garder ce qu'on a fait

faire une iso
**Environnement de déploiement et d’outils de création d’images**
```cmd
MakeWinPEMedia /ISO C:\WinPE_amd64 C:\WinPE_amd64\WinPE_amd64.iso
```

pour le serveur on copy le contenu de `C:\WinPE_amd64\media` 