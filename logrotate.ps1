# To schedule this script to run automatically every day, follow these steps:
# Open the Task Scheduler: You can do this by searching for "Task Scheduler" in the Start menu.
# Create a new task: Click on "Create Basic Task" in the right-hand Actions panel.
# Give the task a name and description: Enter a name and description for the task, such as "Log Rotation Task".
# Set the trigger: Click on the "Triggers" tab and then click on "New". Select "Daily" and set the start time to the time you want the task to run.
# Set the action: Click on the "Actions" tab and then click on "New". Select "Start a program" and enter the path to PowerShell (usually # "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"). In the "Add arguments" field, enter the path to your script, preceded by "-File".
# Save the task: Click "OK" to save the task.
# This will ensure that your log rotation script runs automatically every day, deleting logs older than 3 months and rotating the logs every 3 months.
# Run as Administrator

# Set the log file path and the maximum age of the logs
$logFilePath = "C:\Windows\System32\winevt\Logs"
$maxAge = 90 # days

# Set the log rotation period
$logRotationPeriod = 90 # days

# Get the current date
$currentTime = Get-Date

# Get the log files
$logFiles = Get-ChildItem -Path $logFilePath -Filter *.log

# Delete logs older than 3 months
$logFiles | Where-Object {$_.LastWriteTime -lt $currentTime.AddDays(-$maxAge)} | Remove-Item -Force -ErrorAction SilentlyContinue

# Rotate the logs every 3 months
$logFiles | Where-Object {$_.LastWriteTime -lt $currentTime.AddDays(-$logRotationPeriod)} | ForEach-Object {
    $newFileName = $_.BaseName + "_" + $currentTime.ToString("yyyyMMdd") + $_.Extension
    Rename-Item -Path $_.FullName -NewName $newFileName -ErrorAction SilentlyContinue
}

# Log the results
$logResult = "Log files older than 3 months have been deleted and logs have been rotated."
$logResult | Out-File -FilePath "C:\log_rotation.log" -Append
