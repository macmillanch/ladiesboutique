$ErrorActionPreference = 'Stop'
$repo = "anomalyco/opencode"
$releaseUrl = "https://github.com/$repo/releases/latest/download/opencode-windows-x64.zip"
$installDir = "$HOME\.opencode\bin"
$zipPath = "$env:TEMP\opencode.zip"

Write-Host "Downloading OpenCode from $releaseUrl..."
Invoke-WebRequest -Uri $releaseUrl -OutFile $zipPath

Write-Host "Extracting to $installDir..."
if (!(Test-Path -Path $installDir)) {
    New-Item -ItemType Directory -Force -Path $installDir | Out-Null
}
Expand-Archive -Path $zipPath -DestinationPath $installDir -Force

Write-Host "OpenCode installed to $installDir"
# Add to path if not present
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$installDir*") {
    Write-Host "Adding $installDir to User Path..."
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$installDir", "User")
    $env:Path += ";$installDir"
}
else {
    Write-Host "$installDir is already in the User Path."
}

Write-Host "Cleaning up..."
Remove-Item $zipPath

Write-Host "Installation complete. You may need to restart your terminal/IDE to use the 'opencode' command."
