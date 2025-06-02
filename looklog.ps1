# Define the output file path
$outputFile = "C:\Logs\SuspiciousEventIDActivityReport.txt"

# Create or clear the output file
Clear-Content -Path $outputFile -ErrorAction SilentlyContinue
Add-Content -Path $outputFile -Value "Suspicious Activity Report - $(Get-Date)"
Add-Content -Path $outputFile -Value "====================================="

# Define suspicious event IDs (you can modify this list based on your needs)
$suspiciousEventIDs = @(4624, 4625, 4648, 4672, 4688, 1102, 5140, 4673, 4768, 4769, 4776)

# Loop through each event ID and retrieve logs
foreach ($eventID in $suspiciousEventIDs) {
    $events = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=$eventID} -ErrorAction SilentlyContinue

    if ($events) {
        Add-Content -Path $outputFile -Value "Event ID: $eventID"
        Add-Content -Path $outputFile -Value "-------------------------------------"

        foreach ($event in $events) {
            $eventTime = $event.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
            $eventMessage = $event.Message
            Add-Content -Path $outputFile -Value "Time: $eventTime"
            Add-Content -Path $outputFile -Value "Message: $eventMessage"
            Add-Content -Path $outputFile -Value "-------------------------------------"
        }
    } else {
        Add-Content -Path $outputFile -Value "No events found for Event ID: $eventID"
        Add-Content -Path $outputFile -Value "-------------------------------------"
    }
}

# Final message
Add-Content -Path $outputFile -Value "Analysis complete. Results saved to $outputFile"

# Common Suspicious Event IDs
# 4624 - Successful Logon: Indicates a successful logon to the system. While not inherently suspicious, it can be when combined with other events.
# 4625 - Failed Logon: Indicates a failed logon attempt. Multiple failed attempts can indicate a brute-force attack.
# 4648 - Logon Attempt Using Explicit Credentials: Indicates that a logon was attempted using explicit credentials, which can be suspicious if it occurs unexpectedly.
# 4672 - Special Privileges Assigned to New Logon: Indicates that a user has logged on with special privileges, which can be a sign of administrative access.
# 4688 - New Process Created: Indicates that a new process has been created. Monitoring this can help identify potentially malicious software.
# 1102 - Audit Log Cleared: Indicates that the audit log was cleared. This is often a sign of an attempt to cover up malicious activity.
# 5140 - Network Share Access: Indicates that a network share was accessed. Unusual access patterns can indicate unauthorized access.
# 5145 - File Share Access: Indicates that a file or folder was accessed over a network share. Monitoring this can help identify unauthorized file access.
# 4673 - Privilege Use: Indicates that a user has exercised a privilege. This can be suspicious if it occurs unexpectedly.
# 4768 - Kerberos Authentication Ticket (TGT) Requested: Indicates that a Kerberos ticket was requested. Unusual requests can indicate potential attacks.
# 4769 - Kerberos Service Ticket Requested: Indicates that a service ticket was requested. Similar to TGT requests, unusual patterns can be suspicious.
# 4776 - The Domain Controller attempted to validate the credentials for an account: Indicates an attempt to validate credentials, which can be suspicious if it occurs frequently.
