# run as Administrator

# Define the output file path
$outputFile = "C:\SuspiciousProcessesReport.txt"

# Define a list of known suspicious process names
$suspiciousProcesses = @(
"svchost.exe",
    "explorer.exe",
    "cmd.exe",
    "powershell.exe",
    "wscript.exe",
    "cscript.exe",
    "rundll32.exe",
    "taskeng.exe",
    "mshta.exe",
    "conhost.exe",
    "services.exe",
    "lsass.exe",
    "winlogon.exe",
    "spoolsv.exe",
    "dwm.exe",
    "csrss.exe",
    "smss.exe",
    "wininit.exe",
    "System",
    "Registry"
    "svchost.exe" # Note: svchost.exe is a legitimate process, but can be abused
)

# Get the current date and time for the report header
$currentDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Start the report
"Suspicious and Malicious Processes Report" | Out-File -FilePath $outputFile -Encoding utf8
"Generated on: $currentDate" | Out-File -FilePath $outputFile -Append -Encoding utf8
"--------------------------------------------------" | Out-File -FilePath $outputFile -Append -Encoding utf8

# Get all running processes
$processes = Get-Process

# Check for suspicious processes
foreach ($process in $processes) {
    if ($suspiciousProcesses -contains $process.ProcessName) {
        $processInfo = "Process Name: $($process.ProcessName), ID: $($process.Id), Path: $($process.Path)"
        $processInfo | Out-File -FilePath $outputFile -Append -Encoding utf8
    }
}

# Check for processes with unusual CPU or memory usage
$thresholdCpu = 80 # CPU usage threshold
$thresholdMemory = 100MB # Memory usage threshold

foreach ($process in $processes) {
    if ($process.CPU -gt $thresholdCpu -or $process.WorkingSet -gt $thresholdMemory) {
        $processInfo = "High Resource Usage - Process Name: $($process.ProcessName), ID: $($process.Id), CPU: $($process.CPU), Memory: $([math]::round($process.WorkingSet / 1MB, 2)) MB"
        $processInfo | Out-File -FilePath $outputFile -Append -Encoding utf8
    }
}

# Final message
"Report generation completed." | Out-File -FilePath $outputFile -Append -Encoding utf8
