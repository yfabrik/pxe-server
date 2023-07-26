@echo copy unattend xml pour auto init le user
copy /y Y:\scripts\external\files\unattend.xml W:\Windows\System32\Sysprep\unattend.xml
@echo copy layoutmodification pour clean menu demarrer et taskbar
copy /y Y:\scripts\external\files\LayoutModification.xml W:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml

@echo set app association
Dism /Image:W:\ /Import-DefaultAppAssociations:Y:\scripts\external\files\AppAssoc.xml

@echo post install script
copy /y Y:\scripts\external\files\post-install.bat W:\Windows\System32\Sysprep\post-install.bat
