
:: disable telemetry
sc config DiagTrack start= disabled
sc config dmwappushservice start= disabled

sc stop DiagTrack
sc stop dmwappushservice 

schtasks /delete /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /f

:: password never expire
net accounts /maxpwage:UNLIMITED

::show file extension in file explorer
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 0 /f

:: map le partage
net use p: \\serveur\partage /persistent:yes

:: call the ps1 for the rest
powershell -executionPolicy bypass -noprofile -file "c:\windows\system32\sysprep\charles-post-install.ps1"
