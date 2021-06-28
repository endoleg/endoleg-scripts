# stolen and modified from https://raw.githubusercontent.com/microsoft/MSLab/4862e185f9b1d63380f6f195fd9d1340df11ddd9/Tools/DownloadLatestCUs.ps1

$winver=$(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' | Select-Object -Property ReleaseId, DisplayVersion).DisplayVersion
$winver=(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').DisplayVersion
Write-verbose -message "Windows Version: $winver" -verbose

<#
# get raw Windows version
[int64]$rawVersion = 
  [Windows.System.Profile.AnalyticsInfo,Windows.System.Profile,ContentType=WindowsRuntime].
  GetMember('get_VersionInfo').Invoke( $Null, $Null ).DeviceFamilyVersion

# decode bits to version bytes
$major = ( $rawVersion -band 0xFFFF000000000000l ) -shr 48
$minor = ( $rawVersion -band 0x0000FFFF00000000l ) -shr 32
$build = ( $rawVersion -band 0x00000000FFFF0000l ) -shr 16
$revision =   $rawVersion -band 0x000000000000FFFFl

# compose version
$winver = [System.Version]::new($major, $minor, $build, $revision)
$winver
#>

#########################################################################################

$Products=@()
$Products+=@{Product="Windows Server 2019" ;SearchString="Cumulative Update for Windows Server 2019 for x64-based Systems"    ;SSUSearchString="Servicing Stack Update for Windows Server 2019 for x64-based Systems"           ; ID="Windows Server 2019"}
$Products+=@{Product="Windows Server 2016" ;SearchString="Cumulative Update for Windows Server 2016 for x64-based Systems"    ;SSUSearchString="Servicing Stack Update for Windows Server 2016 for x64-based Systems"           ; ID="Windows Server 2016"}
$Products+=@{Product="Windows 10 20H2"     ;SearchString="Cumulative Update for Windows 10 Version 20H2 for x64-based Systems";SSUSearchString="Servicing Stack Update for Windows 10 Version 20H2 for x64-based Systems"       ; ID="Windows 10, version 1903 and later"}
#$Products+=@{Product="Windows 10 2004"     ;SearchString="Cumulative Update for Windows 10 Version 2004 for x64-based Systems";SSUSearchString="Servicing Stack Update for Windows 10 Version 2004 for x64-based Systems"       ; ID="Windows 10, version 1903 and later"}
#$Products+=@{Product="Windows 10 1909"     ;SearchString="Cumulative Update for Windows 10 Version 1909 for x64-based Systems";SSUSearchString="Servicing Stack Update for Windows 10 Version 1909 for x64-based Systems"       ; ID="Windows 10, version 1903 and later"}

#grab folder to download to
$folder=Read-Host -Prompt "Please type path to download. For example `"c:\windows\temp`" (if nothing specified, c:\windows\temp is used)"
if(!$folder){$folder='c:\windows\temp'}

#do you want preview?
$preview=Read-Host -Prompt "Do you want to download preview updates? Y/N, default N"
if($preview -eq "y"){
    $preview = $true
}else{
    $preview=$false
}

#let user choose products
$SelectedProducts=$Products.Product | Out-GridView -OutputMode Multiple -Title "Please select products to download Cumulative Updates and Servicing Stack Updates"

#region download MSCatalog module
Write-verbose -message "Checking if MSCatalog PS Module is Installed" -verbose
if (!(Get-InstalledModule -Name MSCatalog -ErrorAction Ignore)){
    # Verify Running as Admin
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    If (!( $isAdmin )) {
        Write-verbose -Message "-- Restarting as Administrator to install Modules" -verbose; Start-Sleep -Seconds 1
        Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
        exit
    }
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module -Name MSCatalog -Force
}else {Write-verbose -message "MSCatalog PS Module is Installed" -verbose
}

#endregion

#region download products
Foreach($SelectedProduct in $SelectedProducts){
    $item=$Products | Where-Object product -eq $SelectedProduct
    #Download CU
    If ($preview){
        $update=Get-MSCatalogUpdate -Search $item.searchstring | Where-Object Products -eq $item.ID | Select-Object -First 1
    }else{
        $update=Get-MSCatalogUpdate -Search $item.searchstring | Where-Object Products -eq $item.ID | Where-Object Title -like "*$($item.SearchString)*" | Select-Object -First 1
    }
    $DestinationFolder="$folder\$SelectedProduct\$($update.title.Substring(0,7))"
    New-Item -Path $DestinationFolder -ItemType Directory -ErrorAction Ignore | Out-Null
    Write-verbose -message "Downloading $($update.title) to $destinationFolder" -verbose
    $update | Save-MSCatalogUpdate -Destination "$DestinationFolder" #-UseBits

    #Download SSU
    $update=Get-MSCatalogUpdate -Search $item.SSUSearchString | Where-Object Products -eq $item.ID | Select-Object -First 1
    Write-verbose -message "Downloading $($update.title) to $destinationFolder"  -verbose
    $update | Save-MSCatalogUpdate -Destination $DestinationFolder #-UseBits
}
#endregion

Write-verbose -message "Job finished. Press enter to continue" -verbose
Read-Host
