#add partage
#New-PSDrive -Name "S" -Root "\\192.168.1.3\partage" -Persist -PSProvider "FileSystem" -Scope "global"

#setup autoshutdown 18h
$action = New-ScheduledTaskAction -Execute "shutdown.exe" -Argument "/s /t 1"
$trigger = New-ScheduledTaskTrigger -Daily -At 18:00
$settings = New-ScheduledTaskSettingsSet -RunOnlyIfIdle -IdleDuration 00:05:00 -IdleWaitTimeout 00:15:00 -WakeToRun
Register-ScheduledTask autoshutdown -Action $action -Settings $settings -Trigger $trigger

#setup ansible
# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start the sshd service
Start-Service sshd

# OPTIONAL but recommended:
Set-Service -Name sshd -StartupType 'Automatic'

# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}

