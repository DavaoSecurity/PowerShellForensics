# Define the output file
$outputFile = "C:\rootkit_scan_results.txt"

# Function to check for hidden processes
function Get-HiddenProcesses {
    $hiddenProcesses = @()
    $processes = Get-Process -IncludeUserName
    foreach ($process in $processes) {
        if ($process.MainWindowTitle -eq "") {
            $hiddenProcesses += $process
        }
    }
    return $hiddenProcesses
}

# Function to check for hidden services
function Get-HiddenServices {
    $hiddenServices = @()
    $services = Get-Service
    foreach ($service in $services) {
        if ($service.Status -eq 'Stopped' -and $service.DisplayName -eq '') {
            $hiddenServices += $service
        }
    }
    return $hiddenServices
}

# Function to check for suspicious drivers
function Get-SuspiciousDrivers {
    $suspiciousDrivers = @()
    $drivers = Get-WmiObject Win32_SystemDriver
    foreach ($driver in $drivers) {
        if ($driver.State -eq 'Stopped' -and $driver.Name -notlike '*system*') {
            $suspiciousDrivers += $driver
        }
    }
    return $suspiciousDrivers
}

# Collect results
$results = @()
$results += "Rootkit Scan Results - $(Get-Date)"
$results += "-----------------------------------"
$results += "Hidden Processes:"
$hiddenProcesses = Get-HiddenProcesses
if ($hiddenProcesses.Count -eq 0) {
    $results += "None"
} else {
    foreach ($process in $hiddenProcesses) {
        $results += "$($process.Id) - $($process.ProcessName) - $($process.UserName)"
    }
}

$results += "`nHidden Services:"
$hiddenServices = Get-HiddenServices
if ($hiddenServices.Count -eq 0) {
    $results += "None"
} else {
    foreach ($service in $hiddenServices) {
        $results += "$($service.Name) - $($service.DisplayName) - $($service.Status)"
    }
}

$results += "`nSuspicious Drivers:"
$suspiciousDrivers = Get-SuspiciousDrivers
if ($suspiciousDrivers.Count -eq 0) {
    $results += "None"
} else {
    foreach ($driver in $suspiciousDrivers) {
        $results += "$($driver.Name) - $($driver.State) - $($driver.StartType)"
    }
}

# Output results to file
$results | Out-File -FilePath $outputFile -Encoding UTF8

# Display completion message
Write-Host "Rootkit scan completed. Results saved to $outputFile"
