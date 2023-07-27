dans install.ipxe on peut inclure des fichier supplémentaire quand on boot sur winpe
le fichier winpeshl.ini permet de lancer des scripts au demarrage de winpe
`winpeshl.ini`
```
[launchApps]
"install.bat"
```
lance le script install.bat automatiquement

`install.bat`
```
wpeinit
net use Y: \\srvpxe\install
call Y:\scripts\external\auto-install.bat Y:\disks\win.wim.d\capture-withapp.wim
call Y:\scripts\external\cp-files.bat
```
se connecte au serveur samba et lance d'autre scripts

`auto-install.bat`
```
@echo Starting WIM Deployment
echo **********************************************************************
@echo * This script now checks to see if you're booted into Windows PE.
@echo.
@if not exist X:\Windows\System32 echo ERROR: This script is built to run in Windows PE.
@if not exist X:\Windows\System32 goto END
@if %1.==. echo ERROR: To run this script, add a path to a Windows image file.
@if %1.==. echo Example: ApplyImage D:\WindowsWithFrench.wim
@if %1.==. goto END
@echo *********************************************************************
@echo  == Setting high-performance power scheme to speed deployment ==
@call powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
@echo *********************************************************************

@echo *********************************************************************
@echo Checking to see if the PC is booted in BIOS or UEFI mode.
wpeutil UpdateBootInfo
for /f "tokens=2* delims=	 " %%A in ('reg query HKLM\System\CurrentControlSet\Control /v PEFirmwareType') DO SET Firmware=%%B
@echo            Note: delims is a TAB followed by a space.
@if x%Firmware%==x echo ERROR: Can't figure out which firmware we're on.
@if x%Firmware%==x echo        Common fix: In the command above:
@if x%Firmware%==x echo             for /f "tokens=2* delims=    "
@if x%Firmware%==x echo        ...replace the spaces with a TAB character followed by a space.
@if x%Firmware%==x goto END
@if %Firmware%==0x1 echo The PC is booted in BIOS mode. 
@if %Firmware%==0x2 echo The PC is booted in UEFI mode. 
@echo *********************************************************************
@echo Formatting the primary disk...
@if %Firmware%==0x1 echo    ...using BIOS (MBR) format and partitions.
@if %Firmware%==0x2 echo    ...using UEFI (GPT) format and partitions. 
@if %Firmware%==0x1 diskpart /s Y:\scripts\external\bios\CreatePartitions-BIOS.txt
@if %Firmware%==0x2 diskpart /s Y:\scripts\external\uefi\CreatePartitions-UEFI.txt 

@echo *********************************************************************
@echo  == Apply the image to the Windows partition ==
dism /Apply-Image /ImageFile:%1 /Index:1 /ApplyDir:W:\
@echo *********************************************************************
@echo == Copy boot files to the System partition ==
W:\Windows\System32\bcdboot W:\Windows /s S:
@echo *********************************************************************

@echo  *********************************************************************
@echo  == Copy the Windows RE image to the Windows RE Tools partition ==
md R:\Recovery\WindowsRE
xcopy /h W:\Windows\System32\Recovery\Winre.wim R:\Recovery\WindowsRE\
@echo  *********************************************************************
@echo  == Register the location of the recovery tools ==
W:\Windows\System32\Reagentc /Setreimage /Path R:\Recovery\WindowsRE /Target W:\Windows
@echo  *********************************************************************
@echo exit install script
exit /b
:END
```
trouve si le pc est en uefi ou bios
lance le script pour formater le disk en fonction
install windows

`cp-files.bat`
```
@echo copy unattend xml pour auto init le user
copy /y Y:\scripts\external\files\unattend.xml W:\Windows\System32\Sysprep\unattend.xml
@echo copy layoutmodification pour clean menu demarrer et taskbar
copy /y Y:\scripts\external\files\LayoutModification.xml W:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml
```
copy les fichiers dans le windows installé
c'est pour m'eviter d'avoir à modifier les images .wim juste pour modifier 1 fichier 
