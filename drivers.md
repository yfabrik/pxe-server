# drivers
quand on boot sur winPE sur certain PC in n'a pas tout les drivers(dont la carte réseau)  
pour résoudre ce probleme il faut soit:
- refaire l'image winPE en lui ajoutant les drivers

  les drivers on peut les avoir depuis le site du constructeur ou les récup sur un pc similaire avec :
  ```
  Export-WindowsDriver -Online -Destination d:\drivers
  ```
  ensuite on les ajoute à l'image avec:
  ```
  # mount image
  Dism /Mount-Image /ImageFile:C:\test\images\install.wim /MountDir:C:\test\offline
  
  #add 1 driver
  Dism /Image:C:\test\offline /Add-Driver /Driver:C:\drivers\mydriver.inf

  # add multiple driver to image
  Dism /Image:C:\test\offline /Add-Driver /Driver:c:\drivers /Recurse
  
  #unmount image
  Dism /Unmount-Image /MountDir:C:\test\offline /Commit
  ```
  
  le probleme c'est que c'est pas toujours les memes drivers a ajouter et donc fini avec une image gigantesque si on rajoute des driver à chaque fois que y'a un probleme

- les ajouter dynamiquement au lancement de winpe  
  ipxe peut détecter le numero de série de la carte réseau et avec ce numéro on peut avoir le modele  
  ensuite on envoie les info sur une page php qui renvoi un fichier .cab(comme un zip, winPE connait que l'archive .cab) qui sera ajouté à winPE,  
  dans winPE il sufira de lui faire extraire les fichier contenu dans l'archive .cab et charger les drivers, au tout début de l'automatisation  

### exemple récupération info nic dans ipxe
  ```ipxe
  echo Downloading kernel module for ${net0/chip}...
set vendor_id ${pci/${net0/busloc}.0.2}
set device_id ${pci/${net0/busloc}.2.2}
initrd http://my.web.server/kmod.php?v=${vendor_id}&d=${device_id} /lib/modules/${chip}.ko
```

### script php creation .cab
néssécite d'installer lcab pour generer le .cab et d'activer fastcgi-php pour lighttpd  
`sudo apt install lcab`  
`sudo lighttpd-enable-mod`  

```php
<?php
$file = "test.cab"; 
exec("lcab test.txt ".$file);  

header('Content-Description: File Transfer');
header('Content-Disposition: attachment; filename='. basename($file));
header('Expires: 0');
header('Cache-Control: must-revalidate');
header('Pragma: public');
header('Content-Length: ' . filesize($file));
header("Content-Type: application/vnd.ms-cab-compressed"); 
readfile($file);

```

### install le driver dans winPE

```cmd
mkdir driver
expand driver.cab driver
drvload driver/driver.inf
```

pour les driver on utilise le .inf comme depart mais il faut les autres fichiers qui ont le meme nom mais pas la meme extension

TODO add for loop et variable pour récup name .inf