# router check
# Update the $routerIP variable with your router's IP address and adjust the ports in the $portsToCheck array as needed.
# Output File Path: Change the path in $outputFile to where you want to save the output.
# run as Administrator

# Define the output file
$outputFile = "C:\Path\To\Your\Output\RouterFirewallScan.txt"

# Function to check router configuration
function Check-RouterConfiguration {
    # Example: Check if the router is reachable
    $routerIP = "192.168.1.1"  # Replace with your router's IP address
    $pingResult = Test-Connection -ComputerName $routerIP -Count 2 -ErrorAction SilentlyContinue

    if ($pingResult) {
        "Router is reachable." | Out-File -FilePath $outputFile -Append
    } else {
        "Router is not reachable." | Out-File -FilePath $outputFile -Append
    }

    # Example: Check for open ports (replace with actual port numbers)
    $portsToCheck = @(22, 80, 443)
    foreach ($port in $portsToCheck) {
        $tcpTest = Test-NetConnection -ComputerName $routerIP -Port $port
        if ($tcpTest.TcpTestSucceeded) {
            "Port $port is open." | Out-File -FilePath $outputFile -Append
        } else {
            "Port $port is closed." | Out-File -FilePath $outputFile -Append
        }
    }
}

# Function to check firewall configuration
function Check-FirewallConfiguration {
    # Check if the Windows Firewall is enabled
    $firewallStatus = Get-NetFirewallProfile | Select-Object -Property Name, Enabled
    foreach ($profile in $firewallStatus) {
        if ($profile.Enabled) {
            "Firewall profile $($profile.Name) is enabled." | Out-File -FilePath $outputFile -Append
        } else {
            "Firewall profile $($profile.Name) is disabled." | Out-File -FilePath $outputFile -Append
        }
    }

    # Check for specific firewall rules (example)
    $rules = Get-NetFirewallRule | Where-Object { $_.Enabled -eq 'True' }
    if ($rules) {
        "Enabled firewall rules:" | Out-File -FilePath $outputFile -Append
        $rules | ForEach-Object { $_.DisplayName } | Out-File -FilePath $outputFile -Append
    } else {
        "No enabled firewall rules found." | Out-File -FilePath $outputFile -Append
    }
}

# Clear the output file before starting
Clear-Content -Path $outputFile

# Run the checks
Check-RouterConfiguration
Check-FirewallConfiguration

# Indicate completion
"Scan completed. Results saved to $outputFile" | Out-File -FilePath $outputFile -Append
