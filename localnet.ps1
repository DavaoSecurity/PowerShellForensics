# Define the output file path
$outputFile = "C:\NetworkScanResults.txt"

# Clear the output file if it exists
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}

# Add header to the output file
"IP Address`tHost Name`tMAC Address" | Out-File -FilePath $outputFile -Encoding utf8

# Get the local IP address and subnet mask
$localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.PrefixOrigin -eq "Dhcp" }).IPAddress
$subnetMask = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.PrefixOrigin -eq "Dhcp" }).PrefixLength
$subnet = [System.Net.IPNetwork]::Parse("$localIP/$subnetMask")

# Scan the local network
1..254 | ForEach-Object {
    $ip = "$($subnet.NetworkAddress.ToString().Split('.')[0..2] -join '.').$_"
    try {
        $ping = Test-Connection -ComputerName $ip -Count 1 -ErrorAction Stop
        $hostEntry = [System.Net.Dns]::GetHostEntry($ip) # -ErrorAction SilentlyContinue
        $macAddress = (Get-ArpTable | Where-Object { $_.IPAddress -eq $ip }).PhysicalAddress # -ErrorAction SilentlyContinue

        # Format the output
        $hostName = if ($hostEntry) { $hostEntry.HostName } else { "N/A" }
        $macAddressFormatted = if ($macAddress) { $macAddress } else { "N/A" }

        # Write to the output file
        "$ip`t$hostName`t$macAddressFormatted" | Out-File -FilePath $outputFile -Append -Encoding utf8
    } catch {
        # Ignore unreachable hosts
    }
}

# Notify user of completion
Write-Host "Network scan completed. Results saved to $outputFile"
