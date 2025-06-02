# Run PowerShell as an administrator.
# Script to detect Users and Devices on local network

# Define output file
$outputFile = "C:\NetworkScanReport1.txt"

# Create or clear the output file
Clear-Content -Path $outputFile -ErrorAction SilentlyContinue
Add-Content -Path $outputFile -Value "Local Network Scan Report - $(Get-Date)"
Add-Content -Path $outputFile -Value "====================================="

# Function to get connected devices
function Get-ConnectedDevices {
    Add-Content -Path $outputFile -Value "`nConnected Devices:"
    $devices = Get-NetNeighbor -AddressFamily IPv4 | Where-Object { $_.State -eq 'Reachable' }
    foreach ($device in $devices) {
        Add-Content -Path $outputFile -Value "IP Address: $($device.IPAddress), MAC Address: $($device.LinkLayerAddress), State: $($device.State)"
    }
}

# Function to get local users
function Get-LocalUsers {
    Add-Content -Path $outputFile -Value "`nLocal Users:"
    $users = Get-LocalUser
    foreach ($user in $users) {
        Add-Content -Path $outputFile -Value "Username: $($user.Name), Enabled: $($user.Enabled), Last Logon: $($user.LastLogon)"
    }
}

# Run functions
Get-ConnectedDevices
Get-LocalUsers

# Final message
Add-Content -Path $outputFile -Value "`nNetwork scan completed. Review the report for findings."
