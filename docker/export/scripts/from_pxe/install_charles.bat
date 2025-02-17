wpeinit
@if exist drivers.cab (
	mkdir imported_drivers
	expand drivers.cab -F:* imported_drivers
	for /F %%a in ('dir /b /s imported_drivers\*.inf') do drvload %%a
)
wpeutil initializeNetwork

net use Y: \\serveurpxe\samba ||goto fail

call Y:\scripts\external\auto-install.bat Y:\disks\win.wim.d\bureau.wim

@echo copy unattend xml pour auto init le user
copy /y Y:\scripts\external\files\charles-unattend.xml W:\Windows\System32\Sysprep\unattend.xml

@echo copy layoutmodification pour clean menu demarrer et taskbar
copy /y Y:\scripts\external\files\LayoutModification.xml W:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml

@echo set app association
Dism /Image:W:\ /Import-DefaultAppAssociations:Y:\scripts\external\files\AppAssoc.xml

copy /y Y:\scripts\external\files\charles-post-install.bat W:\Windows\System32\Sysprep\charles-post-install.bat
copy /y Y:\scripts\external\files\charles-post-install.ps1 W:\Windows\System32\Sysprep\charles-post-install.ps1

call Y:\scripts\external\pause.bat
wpeutil reboot

:fail
@echo network fucked