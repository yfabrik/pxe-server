# generate 
- run sysprep (`c:\windows\system32\sysprep`) en audit mode + redemarrer pour reboot sur le compte admin local
- delete user account
- tweak
- run sysprep OOBE + generalize + eteindre
	- si marche pas :probable que il faille remove winget:
```powershell
winget source remove msstore #parce que fuck microsoft
winget list #chercher l'id de l'app winget
winget remove *app winget*
```
- start on winPE
- run: 
```
Dism /Capture-Image /ImageFile:"C:\custom.wim" /CaptureDir:C:\ /Name:"custom image" /description:"description image" /compress:max
```

l'image peut etre monté pour etre remodifié
genre inclure unattend.xml à `c:\windows\system32\sysprep`



# install
pour install le window custom on boot sur winPE

et on exec le script auto install qui formate le disk et copy windows
![[scripts]]


https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/oem-deployment-of-windows-desktop-editions-sample-scripts?preserve-view=true&view=windows-10#CreatePartitions-_firmware_.txt

https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/capture-and-apply-windows-using-a-single-wim?view=windows-11

https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/capture-and-apply-windows-system-and-recovery-partitions?view=windows-11

### sinon

on extrait une iso classic de win10 dans un dossier sur un srv samba et on remplace sources/install.wim par le fichier custom .wim (doit etre renommé aussi en install.wim)
et sur winPE on mount le srv samba et on lance le setup
```
net use y: \\192.168.1.3\partage
y:pxe\customwin10\setup.exe
```
on peut lui donner un fichier autounattend pour auto l'install
```
y:pxe\customwin10\setup.exe /unattend:y:pxe\autounattend.xml
```


on peut mount le .wim pour le modifier 
genre ajouter unattend.xml pour automatiser la creation du compte
à `c:\windows\system32\sysprep`
