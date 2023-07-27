pour faire l'install de window il faut booter winPE (parce que window tros gros )
si winpe plante, c'est peu etre parce que il manque des drivers

https://learn.microsoft.com/fr-fr/windows-hardware/manufacture/desktop/winpe-create-usb-bootable-drive?view=windows-11
https://learn.microsoft.com/fr-fr/windows-hardware/manufacture/desktop/add-and-remove-drivers-to-an-offline-windows-image?view=windows-11
https://www.bennorummens.com/cloud/how-to-add-winpe-drivers-to-a-boot-wim-via-dism/	
https://www.prajwal.org/powershell-export-drivers-from-windows/#:~:text=On%20your%20Windows%2010%2C%20right,party%20drivers%20will%20be%20exported.



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