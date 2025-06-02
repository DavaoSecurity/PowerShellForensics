# Provides a comprehensive overview of the security status of a Windows 10 Pro machine and outputs the results in a readable text format.
#
# Define the output file path
$outputFile = "C:\SecurityReportDetail.txt"

# Function to get Windows Update information
function Get-WindowsUpdateInfo {
    $updateInfo = Get-WmiObject -Class Win32_QuickFixEngineering | Select-Object HotFixID, InstalledOn
    return $updateInfo
}

# Function to get Antivirus information
function Get-AntivirusInfo {
    $antivirusInfo = Get-WmiObject -Namespace "root\SecurityCenter2" -Class AntiVirusProduct | Select-Object displayName, productState, pathToSignedProductExe
    return $antivirusInfo
}

# Function to get Firewall information
function Get-FirewallInfo {
    $firewallInfo = Get-NetFirewallProfile | Select-Object Name, Enabled
    return $firewallInfo
}

# Function to get User Account Control (UAC) settings
function Get-UACSettings {
    $uacSettings = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System").ConsentPromptBehaviorAdmin
    return $uacSettings
}

# Function to get BitLocker status
function Get-BitLockerStatus {
    $bitLockerStatus = Get-BitLockerVolume | Select-Object MountPoint, VolumeStatus
    return $bitLockerStatus
}

# Function to get Windows Defender status
function Get-WindowsDefenderStatus {
    $windowsDefenderStatus = Get-MpComputerStatus | Select-Object AMServiceEnabled, AntivirusEnabled, AntispywareEnabled
    return $windowsDefenderStatus
}

# Function to get Windows Security Center status
function Get-WindowsSecurityCenterStatus {
    $securityCenterStatus = Get-WmiObject -Namespace "root\SecurityCenter2" -Class SecurityCenter | Select-Object AntiVirusProduct, FirewallProduct, AntiSpywareProduct
    return $securityCenterStatus
}

# Collect all the information
$windowsUpdateInfo = Get-WindowsUpdateInfo
$antivirusInfo = Get-AntivirusInfo
$firewallInfo = Get-FirewallInfo
$uacSettings = Get-UACSettings
$bitLockerStatus = Get-BitLockerStatus
$windowsDefenderStatus = Get-WindowsDefenderStatus
$securityCenterStatus = Get-WindowsSecurityCenterStatus

# Create a formatted text report
$report = @"
Windows 10 Pro Security Report

Windows Update Information:
$($windowsUpdateInfo | Format-Table -AutoSize | Out-String)

Antivirus Information:
$($antivirusInfo | Format-Table -AutoSize | Out-String)

Firewall Information:
$($firewallInfo | Format-Table -AutoSize | Out-String)

User Account Control (UAC) Settings:
$uacSettings

BitLocker Status:
$($bitLockerStatus | Format-Table -AutoSize | Out-String)

Windows Defender Status:
$($windowsDefenderStatus | Format-Table -AutoSize | Out-String)

Windows Security Center Status:
$($securityCenterStatus | Format-Table -AutoSize | Out-String)
"@

# Save the report to a text file
$report | Out-File -FilePath $outputFile

Write-Output "Security report generated and saved to $outputFile"
