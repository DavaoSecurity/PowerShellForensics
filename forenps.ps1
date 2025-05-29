# Define the output file path
$outputFile = "C:\ForensicsReport.txt"

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

# Collect user accounts
Write-Header "User Accounts"
Get-LocalUser | Out-String | Add-Content -Path $outputFile

# Collect installed software
Write-Header "Installed Software"
Get-WmiObject -Class Win32_Product | Select-Object Name, Version | Out-String | Add-Content -Path $outputFile

# Collect network configuration
Write-Header "Network Configuration"
Get-NetIPAddress | Out-String | Add-Content -Path $outputFile

# Collect running processes
Write-Header "Running Processes"
Get-Process | Select-Object Name, Id, CPU | Out-String | Add-Content -Path $outputFile

# Collect event logs (last 10 entries)
Write-Header "Event Logs (Last 10 Entries)"
Get-EventLog -LogName System -Newest 10 | Out-String | Add-Content -Path $outputFile

# Final message
Add-Content -Path $outputFile -Value "Forensics report generated on: $(Get-Date)"
