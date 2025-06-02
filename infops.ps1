# Function to get account information
function Get-AccountInfo {
    $user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    return "Current User: $user"
}

# Function to get RAM information
function Get-RAMInfo {
    $ram = Get-WmiObject -Class Win32_ComputerSystem
    $totalRAM = [math]::round($ram.TotalPhysicalMemory / 1GB, 2)
    $availableRAM = [math]::round($ram.FreePhysicalMemory / 1GB, 2)
    return "Total RAM: $totalRAM GB`nAvailable RAM: $availableRAM GB"
}

# Function to get HDD information
function Get-HDDInfo {
    $disks = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"
    $hddInfo = @()
    foreach ($disk in $disks) {
        $hddInfo += "Device: $($disk.DeviceID)`n  Volume Name: $($disk.VolumeName)`n  File System: $($disk.FileSystem)`n  Total Size: $([math]::round($disk.Size / 1GB, 2)) GB`n  Free Space: $([math]::round($disk.FreeSpace / 1GB, 2)) GB"
    }
    return $hddInfo -join "`n"
}

# Function to get OS information
function Get-OSInfo {
    $os = Get-WmiObject -Class Win32_OperatingSystem
    return "OS Name: $($os.Caption)`nOS Version: $($os.Version)`nOS Build Number: $($os.BuildNumber)"
}

# Function to get gateway information
function Get-GatewayInfo {
    $gateway = Get-NetRoute -NextHop 0.0.0.0 | Select-Object -ExpandProperty NextHop
    return "Default Gateway: $gateway"
}

# Main script
$outputFile = "SystemInfo.txt"
$outputContent = @()

$outputContent += "System Information:"
$outputContent += "Account Information:"
$outputContent += (Get-AccountInfo)
$outputContent += ""
$outputContent += "RAM Information:"
$outputContent += (Get-RAMInfo)
$outputContent += ""
$outputContent += "HDD Information:"
$outputContent += (Get-HDDInfo)
$outputContent += ""
$outputContent += "OS Information:"
$outputContent += (Get-OSInfo)
$outputContent += ""
$outputContent += "Gateway Information:"
$outputContent += (Get-GatewayInfo)

# Write the output to a file
$outputContent -join "`n" | Out-File -FilePath $outputFile -Encoding utf8

Write-Output "System information has been written to $outputFile"
