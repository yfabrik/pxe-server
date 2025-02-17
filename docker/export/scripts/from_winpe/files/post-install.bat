:: disable telemetry
sc config DiagTrack start= disabled
sc config dmwappushservice start= disabled

sc stop DiagTrack
sc stop dmwappushservice 

schtasks /delete /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /f

:: password never expire
net accounts /MAXPWAGE:UNLIMITED
wmic UserAccount set PasswordExpires=False

::show file extension in file explorer
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 0 /f
