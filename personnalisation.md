# personalisation de windows
## application par défaut
[applications par defaut](scripts/external/files/AppAssoc.xml)  
défini plusieurs application par défaut pour pas avoir a ouvrir edge par exemple, et utilser les apps que j'ai installé

## personnalisation menu démarrer
se trouve dans `C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml`  
[menu démarrer et barre des tache](scripts/external/files/LayoutModification.xml)  
pas de tuile = pas de téléchargement d'app publicitaire

## auto OOBE
se trouve dans `C:\Windows\System32\Sysprep\unattend.xml`  
[automatisation de la création du compte apres l'install](scripts/external/files/unattend.xml)

## script post install
se trouve dans `C:\Windows\System32\Sysprep\post-install.bat` exécuté par le unattend.xml  
[command a executer a la premiere connection](scripts/external/files/post-install.bat)   
disable telemetry, password duration infinite