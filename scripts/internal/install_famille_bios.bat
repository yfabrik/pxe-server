wpeinit
net use Y: \\srvpxe\install
call Y:\scripts\external\auto-install-bios.bat Y:\disks\win.wim.d\famille.wim
copy /y Y:\scripts\external\autounattend.xml W:\windows\system32\sysprep\unattend.xml
