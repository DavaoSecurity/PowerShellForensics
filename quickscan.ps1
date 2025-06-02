# run as Administrator

# Define the output file path
$outputFile = "C:\SystemInfoReport.txt"

# Function to get logged on users
function Get-LoggedOnUsers {
    Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName
}

# Function to get all users
function Get-AllUsers {
    Get-WmiObject -Class Win32_UserProfile | Where-Object { $_.Special -eq $false } | Select-Object -ExpandProperty LocalPath
}

# Function to get open applications
function Get-OpenApps {
    Get-Process | Where-Object { $_.MainWindowTitle -ne "" } | Select-Object -Property Name, Id, MainWindowTitle
}

# Function to get processes
function Get-Processes {
    Get-Process | Select-Object -Property Name, Id, CPU, WS
}

# Function to get RAM usage
function Get-RAMUsage {
    $mem = Get-WmiObject -Class Win32_OperatingSystem
    $totalRAM = [math]::round($mem.TotalVisibleMemorySize / 1MB, 2)
    $usedRAM = [math]::round(($mem.TotalVisibleMemorySize - $mem.FreePhysicalMemory) / 1MB, 2)
    return @{ TotalRAM = $totalRAM; UsedRAM = $usedRAM }
}

# Function to get hard disk space
function Get-HardDiskSpace {
    Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, @{Name='TotalSpace(GB)';Expression={[math]::round($_.Size / 1GB, 2)}}, @{Name='UsedSpace(GB)';Expression={[math]::round(($_.Size - $_.FreeSpace) / 1GB, 2)}}
}

# Function to get open ports
function Get-OpenPorts {
    Get-NetTCPConnection | Select-Object -Property LocalAddress, LocalPort, State
}

# Collecting information
$loggedOnUsers = Get-LoggedOnUsers
$allUsers = Get-AllUsers
$openApps = Get-OpenApps
$processes = Get-Processes
$ramUsage = Get-RAMUsage
$hardDiskSpace = Get-HardDiskSpace
$openPorts = Get-OpenPorts

# Formatting output
$output = @"
Logged On Users:
$loggedOnUsers

All Users:
$allUsers

Open Applications:
$($openApps | Format-Table -AutoSize | Out-String)

Processes:
$($processes | Format-Table -AutoSize | Out-String)

RAM Usage:
Total RAM: $($ramUsage.TotalRAM) MB
Used RAM: $($ramUsage.UsedRAM) MB

Hard Disk Space:
$($hardDiskSpace | Format-Table -AutoSize | Out-String)

Open Ports:
$($openPorts | Format-Table -AutoSize | Out-String)
"@

# Save to file
$output | Out-File -FilePath $outputFile -Encoding utf8

# Output to console
Write-Host "System information has been saved to $outputFile"
