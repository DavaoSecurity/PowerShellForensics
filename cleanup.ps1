# Removes temporary files from the Windows Temp directory
# Removes system files from the Catroot2 and Logfiles directories
# Removes Windows update files from the SoftwareDistribution directory
# Removes Windows Defender files from the Windows Defender directory
# Removes user temporary files from the AppData\Local\Temp and Temporary Internet Files directories
# Runs the disk cleanup tool to remove unnecessary files
# Runs disk defragmentation on the C drive
# Requires administrative privileges to run and run it in PowerShell by typing .\cleanup.ps1.

# Define the script
$cleanupScript = {
  # Remove temporary files
  Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue

  # Remove system files
  Remove-Item -Path "C:\Windows\System32\catroot2\*" -Force -Recurse -ErrorAction SilentlyContinue
  Remove-Item -Path "C:\Windows\System32\logfiles\*" -Force -Recurse -ErrorAction SilentlyContinue

  # Remove Windows update files
  Stop-Service -Name wuauserv -Force
  Remove-Item -Path "C:\Windows\SoftwareDistribution\*" -Force -Recurse -ErrorAction SilentlyContinue
  Start-Service -Name wuauserv

  # Remove Windows Defender files
  Stop-Service -Name WinDefend -Force
  Remove-Item -Path "C:\ProgramData\Microsoft\Windows Defender\*" -Force -Recurse -ErrorAction SilentlyContinue
  Start-Service -Name WinDefend

  # Remove user temporary files
  $users = Get-ChildItem -Path "C:\Users"
  foreach ($user in $users) {
    Remove-Item -Path "C:\Users\$($user.Name)\AppData\Local\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Users\$($user.Name)\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" -Force -Recurse -ErrorAction SilentlyContinue
  }

  # Run disk cleanup
  Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait

  # Run disk defragmentation
  Optimize-Volume -DriveLetter C -Defrag -ErrorAction SilentlyContinue
}

# Run the script
& $cleanupScript
