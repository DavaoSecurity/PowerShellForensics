# Define the output file path
$outputFile = "C:\RootkitScanReport.txt"

# Function to get suspicious processes
function Get-SuspiciousProcesses {
    $suspiciousProcesses = @()
    $processes = Get-Process | Where-Object { $_.Name -notin @("System", "Idle", "explorer", "powershell", "services") }

    foreach ($process in $processes) {
        $hash = Get-FileHash -Path $process.Path -Algorithm SHA256 -ErrorAction SilentlyContinue
        if ($hash) {
            $suspiciousProcesses += [PSCustomObject]@{
                Name = $process.Name
                Id = $process.Id
                Path = $process.Path
                Hash = $hash.Hash
            }
        }
    }
    return $suspiciousProcesses
}

# Function to get suspicious services
function Get-SuspiciousServices {
    $suspiciousServices = @()
    $services = Get-Service | Where-Object { $_.Status -eq 'Running' -and $_.Name -notlike 'wuauserv' }

    foreach ($service in $services) {
        $suspiciousServices += [PSCustomObject]@{
            Name = $service.Name
            DisplayName = $service.DisplayName
            Status = $service.Status
        }
    }
    return $suspiciousServices
}

# Collecting information
$suspiciousProcesses = Get-SuspiciousProcesses
$suspiciousServices = Get-SuspiciousServices

# Formatting output
$output = @"
Rootkit Scan Report
====================

Suspicious Processes:
$($suspiciousProcesses | Format-Table -AutoSize | Out-String)

Suspicious Services:
$($suspiciousServices | Format-Table -AutoSize | Out-String)

"@

# Save to file
$output | Out-File -FilePath $outputFile -Encoding utf8

# Output to console
Write-Host "Rootkit scan results have been saved to $outputFile"
