# Gather win 10 and 11 configuration errors
# Run as Administrator

# Define the output file path
$outputFile = "C:\ConfigErrorsReport.txt"

# Function to check Windows Update errors
function Check-WindowsUpdateErrors {
    Write-Host "Checking Windows Update errors..."
    $updateErrors = Get-WindowsUpdateLog | Select-String -Pattern "Error"
    return $updateErrors
}

# Function to check system file integrity
function Check-SystemFileIntegrity {
    Write-Host "Checking system file integrity..."
    $sfcResult = sfc /scannow
    return $sfcResult
}

# Function to check service status
function Check-ServiceStatus {
    Write-Host "Checking service status..."
    $services = Get-Service | Where-Object { $_.Status -ne 'Running' }
    return $services
}

# Gather configuration errors
$report = @()
$report += "Configuration Errors Report - $(Get-Date)"
$report += "----------------------------------------`n"

# Check Windows Update errors
$updateErrors = Check-WindowsUpdateErrors
if ($updateErrors) {
    $report += "Windows Update Errors:`n"
    $report += $updateErrors
} else {
    $report += "No Windows Update errors found.`n"
}

# Check system file integrity
$sfcResult = Check-SystemFileIntegrity
$report += "System File Integrity Check:`n"
$report += $sfcResult
$report += "`n"

# Check service status
$serviceStatus = Check-ServiceStatus
if ($serviceStatus) {
    $report += "Services Not Running:`n"
    foreach ($service in $serviceStatus) {
        $report += "$($service.Name) - $($service.Status)`n"
    }
} else {
    $report += "All services are running.`n"
}

# Output the report to a text file
$report | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "Configuration errors report generated at: $outputFile"
