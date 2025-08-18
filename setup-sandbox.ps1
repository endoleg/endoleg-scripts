# stolen from https://gist.github.com/cderv

# --- Setup so tools from github release ----------
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
# --- Tools -----

function Get-GithubLatestRelease {
    param (
        [parameter(Mandatory)][string]$project, # e.g. paintdotnet/release
        [parameter(Mandatory)][string]$pattern, # regex. e.g. install.x64.zip
        [switch]$prerelease
    )

    # Get all releases and then get the first matching release. Necessary because a project's "latest"
    # release according to Github might be of a different product or component than the one you're
    # looking for. Also, Github's 'latest' release doesn't include prereleases.
    $releases = Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/$project/releases"
    $downloadUrl = $releases |
                   Where-Object { $_.prerelease -eq $prerelease } |
                   ForEach-Object { $_.assets } |
                   Where-Object { $_.name -match $pattern } |
                   Select-Object -First 1 -ExpandProperty "browser_download_url"

    return $downloadUrl
}

Push-Location $env:TEMP

# Pre requis
# See https://github.com/microsoft/winget-cli/issues/1861
$file = "Microsoft.VCLibs.x64.14.00.Desktop.appx"
Invoke-WebRequest "https://aka.ms/$file" -Out $file

Add-AppxPackage $file

Remove-Item $file -Recurse -Force -ErrorAction SilentlyContinue

Invoke-WebRequest -Uri https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.3 -OutFile .\microsoft.ui.xaml.2.7.3.zip
Expand-Archive .\microsoft.ui.xaml.2.7.3.zip
Add-AppxPackage .\microsoft.ui.xaml.2.7.3\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx

Remove-Item microsoft.ui.xaml.2.7.3 -Recurse -Force -ErrorAction SilentlyContinue

# winget

$download = Get-GithubLatestRelease -project "microsoft/winget-cli" -pattern "Microsoft.DesktopAppInstaller.+.msixbundle"

$file = $download.Substring($download.LastIndexOf("/") + 1)

Write-Host Dowloading latest release
Invoke-WebRequest $download -Out $file

Add-AppxPackage $file

Remove-Item $file -Recurse -Force -ErrorAction SilentlyContinue 

# Terminal 
# Needs to be installed this way because of https://github.com/microsoft/winget-cli/issues/1705

$download = Get-GithubLatestRelease -project "microsoft/terminal" -pattern "Microsoft.WindowsTerminal_Win11.+.msixbundle"

$file = $download.Substring($download.LastIndexOf("/") + 1)

Write-Host Dowloading latest release
Invoke-WebRequest $download -Out $file

Add-AppxPackage $file

Remove-Item $file -Recurse -Force -ErrorAction SilentlyContinue 

Pop-Location

# install app

winget install --silent --id Git.Git --accept-package-agreements --accept-source-agreements
winget install --silent --id Github.cli --accept-package-agreements --accept-source-agreements
