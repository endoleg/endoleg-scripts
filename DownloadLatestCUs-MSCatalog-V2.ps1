Start-Transcript -Path "c:\Windows\Temp\PSWindowsUpdate-V2.log"

# stolen and modified from https://raw.githubusercontent.com/microsoft/MSLab/4862e185f9b1d63380f6f195fd9d1340df11ddd9/Tools/DownloadLatestCUs.ps1
$winver=$(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' | Select-Object -Property ReleaseId, DisplayVersion).DisplayVersion
$winver=(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion').DisplayVersion
Write-verbose -message "Windows Version: $winver" -verbose


#########################################################################################

#out-grid
$Products=@()
$Products+=@{Product="Windows Server 2022" ;SearchString="Cumulative Update for Windows Server 2022 for x64-based Systems"    ;SSUSearchString="Servicing Stack Update for Windows Server 2022 for x64-based Systems"           ; ID="Windows Server 2022"}
$Products+=@{Product="Windows Server 2019" ;SearchString="Cumulative Update for Windows Server 2019 for x64-based Systems"    ;SSUSearchString="Servicing Stack Update for Windows Server 2019 for x64-based Systems"           ; ID="Windows Server 2019"}
$Products+=@{Product="Windows Server 2016" ;SearchString="Cumulative Update for Windows Server 2016 for x64-based Systems"    ;SSUSearchString="Servicing Stack Update for Windows Server 2016 for x64-based Systems"           ; ID="Windows Server 2016"}
#$Products+=@{Product="Windows 10 20H2"     ;SearchString="Cumulative Update for Windows 10 Version 20H2 for x64-based Systems";SSUSearchString="Servicing Stack Update for Windows 10 Version 20H2 for x64-based Systems"       ; ID="Windows 10, version 1903 and later"}
$Products+=@{Product="Windows 10 21H2"     ;SearchString="Cumulative Update for Windows 10 Version 1909 for x64-based Systems";SSUSearchString="Servicing Stack Update for Windows 10 Version 21H2 for x64-based Systems"       ; ID="Windows 10, version 1903 and later"}

#grab folder to download to
$folder=Read-Host -Prompt "Please type path to download. For example `"c:\windows\temp`" (if nothing specified, c:\windows\temp\_Updates_ is used)"
if(!$folder){$folder='c:\windows\temp\_Updates_'}

<#
#do you want preview?
$preview=Read-Host -Prompt "Do you want to download preview updates? y/n, default n"
if($preview -eq "y"){
    $preview = $true
}else{
    $preview=$false
}
#>

#let user choose products
$SelectedProducts=$Products.Product | Out-GridView -OutputMode Multiple -Title "Please select products to download Cumulative Updates and Servicing Stack Updates"

#region check/download MSCatalog module
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
        }else {
        Write-verbose -message "--> MSCatalog PS Module is Installed" -verbose
    }
#endregion

#region check/download msrcsecurityupdates module
Write-verbose -message "Checking if msrcsecurityupdates PS Module is Installed" -verbose
    if (!(Get-InstalledModule -Name msrcsecurityupdates -ErrorAction Ignore)){
        # Verify Running as Admin
        $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
        If (!( $isAdmin )) {
            Write-verbose -Message "-- Restarting as Administrator to install Modules" -verbose; Start-Sleep -Seconds 1
            Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
            exit
        }
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
        Install-Module -Name msrcsecurityupdates -Force
        Import-module msrcsecurityupdates
        }else {
        Write-verbose -message "--> msrcsecurityupdates PS Module is Installed" -verbose
        Import-module msrcsecurityupdates
    }
#endregion

#region check/download kbupdate module
Write-verbose -message "Checking if kbupdate PS Module is Installed" -verbose
    if (!(Get-InstalledModule -Name kbupdate -ErrorAction Ignore)){
        # Verify Running as Admin
        $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
        If (!( $isAdmin )) {
            Write-verbose -Message "-- Restarting as Administrator to install Modules" -verbose; Start-Sleep -Seconds 1
            Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
            exit
        }
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
        Install-Module -Name kbupdate -Force
        }else {
        Write-verbose -message "--> kbupdate PS Module is Installed" -verbose
    }
#endregion

#Build-CVEReport - stolen by Brandon Stevens
Function Build-CVEReport {
### Install the module from the PowerShell Gallery (must be run as Admin)
#Install-Module -Name msrcsecurityupdates -force
#Import-module msrcsecurityupdates
Set-MSRCApiKey -ApiKey "1bd79db501ce49a5ae1a117a2de252c8" -Verbose

$culture = New-Object system.globalization.cultureinfo(“en-US”)
Get-MsrcCvrfDocument -ID "$((get-date).Year)-$(($culture).DateTimeFormat.GetAbbreviatedMonthName(((get-date).Month)))" | Get-MsrcSecurityBulletinHtml -Verbose | Out-File C:\Windows\Temp\MSRCSecurityUpdates-$(($culture).DateTimeFormat.GetAbbreviatedMonthName(((get-date).Month))).html -Force
#Get-MsrcCvrfDocument -ID "$((get-date).Year)-Jun" | Get-MsrcSecurityBulletinHtml -Verbose | Out-File C:\Windows\Temp\MSRCSecurityUpdates.html

}
#Build-CVEReport

#Folder
    $DestinationFolder="$folder\$SelectedProduct\'$(Get-Date -Format 'yyyy-MM')'"
    New-Item -Path $folder -ItemType Directory -ErrorAction Ignore | Out-Null
    New-Item -Path $DestinationFolder -ItemType Directory -ErrorAction Ignore | Out-Null

<#
#region download products
Foreach($SelectedProduct in $SelectedProducts){
    $item=$Products | Where-Object product -eq $SelectedProduct
    #Download CU
        If ($preview){
            $update=Get-MSCatalogUpdate -Search $item.searchstring | Where-Object Products -eq $item.ID | Select-Object -First 1
        }else{
            $update=Get-MSCatalogUpdate -Search $item.searchstring | Where-Object Products -eq $item.ID | Where-Object Title -like "*$($item.SearchString)*" | Select-Object -First 1
        }
    Write-verbose -message "Downloading $($update.title) to $destinationFolder" -verbose
    $update | Save-MSCatalogUpdate -Destination "$DestinationFolder" #-UseBits

    #Download SSU
    $update=Get-MSCatalogUpdate -Search $item.SSUSearchString | Where-Object Products -eq $item.ID | Select-Object -First 1
    Write-verbose -message "Downloading $($update.title) to $destinationFolder"  -verbose
    $update | Save-MSCatalogUpdate -Destination $DestinationFolder #-UseBits
}
#endregion
#>

function Find-CumulativMicrosoftUpdateLatest2016
{
  Param(
    [String] $Month,# = $(Get-Date -Format "yyyy-MM"),
    [ValidateSet("Microsoft server operating system version 21H2 for x64-based Systems","Windows Server x64-based Systems 2016","Windows Server x64-based Systems 2019")]
    $OSVersion
  )
 
  #$OSNAME="2016"
  #Write-Verbose "Query for $OSVersion" -Verbose
  #$request = Invoke-WebRequest -Uri 'https://www.catalog.update.microsoft.com/Search.aspx?q=2021-01%20Cumulative%20Update%20Windows%20Server%20x64-based%20Systems%202016' 
 
#ok   $request = Invoke-WebRequest -Uri ('https://www.catalog.update.microsoft.com/Search.aspx?q={0}%20Cumulative%20Update%20{1}' -f $Month,[uri]::EscapeUriString($OSVersion)  )
  $request = Invoke-WebRequest -Uri ('https://www.catalog.update.microsoft.com/Search.aspx?q={0}%20Cumulative%20Windows%20Server%202016%20x64%20for%20x64-based%20{1}' -f $Month,[uri]::EscapeUriString($OSVersion)  )
  $Result = @($request.Links.outerText -match "Cumulative\sUpdate\sfor")
  
  Return @($Result | ForEach-Object { 
      #'2020-12 Cumulative Update for Windows Server 2019 for x64-based Systems (KB4592440)' -match 'KB[0-9]*'
      $null = $_ -match 'KB[0-9]*'
      [PSCustomObject]@{
        HotFixID = $Matches[0]
        Description = $_
      }
     }
  )
}

function Find-CumulativMicrosoftUpdateLatest2019
{
  Param(
    [String] $Month,# = $(Get-Date -Format "yyyy-MM"),
    [ValidateSet("Microsoft server operating system version 21H2 for x64-based Systems","Windows Server x64-based Systems 2016","Windows Server x64-based Systems 2019")]
    $OSVersion
  )
 
  #$OSNAME="2016"
  #Write-Verbose "Query for $OSVersion" -Verbose
 
#ok   $request = Invoke-WebRequest -Uri ('https://www.catalog.update.microsoft.com/Search.aspx?q={0}%20Cumulative%20Update%20{1}' -f $Month,[uri]::EscapeUriString($OSVersion)  )
  $request = Invoke-WebRequest -Uri ('https://www.catalog.update.microsoft.com/Search.aspx?q={0}%20Cumulative%20Update%20for%20Windows%20Server%202019%20for%20x64-based%20-Datacenter%20-Preview%20{1}' -f $Month,[uri]::EscapeUriString($OSVersion)  )
  $Result = @($request.Links.outerText -match "Cumulative\sUpdate\sfor")
  
  Return @($Result | ForEach-Object { 
      #'2020-12 Cumulative Update for Windows Server 2019 for x64-based Systems (KB4592440)' -match 'KB[0-9]*'
      $null = $_ -match 'KB[0-9]*'
      [PSCustomObject]@{
        HotFixID = $Matches[0]
        Description = $_
      }
     }
  )
}

function Find-CumulativMicrosoftUpdateLatest2022
{
  Param(
    [String] $Month,# = $(Get-Date -Format "yyyy-MM"),
    [ValidateSet("Microsoft server operating system version 21H2 for x64-based Systems","Windows Server x64-based Systems 2016","Windows Server x64-based Systems 2019")]
    $OSVersion
  )
 
  #$OSNAME="2016"
  #Write-Verbose "Query for $OSVersion" -Verbose
 
#ok   $request = Invoke-WebRequest -Uri ('https://www.catalog.update.microsoft.com/Search.aspx?q={0}%20Cumulative%20Update%20{1}' -f $Month,[uri]::EscapeUriString($OSVersion)  )
  $request = Invoke-WebRequest -Uri ('https://www.catalog.update.microsoft.com/Search.aspx?q={0}%20cumulative%20Server%20Operating%20System%20Version%2021H2%20x64%20-preview%20-framework%20{1}' -f $Month,[uri]::EscapeUriString($OSVersion)  )
  $Result = @($request.Links.outerText -match "Cumulative\sUpdate\sfor")
  
  Return @($Result | ForEach-Object { 
      #'2020-12 Cumulative Update for Windows Server 2019 for x64-based Systems (KB4592440)' -match 'KB[0-9]*'
      $null = $_ -match 'KB[0-9]*'
      [PSCustomObject]@{
        HotFixID = $Matches[0]
        Description = $_
      }
     }
  )
}

Write-Verbose -Message "---- KBList_2016 ----" -Verbose
#$KBList2016 = (Find-CumulativMicrosoftUpdateLatest2016 -Month '2022-08' | Select-Object -First 1).HotFixID
$KBList2016 = (Find-CumulativMicrosoftUpdateLatest2016 -Month "$(Get-Date -Format 'yyyy-MM')" | Select-Object -First 1).HotFixID
$KBList2016 
Write-Verbose -Message "---- Latest Cumulative Update KB-Number: $KBList2016 ----" -Verbose
#Save-KbUpdate -Name $KBList2016 -FilePath $destinationFolder\$KBList2016.msu

Write-Verbose -Message "---- KBList_2019 ----" -Verbose
$KBList2019 = (Find-CumulativMicrosoftUpdateLatest2019 -Month "$(Get-Date -Format 'yyyy-MM')" | Select-Object -First 1).HotFixID
$KBList2019 
Write-Verbose -Message "---- Latest Cumulative Update KB-Number: $KBList2019 ----" -Verbose
#Save-KbUpdate -Name $KBList2019 -FilePath $destinationFolder\$KBList2019.msu

Write-Verbose -Message "---- KBList_2022 ----" -Verbose
$KBList2022 = (Find-CumulativMicrosoftUpdateLatest2022 -Month "$(Get-Date -Format 'yyyy-MM')" | Select-Object -First 1).HotFixID
$KBList2022 
Write-Verbose -Message "---- Latest Cumulative Update KB-Number: $KBList2022 ----" -Verbose
Save-KbUpdate -Name $KBList2022 -FilePath $destinationFolder+$($KBList2022).msu
#Save-KbUpdate -Name $KBList2022 -FilePath $destinationFolder

#start $destinationFolder
start $folder

Write-verbose -message "Job finished" -verbose
#Write-verbose -message "Press enter to continue" -verbose
#Read-Host

