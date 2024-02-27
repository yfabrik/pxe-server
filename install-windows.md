# classic install
- download iso depuis le site de microsoft
- faire une clé bootable avec rufus ou balena etcher

## use ventoy
https://www.ventoy.net ça évite de bloquer une clé pour juste une iso


boot sur la clé, dépend de la marque du PC, faut spam F1,F2,F8,F10,échap....(pour ça que le boot sur le réseau c'est pratique, F12 tout le temps)
then next next next next ....

# classic ++
ajouter un fichier autounattend.xml ou unattend.xml pour automatiser l'install
https://schneegans.de/windows/unattend-generator/
copier le fichier sur la clé bootable

pour ventoy
https://www.ventoy.net/en/plugin_autoinstall.html
mais j'ai l'impression que si le fichier s'appelle autounattend.xml windows boot avec de toute façon


# ajouter des scripts à executer au premier demmarage de windows dans autounatend.xml > firstlogon

# utiliser des image custom
voir le repo pour ça

# boot from network


#active license
le pc license doit et le pc à activer doivent etre branché sur le meme réseau
## la version foireuse de base 
- utiliser la clé usb sur le pc à activer
- run marxpress
- mettre la clé sur le pc license
- copier le fichier du dossier output de la clé usb dans le dossier ???
- le logiciel d'activation: import , valider

## version actuelle 
- ouvrir powershell
```powershell
iwr -useb http://srvpxe/activation.ps1 |iex
```
- logiciel activation import , valider


## how to version actuelle
dossier partagé sur samba avec le contenu de la clé usb
script sur le serveur web qui permet de verifier/ouvrir powershell en admin + monte le dossier partagé + execute le script de la clé
