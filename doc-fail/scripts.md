auto install
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


partition disk
```
rem == CreatePartitions-BIOS.txt ==
rem == These commands are used with DiskPart to
rem    create three partitions
rem    for a BIOS/MBR-based computer.
rem    Adjust the partition sizes to fill the drive
rem    as necessary. ==
select disk 0
clean
rem == 1. System partition ======================
create partition primary size=100
format quick fs=ntfs label="System"
assign letter="S"
active
rem == 2. Windows partition =====================
rem ==    a. Create the Windows partition =======
create partition primary
rem ==    b. Create space for the recovery tools  
rem       ** Update this size to match the size of
rem          the recovery tools (winre.wim)
rem          plus some free space.
shrink minimum=500
rem ==    c. Prepare the Windows partition ====== 
format quick fs=ntfs label="Windows"
assign letter="W"
rem == 3. Recovery partition ====================
create partition primary
format quick fs=ntfs label="Recovery image"
assign letter="R"
set id=27
list volume
exit
```

```
rem == CreatePartitions-UEFI.txt ==
rem == These commands are used with DiskPart to
rem    create four partitions
rem    for a UEFI/GPT-based PC.
rem    Adjust the partition sizes to fill the drive
rem    as necessary. ==
select disk 0
clean
convert gpt
rem == 1. System partition =========================
create partition efi size=100
rem    ** NOTE: For Advanced Format 4Kn drives,
rem               change this value to size = 260 ** 
format quick fs=fat32 label="System"
assign letter="S"
rem == 2. Microsoft Reserved (MSR) partition =======
create partition msr size=16
rem == 3. Windows partition ========================
rem ==    a. Create the Windows partition ==========
create partition primary 
rem ==    b. Create space for the recovery tools ===
rem       ** Update this size to match the size of
rem          the recovery tools (winre.wim)
rem          plus some free space.
shrink minimum=500
rem ==    c. Prepare the Windows partition ========= 
format quick fs=ntfs label="Windows"
assign letter="W"
rem === 4. Recovery partition ======================
create partition primary
format quick fs=ntfs label="Recovery"
assign letter="R"
set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
gpt attributes=0x8000000000000001
list volume
exit
```

