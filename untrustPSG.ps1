# Check if the PSGallery repository exists
$repository = Get-PSRepository -Name "PSGallery" -ErrorAction SilentlyContinue

if ($repository) {
    # Set the PSGallery repository to not trusted
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Untrusted
    Write-Host "The PSGallery repository is now set to untrusted."
} else {
    Write-Host "The PSGallery repository does not exist."
}
# Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
