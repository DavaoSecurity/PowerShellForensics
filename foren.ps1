<#
.SYNOPSIS
    PowerShell Automated Windows Security Logging – Unified Forensic & Security Analysis Suite

.DESCRIPTION
    This script performs three security functions:
      1. Forensic Collection: Gathers system info, local users, processes, network connections, and recent system event logs.
      2. Syslog Analysis: Collects today’s successful login events (Event ID 4624) and outputs a summary.
      3. Security Report: Exports logs from several sources (System, Application, Security, and Sysmon) to CSV files and generates an HTML report.

    The execution level is determined by the numeric parameter:
      - Level 1: Forensic Collection only.
      - Level 2: Forensic Collection and Syslog Analysis.
      - Level 3 (or unspecified): All three functions are executed.

.EXAMPLE
    #Run all features
    .\AutomatedWindowsSecurityLog.ps1

    #Run only forensic collection:
    .\AutomatedWindowsSecurityLog.ps1 -Level 1

    #Run forensic collection and syslog analysis:
    .\AutomatedWindowsSecurityLog.ps1 -Level 2
#>

param(
    [Parameter(Position = 0)]
    [int]$Level = 3
)

#headers
Write-Output "===== Automated Windows Security Logging Suite ====="
Write-Output "Execution Level: $Level"
Write-Output "======================================================`n"

#-----------------------------------------------------------------
#Helper: Ensure a directory exists; if not, create it.
#-----------------------------------------------------------------
function Ensure-DirectoryExists {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -ItemType Directory | Out-Null
    }
}

#-----------------------------------------------------------------
#Function description: Collect basic forensic data and write to files.
#-----------------------------------------------------------------
function Invoke-ForensicCollection {
    $forensicDir = "C:\Forensics"
    Ensure-DirectoryExists -Path $forensicDir

    # Gather and store system info
    Get-ComputerInfo | Out-File -FilePath "$forensicDir\SystemInfo.txt"
    Get-LocalUser    | Out-File -FilePath "$forensicDir\UserInfo.txt"
    Get-Process      | Out-File -FilePath "$forensicDir\Processes.txt"
    Get-NetTCPConnection | Out-File -FilePath "$forensicDir\NetworkConnections.txt"
    Get-EventLog -LogName System -Newest 100 | Out-File -FilePath "$forensicDir\EventLogs.txt"

    Write-Output "Forensic Collection: Data saved to $forensicDir"
}

#-----------------------------------------------------------------
#Function description: Collect today's successful login events (ID 4624) and count them.
#-----------------------------------------------------------------
function Invoke-SyslogAnalysis {
    $logsDir = "C:\SecurityLogs"
    Ensure-DirectoryExists -Path $logsDir

    #today's time window
    $currentDate = Get-Date -Format "yyyyMMdd"
    $startTime   = (Get-Date).Date
    $endTime     = $startTime.AddDays(1).AddSeconds(-1)

    #Filter for successful login events (ID 4624)
    $filterParams = @{
        LogName   = "Security"
        ID        = 4624
        StartTime = $startTime
        EndTime   = $endTime
    }
    $events = Get-WinEvent -FilterHashtable $filterParams

    if ($events) {
        $xmlFile = "$logsDir\$currentDate-SecurityLogs.xml"
        $events | Export-CliXml -Path $xmlFile
        Write-Output "Syslog Analysis: Security logs saved to $xmlFile"
    }
    else {
        Write-Output "Syslog Analysis: No successful login events found for $currentDate."
    }

    #Counting events by reading the XML file(s)
    $xmlFiles = Get-ChildItem -Path $logsDir -Filter "*.xml"
    $totalCount = 0
    foreach ($file in $xmlFiles) {
        [xml]$content = Get-Content -Path $file.FullName
        $count = ($content.Objs.Obj | Where-Object {
                    $_.Props.I32.N -eq "Id" -and $_.Props.I32."#text" -eq "4624"
                 }).Count
        $totalCount += $count
    }
    "Total successful logins today: $totalCount" | Out-File -FilePath "$logsDir\LoginSummary.txt"
    Write-Output "Syslog Analysis: Total successful logins today: $totalCount"
}

#-----------------------------------------------------------------
#Function description: Export various event logs to CSV and create an HTML report.
#-----------------------------------------------------------------
function Invoke-SecurityReportGeneration {
    $logsDir = "C:\SecurityLogs"
    Ensure-DirectoryExists -Path $logsDir

    #Export event logs from various sources to CSV
    $sources = @("System", "Application", "Security")
    foreach ($source in $sources) {
        Get-EventLog -LogName $source -Newest 1000 | Export-Csv -Path "$logsDir\$source.csv" -NoTypeInformation
    }
    #Export Sysmon logs
    try {
        Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 1000 -ErrorAction Stop | Export-Csv -Path "$logsDir\Sysmon.csv" -NoTypeInformation
    }
    catch {
        Write-Output "Sysmon log not found. Skipping Sysmon export."
    }

    # Generate HTML report from CSV files
    $htmlReport = @"
<!DOCTYPE html>
<html>
<head>
    <title>Security Log Analysis Report</title>
</head>
<body>
    <h1>Security Log Analysis Report</h1>
    <table border=`"1`">
        <tr>
            <th>EventID</th>
            <th>Time</th>
            <th>Message</th>
        </tr>
"@

    #Search for key security events in CSV files (IDs: 4625, 4648, 4688, 4689, 4768)
    $targetIDs = @(4625, 4648, 4688, 4689, 4768)
    $csvFiles = Get-ChildItem -Path $logsDir -Filter *.csv
    foreach ($csv in $csvFiles) {
        $rows = Import-Csv -Path $csv.FullName
        foreach ($row in $rows) {
            if ($targetIDs -contains [int]$row.EventID) {
                $htmlReport += "<tr><td>$($row.EventID)</td><td>$($row.TimeGenerated)</td><td>$($row.Message)</td></tr>`n"
            }
        }
    }

    $htmlReport += @"
    </table>
</body>
</html>
"@

    $reportFile = "$logsDir\AnalysisReport.html"
    $htmlReport | Out-File -FilePath $reportFile
    Write-Output "Security Report: HTML report generated at $reportFile"
}

#-----------------------------------------------------------------
#Script argument / main Execution Logic using switch-case based on $Level
#-----------------------------------------------------------------
switch ($Level) {
    1 {
        Invoke-ForensicCollection
        break
    }
    2 {
        Invoke-ForensicCollection
        Invoke-SyslogAnalysis
        break
    }
    default {
        Invoke-ForensicCollection
        Invoke-SyslogAnalysis
        Invoke-SecurityReportGeneration
    }
}

Write-Output "`nAll selected tasks have been executed. Check the output folders for results."
