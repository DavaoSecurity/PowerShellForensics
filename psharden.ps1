# https://www.linkedin.com/pulse/powershell-script-windows-10-11-os-hardening-pxobf
# These PowerShell scripts help in hardening Windows 10 and Windows 11 systems by disabling unnecessary services, 
# configuring security settings, enforcing policies, and ensuring that the system is protected and up-to-date. 
# Regular use and updates of these scripts can significantly enhance the security posture of your Windows desktops.

# Disable unnecessary services
$servicesToDisable = @(
    "wsearch", # Windows Search
    "XblGameSave", # Xbox Live Game Save
    "SkypeUpdate" # Skype Update
)

foreach ($service in $servicesToDisable) {
    Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
    Set-Service -Name $service -StartupType Disabled
}   

# Enable Windows Defender
Set-MpPreference -DisableRealtimeMonitoring $false
Set-MpPreference -DisableBehaviorMonitoring $false
Set-MpPreference -DisableIOAVProtection $false
Set-MpPreference -DisablePrivacyMode $false

# Ensure the latest definitions are installed
Update-MpSignature     

# Configure password policies
secedit /export /cfg C:\Windows\Temp\secpol.cfg
(Get-Content C:\Windows\Temp\secpol.cfg) -replace 'PasswordComplexity = 0', 'PasswordComplexity = 1' | Set-Content C:\Windows\Temp\secpol.cfg
(Get-Content C:\Windows\Temp\secpol.cfg) -replace 'MinimumPasswordLength = 0', 'MinimumPasswordLength = 8' | Set-Content C:\Windows\Temp\secpol.cfg
secedit /configure /db secedit.sdb /cfg C:\Windows\Temp\secpol.cfg /areas SECURITYPOLICY        

# Enable BitLocker on C: drive
Enable-BitLocker -MountPoint "C:" -EncryptionMethod Aes256 -UsedSpaceOnlyEncryption -RecoveryPasswordProtector        

# Enable and configure Windows Firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

# Allow essential apps through the firewall
New-NetFirewallRule -DisplayName "Allow Remote Desktop" -Enabled True -Direction Inbound -Protocol TCP -LocalPort 3389 -Action Allow        

# Configure audit policies
Auditpol /set /subcategory:"Logon" /success:enable /failure:enable
Auditpol /set /subcategory:"Account Logon" /success:enable /failure:enable
Auditpol /set /subcategory:"Account Management" /success:enable /failure:enable
Auditpol /set /subcategory:"Policy Change" /success:enable /failure:enable
Auditpol /set /subcategory:"System Events" /success:enable /failure:enable        

# Configure Windows Update settings
Set-Service -Name wuauserv -StartupType Automatic
Start-Service -Name wuauserv 

# Uninstall unwanted apps
Get-AppxPackage -Name "*bing*" | Remove-AppxPackage
Get-AppxPackage -Name "*Xbox*" | Remove-AppxPackage   