# Windows Investigation Data Collection Script
# This script collects various system artifacts for investigation purposes

# Create output directory with timestamp
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outputPath = "C:\Investigation_$timestamp"
New-Item -ItemType Directory -Path $outputPath -Force

# Function to write section header
function Write-SectionHeader {
    param($sectionName)
    "`n`n==================== $sectionName ====================`n" | Add-Content "$outputPath\investigation.txt"
}

# Start data collection
"Windows Investigation Package - Generated on $(Get-Date)" | Set-Content "$outputPath\investigation.txt"

# System Information
Write-SectionHeader "System Information"
systeminfo | Add-Content "$outputPath\investigation.txt"

# Installed Programs
Write-SectionHeader "Installed Programs"
Get-WmiObject -Class Win32_Product | Select-Object Name, Version, Vendor | Format-Table -AutoSize |
    Out-String -Width 4096 | Add-Content "$outputPath\investigation.txt"

# Running Processes
Write-SectionHeader "Running Processes"
Get-Process | Select-Object Name, Id, Path, Company, CPU, WorkingSet | Format-Table -AutoSize |
    Out-String -Width 4096 | Add-Content "$outputPath\investigation.txt"

# Network Connections
Write-SectionHeader "Network Connections"
netstat -anob | Add-Content "$outputPath\investigation.txt"

# Services
Write-SectionHeader "Services"
Get-Service | Select-Object Name, DisplayName, Status | Format-Table -AutoSize |
    Out-String -Width 4096 | Add-Content "$outputPath\investigation.txt"

# Scheduled Tasks
Write-SectionHeader "Scheduled Tasks"
schtasks /query /v /fo LIST | Add-Content "$outputPath\investigation.txt"

# Security Event Log
Write-SectionHeader "Security Event Log (Last 100 entries)"
Get-EventLog -LogName Security -Newest 100 | Format-List |
    Out-String -Width 4096 | Add-Content "$outputPath\investigation.txt"

# Autoruns (using native Windows tools)
Write-SectionHeader "Autorun Entries"
Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run' |
    Out-String -Width 4096 | Add-Content "$outputPath\investigation.txt"
Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce' |
    Out-String -Width 4096 | Add-Content "$outputPath\investigation.txt"

# Prefetch Files
Write-SectionHeader "Prefetch Files"
Get-ChildItem "C:\Windows\Prefetch" | Select-Object Name, CreationTime, LastWriteTime |
    Format-Table -AutoSize | Out-String -Width 4096 | Add-Content "$outputPath\investigation.txt"

# SMB Sessions
Write-SectionHeader "SMB Sessions"
net session | Add-Content "$outputPath\investigation.txt"

# Users and Groups
Write-SectionHeader "Local Users"
net user | Add-Content "$outputPath\investigation.txt"
Write-SectionHeader "Local Groups"
net localgroup | Add-Content "$outputPath\investigation.txt"

# Temp Directories Content
Write-SectionHeader "Temp Directory Contents"
Get-ChildItem -Path $env:TEMP | Select-Object Name, CreationTime, LastWriteTime |
    Format-Table -AutoSize | Out-String -Width 4096 | Add-Content "$outputPath\investigation.txt"

# WdSupportLogs
Write-SectionHeader "Windows Defender Logs"
if (Test-Path "C:\ProgramData\Microsoft\Windows Defender\Support") {
    Get-ChildItem "C:\ProgramData\Microsoft\Windows Defender\Support" -Recurse |
        Select-Object FullName, CreationTime, LastWriteTime |
        Format-Table -AutoSize | Out-String -Width 4096 | Add-Content "$outputPath\investigation.txt"
}

Write-Host "Investigation data collection complete. Results saved to: $outputPath\investigation.txt"
