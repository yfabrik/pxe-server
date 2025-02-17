wpeinit
@if exist drivers.cab (
	mkdir imported_drivers
	expand drivers.cab -F:* imported_drivers
	for /F %%a in ('dir /b /s imported_drivers\*.inf') do drvload %%a
)
wpeutil initializeNetwork
net use Y: \\serveurpxe\samba ||goto fail
call Y:\scripts\external\auto-install.bat Y:\disks\win.wim.d\bureau.wim
call Y:\scripts\external\cp-files.bat
call Y:\scripts\external\pause.bat
wpeutil reboot

:fail
@echo network fucked
