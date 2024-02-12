# winPE
windows pre execution environnement  
c'est un windows allégé qui peut etre utilisé avec un clé bootable comme pour linux

## creer winPE
powershell admin : installer windows adk
```powershell
winget install -e --id Microsoft.WindowsADK;winget install -e --id Microsoft.ADKPEAddon
```


open  **Environnement de déploiement et d’outils de création d’images** en tant qu’administrateur.
```cmd
copype amd64 C:\WinPE_amd64
```

retour dans powershell
- mount image
```powershell
Dism /Mount-Image /ImageFile:"C:\WinPE_amd64\media\sources\boot.wim" /index:1 /MountDir:"C:\WinPE_amd64\mount"
```

- add drivers 
(optionnel, et ça peut ne pas servir,
y'a des pc qui ont pas le pilote de la carte réseaux meme comme ça )
```powershell
#get drivers from current windows
Export-WindowsDriver -online -destination c:\drivers

#add them to winpe
Dism /Add-Driver /Image:"C:\WinPE_amd64\mount" /Driver:"C:\drivers" /recurse
```

- change langue 
```powershell

Dism /Add-Package /Image:"C:\WinPE_amd64\mount" /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\fr-fr\lp.cab"

Dism /Set-AllIntl:fr-FR /Image:"C:\WinPE_amd64\mount"
```

- unmount image
```powershell
Dism /Unmount-Image /MountDir:"C:\WinPE_amd64\mount" /commit
```
use /discard au lieu de /commit si on veut pas garder ce qu'on a fait


pour le serveur on copie le dossier `C:\WinPE_amd64\media` dans tftpboot (emplacement=install.ipxe)    
pour le serveur on copy le contenu de `C:\WinPE_amd64\media` quelque part dans tftpboot, là ou install.ipxe le cherche
  
pour la clé usb : faire une iso  
**Environnement de déploiement et d’outils de création d’images**
```cmd
MakeWinPEMedia /ISO C:\WinPE_amd64 C:\WinPE_amd64\WinPE_amd64.iso
```

