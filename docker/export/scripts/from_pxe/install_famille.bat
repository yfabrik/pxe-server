wpeinit

@if exist drivers.cab (
	mkdir imported_drivers
	expand drivers.cab -F:* imported_drivers
	for /F %%a in ('dir /b /s imported_drivers\*.inf') do drvload %%a
)
wpeutil initializeNetwork

net use Y: \\serveurpxe\samba
call Y:\scripts\external\auto-install.bat Y:\disks\win.wim.d\famille.wim
copy /y Y:\scripts\external\autounattend.xml W:\windows\system32\sysprep\unattend.xml

wpeutil reboot