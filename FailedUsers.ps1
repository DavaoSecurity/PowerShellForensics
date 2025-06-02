# Acomprehensive overview of user logon activity over the past six months, including both successful and failed attempts.

# Define the output file path
$outputFile = "C:\LogonAnalysis.txt"

# Define the time range (last 6 months)
$startDate = (Get-Date).AddMonths(-6)

# Get successful logon events (Event ID 4624)
$successfulLogons = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4624; StartTime=$startDate} | 
    Select-Object TimeCreated, @{Name='User'; Expression={($_.Properties[5].Value)}}, @{Name='Action'; Expression={($_.Properties[8].Value)}}

# Get failed logon events (Event ID 4625)
$failedLogons = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625; StartTime=$startDate} | 
    Select-Object TimeCreated, @{Name='User'; Expression={($_.Properties[5].Value)}}, @{Name='FailureReason'; Expression={($_.Properties[11].Value)}}

# Prepare the output
$output = @()

# Add successful logons to output
$output += "Successful Logons:`n"
$output += "TimeCreated`tUser`tAction`n"
$output += "--------------------------------------------------`n"
foreach ($logon in $successfulLogons) {
    $output += "{0}`t{1}`t{2}`n" -f $logon.TimeCreated, $logon.User, $logon.Action
}

# Add failed logons to output
$output += "`nFailed Logons:`n"
$output += "TimeCreated`tUser`tFailureReason`n"
$output += "--------------------------------------------------`n"
foreach ($logon in $failedLogons) {
    $output += "{0}`t{1}`t{2}`n" -f $logon.TimeCreated, $logon.User, $logon.FailureReason
}

# Write the output to the file
$output | Out-File -FilePath $outputFile -Encoding UTF8

# Inform the user
Write-Host "Logon analysis complete. Results saved to $outputFile"
