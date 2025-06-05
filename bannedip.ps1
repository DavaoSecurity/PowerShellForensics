# block out/in known malicious IPs at the firewall.

# Function to ban a list of IP addresses
function Ban-IpAddresses {
    # Path to the file containing the list of banned IP addresses
    $ipListFile = "C:\bannedip.txt"

    # Check if the file exists
    if (-Not (Test-Path -Path $ipListFile)) {
        Write-Error "The file $ipListFile does not exist."
        return
    }

    # Read the list of IP addresses from the file
    $ipAddresses = Get-Content -Path $ipListFile

    # Iterate through each IP address and create a firewall rule to block it
    foreach ($ipAddress in $ipAddresses) {
        # Create a unique display name for the firewall rule
        $ruleName = "Block IP $ipAddress"

        # Check if the rule already exists
        if (Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue) {
            Write-Output "Rule for IP $ipAddress already exists. Skipping."
        } else {
            # Create a new firewall rule to block the IP address
            New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Action Block -RemoteAddress $ipAddress
            New-NetFirewallRule -DisplayName $ruleName -Direction Outbound -Action Block -RemoteAddress $ipAddress
            Write-Output "Blocked IP address: $ipAddress"
        }
    }
}

# Call the function to ban the IP addresses
Ban-IpAddresses
