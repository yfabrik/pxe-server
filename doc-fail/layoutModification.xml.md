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
permet d'enlever les tuiles du menu démarrer, et apparement empeche l'installation des applications sponso(disney, spotify ....) parce que c'est parce que les tuiles demande l'app que windows l'install
et remplace les app de la barre des tache par firefox et file explorer