Get-ExecutionPolicy
Set-ExecutionPolicy Bypass
# Get-ChildItem -Filter *.ps1 | ForEach-Object { & $_.FullName }
# CHANGE THIS PATH
Get-ChildItem -Path "C:\Users\Nathan\Desktop\JM25" -Filter *.ps1 | Where-Object { $_.Name -ne "runall.ps1" } | ForEach-Object { & $_.FullName }
.\networkpowershell.ps1 > network1.txt
