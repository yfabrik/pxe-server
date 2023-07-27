automatically activated at boot (or when another sp
apres l'install des logiciels et update
faut pas que y'ai d'app installé que pour 1 utilisateur (genre winget)
windows/system32/sysprep
lancer en audit mode et restart (generalize ?)
ça reboot avec le compte admin local
delete l'utilisateur
windows/system32/sysprep
en mode oobe generalize et shutdown

boot sur winpe 
```
Dism /Capture-Image /ImageFile:"D:\Images\Fabrikam.wim" /CaptureDir:C:\ /Name:'Fabrikam'
```
autres flags /description:"some info "  /compress:max

redemarrer le pc en normal pour recup le fichier (ou alors le creer direct sur le srv samba)

pour install le window custom on boot sur winPE
puis soit on fait avec diskpart les partition et on copie le contenu du .wim sur la bonne partition et apres faut mettre le bootloader correct (pas reussi pour le moment)
(finalement c'est bon c'est juste que le boot order commençait par network boot)
par contre il semble qu'on ne peut pas automatiser la creation du compte
https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/oem-deployment-of-windows-desktop-editions-sample-scripts?preserve-view=true&view=windows-10#CreatePartitions-_firmware_.txt

https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/capture-and-apply-windows-using-a-single-wim?view=windows-11

https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/capture-and-apply-windows-system-and-recovery-partitions?view=windows-11

sinon
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
genre ajouter unattend.xml
à `c:\windows\system32\sysprep`