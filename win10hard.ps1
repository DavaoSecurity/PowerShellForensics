# Windows 10 Pro Hardening Script
# BitLocker Password: Replace "YourSecurePassword" with a strong password of your choice. Ensure you have a recovery key saved securely
# Ensure you have a recovery key saved securely.
# Run as Administrator

# Enable Windows Defender
Set-MpPreference -DisableRealtimeMonitoring $false
Set-MpPreference -DisableIOAVProtection $false
Set-MpPreference -DisableScriptScanning $false
Set-MpPreference -DisablePrivacyMode $false

# Enable Windows Firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

# Configure User Account Control (UAC)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 2
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Value 1

# Disable SMBv1
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force

# Enable BitLocker (assuming the system drive is C:)
Enable-BitLocker -MountPoint "C:" -EncryptionMethod Aes256 -UsedSpaceOnly -Password (ConvertTo-SecureString "YourSecurePassword" -AsPlainText -Force)

# Configure Windows Update settings
Set-Service -Name wuauserv -StartupType Automatic
Start-Service -Name wuauserv

# Disable guest account
Disable-LocalUser -Name "Guest"

# Set password policy
$PasswordPolicy = @{
    "MaximumPasswordAge" = 30
    "MinimumPasswordAge" = 1
    "MinimumPasswordLength" = 12
    "PasswordComplexity" = 1
    "LockoutBadCount" = 5
    "ResetLockoutCount" = 15
    "LockoutDuration" = 30
}

foreach ($key in $PasswordPolicy.Keys) {
    Set-LocalGroupPolicy -Name "Password Policy" -Key $key -Value $PasswordPolicy[$key]
}

# Disable unnecessary services (example: Print Spooler)
Stop-Service -Name "Spooler" -Force
Set-Service -Name "Spooler" -StartupType Disabled

# Enable auditing
auditpol /set /category:"Logon/Logoff" /success:enable /failure:enable
auditpol /set /category:"Account Logon" /success:enable /failure:enable
auditpol /set /category:"Privilege Use" /success:enable /failure:enable

# Inform the user
Write-Host "Windows 10 Pro hardening script executed successfully."
