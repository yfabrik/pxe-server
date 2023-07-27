mount .wim
```powershell
Dism /Mount-Image /ImageFile:"C:\WinPE_amd64\media\sources\boot.wim" /index:1 /MountDir:"C:\WinPE_amd64\mount"
```
unmount
```powershell
Dism /Unmount-Image /MountDir:"C:\WinPE_amd64\mount" /commit
```
juste commit
```
Dism /Commit-Image /MountDir:C:\test\offline
```
remount image
```
Dism /Remount-Image /MountDir:C:\test\offline
```
capture image
```
Dism /Capture-Image /ImageFile:"C:\custom.wim" /CaptureDir:C:\ /Name:"custom image" /description:"description image" /compress:max
```


Displays information about app packages (.appx or .appxbundle), in an image, that are set to install for each new user.

```
Dism /Image:C:\test\offline /Get-ProvisionedAppxPackages
```