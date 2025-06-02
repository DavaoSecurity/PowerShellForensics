# Users, devices on network past 48 hours
# run as Administrator

# Define output file
$outputFile = "C:\NetworkDevicesAndUsers.txt"

# Function to get connected devices on the local network
function Get-ConnectedDevices {
    $devices = Get-NetNeighbor -AddressFamily IPv4 | Select-Object -Property IPAddress, LinkLayerAddress, State
    return $devices
}

# Function to get logged-on users
function Get-LoggedOnUsers {
    $loggedOnUsers = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName
    return $loggedOnUsers
}

# Function to get user activity in the past 48 hours
function Get-UserActivity {
    $activity = @()
    $timeLimit = (Get-Date).AddHours(-48)

    # Get all event logs related to user logon
    $events = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4624; StartTime=$timeLimit} |
              Select-Object TimeCreated, @{Name='User'; Expression={$_.Properties[5].Value}}, @{Name='EventType'; Expression={$_.Id}}

    foreach ($event in $events) {
        $activity += [PSCustomObject]@{
            Time = $event.TimeCreated
            User = $event.User
            EventType = $event.EventType
        }
    }
    return $activity
}

# Collect data
$connectedDevices = Get-ConnectedDevices
$loggedOnUsers = Get-LoggedOnUsers
$userActivity = Get-UserActivity

# Prepare output
$output = @()
$output += "Connected Devices:`n"
$output += $connectedDevices | Format-Table -AutoSize | Out-String
$output += "`nLogged On Users:`n"
$output += $loggedOnUsers | Out-String
$output += "`nUser Activity in the Last 48 Hours:`n"
$output += $userActivity | Format-Table -AutoSize | Out-String

# Write to output file
$output | Out-File -FilePath $outputFile -Encoding utf8

# Display completion message
Write-Host "Data has been collected and written to $outputFile"
