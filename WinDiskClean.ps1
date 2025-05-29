# Clean temporary files
$TempDir = [System.IO.Path]::GetTempPath()
Get-ChildItem -Path $TempDir -Recurse | Remove-Item -Force -Recurse

# Clean the Recycle Bin
Clear-RecycleBin -Force

# Clean the Windows Temp folder
$WinTempDir = "$env:WINDIR\Temp"
Get-ChildItem -Path $WinTempDir -Recurse | Remove-Item -Force -Recurse

# Clean the user's Temp folder
$UserTempDir = "$env:TEMP"
Get-ChildItem -Path $UserTempDir -Recurse | Remove-Item -Force -Recurse

# Clean the user's Downloads folder
$DownloadsDir = [Environment]::GetFolderPath("Downloads")
Get-ChildItem -Path $DownloadsDir -Recurse | Remove-Item -Force -Recurse

# Clean the user's Internet Explorer cache
$IECacheDir = "$env:LOCALAPPDATA\Microsoft\Windows\INetCache"
Get-ChildItem -Path $IECacheDir -Recurse | Remove-Item -Force -Recurse

# Clean the user's Microsoft Edge cache
$EdgeCacheDir = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"
Get-ChildItem -Path $EdgeCacheDir -Recurse | Remove-Item -Force -Recurse

# Clean the user's Google Chrome cache
$ChromeCacheDir = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"
Get-ChildItem -Path $ChromeCacheDir -Recurse | Remove-Item -Force -Recurse

# Clean the user's Firefox cache
$FirefoxCacheDir = "$env:APPDATA\Mozilla\Firefox\Profiles\*.default-release\cache2"
Get-ChildItem -Path $FirefoxCacheDir -Recurse | Remove-Item -Force -Recurse

# Clean the user's Prefetch folder
$PrefetchDir = "$env:WINDIR\Prefetch"
Get-ChildItem -Path $PrefetchDir -Recurse | Remove-Item -Force -Recurse

# Clean the user's Event Logs
Clear-EventLog -LogName Application -Force
Clear-EventLog -LogName System -Force
Clear-EventLog -LogName Security -Force

# Clean the user's Disk Cleanup
Invoke-Item "$env:SystemRoot\System32\cleanmgr.exe" /sagerun:1

# Output the summary
Write-Host "`nDisk and RAM has been cleaned. Please reboot.........................."
