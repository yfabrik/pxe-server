# création images windows personnalisé
## famille:
- débrancher internet (pour pas que les app publicitaire salissent l'install)
- installation classique windows 10
- quand installation finit, détacher les app du menu démarrer 
- remettre internet et laisser faire les mises à jour, pas besoin de faire les mises à jour facultatives
- quand mise à jour finit c'est prêt 

## bureau
- reprend après les maj de famille
- installer les app bonus: firefox, vlc, notepad++, 7zip, libreoffice
```
winget source remove msstore;
winget install VideoLAN.VLC -e;winget install Mozilla.Firefox -e;winget install 7zip.7zip -e;winget install Notepad++.Notepad++ -e;winget install -e TheDocumentFoundation.LibreOffice;
```
si winget marche pas faut faire les maj des app dans microsoft store
- c'est prêt

## création image
- debrancher internet
- executer sysprep dans `c:\windows\sytem32\sysprep` mode audit et reboot
- le pc reboot sur compte administrateur local
- supprimer le compte utilisateur qui à été utilisé dans la creation du pc (parametre->comptes-> autre comptes)
- verifier que le dossier de l'utilisateur n'existe plus
- supprimer les dossier c:\intel ou c:\amd ???
- relancer sysprep  oobe mode, generalize, shutdown

## recuperer l'image
- rebrancher internet
- booter sur un winPE
- `Dism /Capture-Image /ImageFile:"C:\custom.wim" /CaptureDir:C:\ /Name:"custom image" /description:"description image" /compress:max`
- reboot le pc normalement 
- image généré `c:\custom.wim`