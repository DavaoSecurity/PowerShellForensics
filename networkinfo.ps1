# This script uses the Get-NetAdapter, Get-NetIPConfiguration, and Get-NetTCPConnection cmdlets to retrieve information about the network
# adapters, gateway, and connected devices. The output is then written to a text file in the local Downloads folder.
# Run with administrative privileges, otherwise some information may not be available due to permissions or other restrictions.
# .\networkinfo.ps1 
# The output will be written to a file named NetworkInfo.txt in the local Downloads folder.

# Define the path to the output file
$outputPath = "$env:USERPROFILE\Downloads\NetworkInfo.txt"

# Get network adapter configuration
$networkAdapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }

# Get gateway information
$gateway = Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null }

# Get connected devices
$connectedDevices = Get-NetTCPConnection | Where-Object { $_.State -eq "Established" }

# Create the output file
"Network Information:" | Out-File -FilePath $outputPath

# Write network adapter information to the output file
"Network Adapters:" | Out-File -FilePath $outputPath -Append
$networkAdapters | ForEach-Object {
    "Name: $($_.Name)" | Out-File -FilePath $outputPath -Append
    "Description: $($_.Description)" | Out-File -FilePath $outputPath -Append
    "Status: $($_.Status)" | Out-File -FilePath $outputPath -Append
    "MAC Address: $($_.MacAddress)" | Out-File -FilePath $outputPath -Append
    "IPv4 Address: $($_.IPv4Address)" | Out-File -FilePath $outputPath -Append
    "IPv6 Address: $($_.IPv6Address)" | Out-File -FilePath $outputPath -Append
    "" | Out-File -FilePath $outputPath -Append
}

# Write gateway information to the output file
"Gateway Information:" | Out-File -FilePath $outputPath -Append
$gateway | ForEach-Object {
    "IPv4 Address: $($_.IPv4DefaultGateway.NextHop)" | Out-File -FilePath $outputPath -Append
    "IPv6 Address: $($_.IPv6DefaultGateway.NextHop)" | Out-File -FilePath $outputPath -Append
    "" | Out-File -FilePath $outputPath -Append
}

# Write connected devices information to the output file
"Connected Devices:" | Out-File -FilePath $outputPath -Append
$connectedDevices | ForEach-Object {
    "Local Address: $($_.LocalAddress)" | Out-File -FilePath $outputPath -Append
    "Local Port: $($_.LocalPort)" | Out-File -FilePath $outputPath -Append
    "Remote Address: $($_.RemoteAddress)" | Out-File -FilePath $outputPath -Append
    "Remote Port: $($_.RemotePort)" | Out-File -FilePath $outputPath -Append
    "State: $($_.State)" | Out-File -FilePath $outputPath -Append
    "" | Out-File -FilePath $outputPath -Append
}

# Write a message to indicate the end of the output
"End of Network Information." | Out-File -FilePath $outputPath -Append
