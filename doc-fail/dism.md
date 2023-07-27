https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-image-management-command-line-options-s14?view=windows-11

https://c-nergy.be/blog/?p=13808



mount .wim
```powershell
Dism /Mount-Image /ImageFile:"C:\WinPE_amd64\media\sources\boot.wim" /index:1 /MountDir:"C:\WinPE_amd64\mount"
```
unmount
```powershell
Dism /Unmount-Image /MountDir:"C:\WinPE_amd64\mount" /commit
```

add driver 
```
Dism /Add-Driver /Image:"C:\WinPE_amd64\mount" /Driver:"C:\drivers" /recurse
```

change lang ?
```powershell
Dism /Set-AllIntl:fr-FR /Image:"C:\WinPE_amd64\mount"
```

get info 