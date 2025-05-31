# search for possible backdoors
# run as Administrator

# Define the output file path
$outputFile = "C:/Users/Nathan/Desktop/bkdoor.txt"

# Function to write header to the report
function Write-Header {
    param (
        [string]$header
    )
    Add-Content -Path $outputFile -Value ("=" * 50)
    Add-Content -Path $outputFile -Value $header
    Add-Content -Path $outputFile -Value ("=" * 50)
}

# Clear the output file if it exists
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}

# Collect system information
Write-Header "System Information"
Get-ComputerInfo | Out-String | Add-Content -Path $outputFile

# Check for unusual processes
Write-Header "Unusual Processes"
$unusualProcesses = Get-Process | Where-Object { $_.Path -and $_.Path -notlike "*Windows*" }
$unusualProcesses | Out-String | Add-Content -Path $outputFile

# Check for suspicious services
Write-Header "Suspicious Services"
$suspiciousServices = Get-Service | Where-Object { $_.Status -eq 'Running' -and $_.DisplayName -notlike "*Windows*" }
$suspiciousServices | Out-String | Add-Content -Path $outputFile

# Check for scheduled tasks
Write-Header "Scheduled Tasks"
$scheduledTasks = Get-ScheduledTask | Where-Object { $_.State -eq 'Ready' -and $_.Actions -ne $null }
$scheduledTasks | Out-String | Add-Content -Path $outputFile

# Check for unusual network connections
Write-Header "Unusual Network Connections"
$networkConnections = Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' -and $_.RemoteAddress -notlike "127.0.0.1" }
$networkConnections | Out-String | Add-Content -Path $outputFile

# Check for unusual startup items
Write-Header "Unusual Startup Items"
$startupItems = Get-CimInstance -ClassName Win32_StartupCommand | Where-Object { $_.Location -notlike "*Windows*" }
$startupItems | Out-String | Add-Content -Path $outputFile

# Final message
Add-Content -Path $outputFile -Value "Backdoor scan report generated on: $(Get-Date)"
