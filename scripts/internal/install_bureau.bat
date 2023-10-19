wpeinit
net use Y: \\srvpxe\install
call Y:\scripts\external\auto-install.bat Y:\disks\win.wim.d\bureau.wim
call Y:\scripts\external\cp-files.bat
call Y:\scripts\external\pause.bat
wpeutil reboot
