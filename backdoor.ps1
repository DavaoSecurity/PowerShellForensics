# Output File: The script defines an output file where the results will be saved.
# Network Connections: It checks for established TCP connections and logs the associated processes.
# Suspicious Processes: It looks for common suspicious processes that may indicate backdoor activity.
# System File Modifications: It checks critical system files for their last modified timestamps to detect unauthorized changes.
# Scheduled Tasks: It reviews scheduled tasks for any that may execute suspicious commands.
# Run PowerShell as an administrator. Execute the script: .\backdoor.ps1.

# Define output file
$outputFile = "C:/Users/Nathan/Desktop/backdoor.txt"

# Create or clear the output file
Clear-Content -Path $outputFile -ErrorAction SilentlyContinue
Add-Content -Path $outputFile -Value "Backdoor Detection Report - $(Get-Date)"
Add-Content -Path $outputFile -Value "====================================="

# Function to check for unusual network connections
function Check-NetworkConnections {
    Add-Content -Path $outputFile -Value "`nUnusual Network Connections:"
    $connections = Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' }
    foreach ($connection in $connections) {
        $process = Get-Process -Id $connection.OwningProcess -ErrorAction SilentlyContinue
        if ($process) {
            Add-Content -Path $outputFile -Value "Process: $($process.Name), Local Address: $($connection.LocalAddress), Remote Address: $($connection.RemoteAddress), State: $($connection.State)"
        }
    }
}

# Function to check for suspicious processes
function Check-SuspiciousProcesses {
    Add-Content -Path $outputFile -Value "`nSuspicious Processes:"
    $suspiciousProcesses = @("powershell.exe", "cmd.exe", "wscript.exe", "cscript.exe", "java.exe", "python.exe")
    foreach ($proc in $suspiciousProcesses) {
        $runningProcesses = Get-Process -Name $proc -ErrorAction SilentlyContinue
        foreach ($process in $runningProcesses) {
            Add-Content -Path $outputFile -Value "Suspicious Process Found: $($process.Name), ID: $($process.Id), Path: $($process.Path)"
        }
    }
}

# Function to check for modifications to critical system files
function Check-SystemFileModifications {
    Add-Content -Path $outputFile -Value "`nCritical System File Modifications:"
    $criticalFiles = @("C:\Windows\System32\drivers\etc\hosts", "C:\Windows\System32\config\SAM", "C:\Windows\System32\config\SYSTEM")
    foreach ($file in $criticalFiles) {
        if (Test-Path $file) {
            $lastModified = (Get-Item $file).LastWriteTime
            Add-Content -Path $outputFile -Value "File: $file, Last Modified: $lastModified"
        } else {
            Add-Content -Path $outputFile -Value "File: $file does not exist."
        }
    }
}

# Function to check for scheduled tasks that may indicate backdoors
function Check-ScheduledTasks {
    Add-Content -Path $outputFile -Value "`nSuspicious Scheduled Tasks:"
    $tasks = Get-ScheduledTask | Where-Object { $_.State -eq 'Ready' }
    foreach ($task in $tasks) {
        if ($task.Actions -match "powershell.exe" -or $task.Actions -match "cmd.exe") {
            Add-Content -Path $outputFile -Value "Task: $($task.TaskName), Action: $($task.Actions)"
        }
    }
}

# Run checks
Check-NetworkConnections
Check-SuspiciousProcesses
Check-SystemFileModifications
Check-ScheduledTasks

# Final message
Add-Content -Path $outputFile -Value "`nBackdoor detection completed. Review the report for findings."
