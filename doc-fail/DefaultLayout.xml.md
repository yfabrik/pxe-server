pour faire un menu démarrer et une barre des tache personnalisé

modif layout
https://learn.microsoft.com/en-us/windows/configuration/configure-windows-10-taskbar


`c:\users\default\appdata\local\microsoft\windows\shell\layoutModification.xml`
```xml
<LayoutModificationTemplate xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
  <LayoutOptions StartTileGroupCellWidth="6" />
  <DefaultLayoutOverride>
    <StartLayoutCollection>
      <defaultlayout:StartLayout GroupCellWidth="6">
       
      </defaultlayout:StartLayout>
    </StartLayoutCollection>
  </DefaultLayoutOverride>
 <CustomTaskbarLayoutCollection PinListPlacement="Replace">
    <defaultlayout:TaskbarLayout>
      <taskbar:TaskbarPinList>       
		<taskbar:DesktopApp DesktopApplicationID="308046B0AF4A39CB" />
		<taskbar:DesktopApp DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk" />		
		</taskbar:TaskbarPinList>
      </defaultlayout:TaskbarLayout>
    </CustomTaskbarLayoutCollection>
</LayoutModificationTemplate>
```
