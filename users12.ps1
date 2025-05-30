# This script uses the Get-WinEvent cmdlet to retrieve event logs for logons (event ID 4624) in the past 12 months. 
# It then extracts the user names from the event logs, gets the unique user names, and 
# outputs the results to a file named LoggedOnUsers.txt in the Downloads directory.
# Requires administrative privileges to run, and it may take some time to execute 
# Also, the script assumes that the event logs are not cleared or modified, and the logon events are recorded in the Security log.

# Define the path to the output file
$outputFile = "$env:USERPROFILE\Downloads\LoggedOnUsers.txt"

# Get the date 12 months ago
$12MonthsAgo = (Get-Date).AddMonths(-12)

# Get the event logs for logons in the past 12 months
$logs = Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    ID = 4624
    StartTime = $12MonthsAgo
} -ErrorAction SilentlyContinue

# Extract the user names from the event logs
$users = $logs | Select-Object -ExpandProperty Properties | Where-Object {$_.Id -eq 2} | Select-Object -ExpandProperty Value

# Get unique user names
$uniqueUsers = $users | Select-Object -Unique

# Output the results to a file
"Users who have logged on in the past 12 months:" | Out-File -FilePath $outputFile
$uniqueUsers | Out-File -FilePath $outputFile -Append

# Open the output file
Invoke-Item $outputFile

