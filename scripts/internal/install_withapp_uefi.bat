
wpeinit
net use Y: \\srvpxe\install
call Y:\scripts\external\auto-install-uefi.bat Y:\disks\win.wim.d\capture-withapp.wim
call Y:\scripts\external\cp-files.bat
