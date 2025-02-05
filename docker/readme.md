# TODO
le probleme des ip addresse
pihole est en cap admin donc il a l'ip de l'host
faut que je refasse les fichier pour qu'il s'update avec la bonne ip



placer 20-pxeconfig
et install.ipxe

# structure


TFTP
    - ipxe.efi
    - undionly.kpxe
HTTP
    - install.ipxe
    - wimboot
    - driver script
    - boot files
    - winpe
SAMBA
    - windows ISO
    - des scripts
NFS
    - linux ISOs
