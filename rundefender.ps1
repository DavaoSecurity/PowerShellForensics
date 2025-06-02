# The Start-Sleep -Seconds 300 line is a placeholder to wait for the scan to complete. 
# You may need to adjust the time based on your system's performance and the size of the scan.
# Run as Administrator.
# The output file will be created at C:\DefenderScanResults.txt. You can change the path if needed.

# Define the output file path
$outputFile = "C:\DefenderScanResults.txt"

# Start a full scan with Microsoft Defender
Start-MpScan -ScanType FullScan

# Wait for the scan to complete
Start-Sleep -Seconds 300  # Adjust the sleep time as necessary based on your system

# Get the scan results
$scanResults = Get-MpThreat

# Format the results
$formattedResults = @()
foreach ($result in $scanResults) {
    $formattedResults += "Threat ID: $($result.ThreatID)`n" +
                         "Threat Name: $($result.ThreatName)`n" +
                         "Severity: $($result.Severity)`n" +
                         "Action Taken: $($result.Action)`n" +
                         "Date Detected: $($result.DetectionTime)`n" +
                         "----------------------------------------`n"
}

# Output the results to the text file
$formattedResults | Out-File -FilePath $outputFile -Encoding UTF8

# Notify the user
Write-Host "Scan completed. Results saved to $outputFile"
