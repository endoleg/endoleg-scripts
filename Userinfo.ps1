Start-Transcript -Path "$env:USERPROFILE\Userinfo.log"

write-verbose -message "----------------------------------------------------------------" -verbose

$CitrixSessionID = Get-ChildItem -Path "HKCU:\Volatile Environment" -Name
write-verbose -message "---------- CitrixSessionID: $CitrixSessionID ----------" -verbose

$CitrixClientName = Get-WmiObject -Namespace root\citrix\hdx -Class Citrix_Client_Enum | Where-Object {$_.SessionID -eq $CitrixSessionID} | Select-Object -ExpandProperty Name
write-verbose -message "---------- User Clientname: $CitrixClientName - Citrix-HDX/ICA-Connections - not for RDP! ----------" -verbose

$CitrixClientIP = Get-WmiObject -Namespace root\citrix\hdx -Class Citrix_Client_Enum | Where-Object {$_.SessionID -eq $CitrixSessionID} | Select-Object -ExpandProperty Address
write-verbose -message "---------- CitrixClientIP: $CitrixClientIP ----------" -verbose

$HDXProtocol = Get-WmiObject -Namespace root\citrix\hdx -Class Citrix_Network_Enum | Where-Object {$_.SessionID -eq $CitrixSessionID} | Select-Object -ExpandProperty Component_Protocol
write-verbose -message "---------- HDXProtocol: $HDXProtocol  ----------" -verbose

$MTUSize=(ctxsession -v | findstr "EDT MTU:" | select -Last 1).split(":")[1].trimstart() 
write-verbose -message "---------- EDT MTU Size from ctxsession.exe: $MTUSize ----------" -verbose

$Latency=(ctxsession -v | findstr "AverageLatency") #| select -Last 1).split(":")[1].trimstart() 
write-verbose -message "---------- ICA-Latency (time from keystroke or mouse click to when it is processed on the (session) host) - from ctxsession.exe: $Latency ----------" -verbose
$RTT=(ctxsession -v | findstr "RTT") #| select -Last 1).split(":")[1].trimstart() 
write-verbose -message "---------- EDT RTT Round Trip Time (elapsed time for response - lower is better) - from ctxsession.exe: $RTT ----------" -verbose

$EDTBandwidth_bps = Get-WmiObject -Namespace root\citrix\hdx -Class Citrix_Network_Enum | Where-Object {$_.SessionID -eq $CitrixSessionID} | Select-Object -ExpandProperty Component_EDTBandwidth_bps
$EDTBandwidth_bps1 = [math]::Round($EDTBandwidth_bps / 1000000) 
write-verbose -message "---------- EDT Bandwidth: $EDTBandwidth_bps bps =  $EDTBandwidth_bps1 Mbps ----------" -verbose

$EDTRoundTripTime_usec = Get-WmiObject -Namespace root\citrix\hdx -Class Citrix_Network_Enum | Where-Object {$_.SessionID -eq $CitrixSessionID} | Select-Object -ExpandProperty Component_EDTRoundTripTime_usec
$EDTRoundTripTime_usec1 = [math]::Round($EDTRoundTripTime_usec / 1000) 
write-verbose -message "---------- EDT RoundTripTime (elapsed time for response - lower is better): $EDTRoundTripTime_usec usec = $EDTRoundTripTime_usec1 ms ----------" -verbose

#write-verbose -message "---------- Sessioninfo: (Registry Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\Ica\Session\$CitrixSessionID\Connection) ----------" -verbose
$Clientversion=(Get-ItemProperty "Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\Ica\Session\$CitrixSessionID\Connection" -name ClientVersion)
$ClientversionSession=$Clientversion.ClientVersion
write-verbose -message "---------- Workspace App ClientVersion: $ClientversionSession ----------" -verbose
$PublishedName=(Get-ItemProperty "Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\Ica\Session\$CitrixSessionID\Connection" -name PublishedName)
$PublishedNameSession=$PublishedName.PublishedName
write-verbose -message "---------- Gestarteter Desktop/App: $PublishedNameSession ----------" -verbose
$HRES=(Get-ItemProperty "Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\Ica\Session\$CitrixSessionID\Connection" -name HRES)
$HRES=$HRES.HRES
write-verbose -message "---------- HRES: $HRES ----------" -verbose
$VRES=(Get-ItemProperty "Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\Ica\Session\$CitrixSessionID\Connection" -name VRES)
$VRES=$VRES.VRES
write-verbose -message "---------- VRES: $VRES ----------" -verbose
write-verbose -message "----------------------------------------------------------------" -verbose

write-verbose -message "------ Reg HKCU\Control Panel\Desktop Logpixel ------------" -verbose
$exists= Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop' | Select-Object -ExpandProperty 'LogPixels' -ErrorAction SilentlyContinue
    if (($exists -eq $null) -or ($exists.Length -eq 0)) 
    {   write-verbose -message "---------- LogPixels does not exist (false) - STD = 100% ----------" -verbose
    }else{write-verbose -message "---------- LogPixels exists (true) - Logpixel = $exists ----------" -verbose}
write-verbose -message @"
 Translation:
              96 = 100% DPI
              120 = 125%
              144 = 150%
              192 = 200%
              240 = 250%
              288 = 300%" -Verbose
"@ -verbose
write-verbose -message "----------------------------------------------------------------" -verbose
$ProfileSize = "{0:N2} GB" -f ((Get-ChildItem $ENV:USERPROFILE -Force -Recurse -EA SilentlyContinue | measure Length -s).Sum /1GB)
write-verbose -message "---------- Profile local $ENV:USERPROFILE - Size - (fuer FSLogix spaeter mal interessant): $ProfileSize ----------" -verbose
$Zaehler1= Get-ChildItem $ENV:USERPROFILE -Force -Recurse -EA SilentlyContinue; $Zaehler2=$Zaehler1.count 
write-verbose -message "---------- Profil local $ENV:USERPROFILE - Anzahl Dateien: $Zaehler2 ----------" -verbose

#New-ItemProperty -Path $RegistryPath -Name "Profile Size" -Value $ProfileSize -Force

$Profilepath=\\bg10\private\ProfileXD
$ProfileSizeServer = "{0:N2} GB" -f ((Get-ChildItem $Profilepath\$env:USERNAME -Force -Recurse -EA SilentlyContinue | measure Length -s).Sum /1GB)
write-verbose -message "---------- Profile Server $Profilepath\$env:USERNAME - size - $ProfileSizeServer----------" -verbose
$Zaehler1= Get-ChildItem $Profilepath\$env:USERNAME -Force -Recurse -EA SilentlyContinue; $Zaehler2=$Zaehler1.count 
write-verbose -message "---------- Profile Server $Profilepath\$env:USERNAME - files: $Zaehler2 ----------" -verbose

write-verbose -message "----------------------------------------------------------------" -verbose
$Policy_SessionReliabilityTimeout= Get-WmiObject -Namespace root\citrix\hdx -Class Citrix_Network_Enum | Where-Object {$_.SessionID -eq $CitrixSessionID} | Select-Object -ExpandProperty Policy_SessionReliabilityTimeout
write-verbose -message "---------- Policy_SessionReliabilityTimeout: $Policy_SessionReliabilityTimeout ----------" -verbose
$HDXCodec = Get-WmiObject -Namespace root\citrix\hdx -Class Citrix_VirtualChannel_Thinwire_Enum | Where-Object {$_.SessionID -eq $CitrixSessionID} | Select-Object -ExpandProperty Component_VideoCodecUse
write-verbose -message "---------- HDX Video Codec: $HDXCodec ----------" -verbose
$HDXCodecType = Get-WmiObject -Namespace root\citrix\hdx -Class Citrix_VirtualChannel_Thinwire_Enum | Where-Object {$_.SessionID -eq $CitrixSessionID} | Select-Object -ExpandProperty Component_Monitor_VideoCodecTypeCurrent
write-verbose -message "---------- HDX Video Codec Type: $HDXCodecType ----------" -verbose
$VisualLosslessCompression = Get-WmiObject -Namespace root\citrix\hdx -Class Citrix_VirtualChannel_Thinwire_Enum | Where-Object {$_.SessionID -eq $CitrixSessionID} | Select-Object -ExpandProperty Policy_AllowVisuallyLosslessCompression
write-verbose -message "---------- Policy VisualLosslessCompression: $VisualLosslessCompression  ----------" -verbose
$VisualQuality = Get-WmiObject -Namespace root\citrix\hdx -Class Citrix_VirtualChannel_Thinwire_Enum | Where-Object {$_.SessionID -eq $CitrixSessionID} | Select-Object -ExpandProperty Policy_VisualQuality
write-verbose -message "---------- Policy VisualQuality: $VisualQuality ----------" -verbose
$FramesPerSecond = Get-WmiObject -Namespace root\citrix\hdx -Class Citrix_VirtualChannel_Thinwire_Enum | Where-Object {$_.SessionID -eq $CitrixSessionID} | Select-Object -ExpandProperty Policy_FramesPerSecond
write-verbose -message "---------- Policy FramesPerSecond: $FramesPerSecond ----------" -verbose
$HDXColorspace = Get-WmiObject -Namespace root\citrix\hdx -Class Citrix_VirtualChannel_Thinwire_Enum | Where-Object {$_.SessionID -eq $CitrixSessionID} | Select-Object -ExpandProperty Component_VideoCodecColorspace
write-verbose -message "---------- HDXColorspace (H264 = Yuv420): $HDXColorspace  ----------" -verbose
$WEM = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayName -like "*Citrix Workspace Environment*"}).DisplayVersion | Select-Object -Last 1 
write-verbose -message "---------- WEM-Version: $WEM ----------" -verbose
write-verbose -message "----------------------------------------------------------------" -verbose

start-sleep 1

write-verbose -message "----------------------------------------------------------------" -verbose
write-verbose -message "---------- Sessioninfo: PublishedName, HRes, Vres, ClientVersion, Clienttype, Sessionstate, ClientName, ClientIP, Username ----------" -verbose
Get-ItemProperty "Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\Ica\Session\$CitrixSessionID\Connection"

write-verbose -message "---------- Sessioninfo wmic: hdx path citrix_virtualchannel_thinwire ----------" -verbose
wmic /namespace:\\root\citrix\hdx path citrix_virtualchannel_thinwire get /value

write-verbose -message "----------------------------------------------------------------" -verbose
write-verbose -message "---------- User Shell Folders ----------" -verbose
write-verbose -message "---------- Quelle: HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders ----------" -verbose
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"

write-verbose -message "---------- Mapped Drives ----------" -verbose
$drives = Get-WmiObject -Class Win32_MappedLogicalDisk | select @{Name="Drive";Expression={$_.Name}}, @{Name="UNC Share";Expression={$_.ProviderName}}

if ($drives -ne $null) {Write-Output $drives | ft -AutoSize}
if ($drives -eq $null) {write-verbose -message "No mapped drives present in this user's session." -verbose}
foreach($item in $drives){
    $drive= $item.drive
    $item = $item.'UNC Share'.Split('\')
    if($item[4] -ne $null){
        $share= "\\$($item[2])"+ "\$($item[3])" + "\$($item[4])"
        Write-host "$($drive)"(Get-DfsnFolderTarget $share).TargetPath
         "-----------------------------------"
    }
}


write-verbose -message "----------------------------------------------------------------" -verbose
write-verbose -message "----------------------------------------------------------------" -verbose

Write-verbose -message "" -verbose
write-verbose -message "----------  Write username to HKCU  ------------" -verbose
REG ADD "HKCU" /v "Username"  /d "$env:username" /t REG_SZ /f

Write-verbose -message "" -verbose
write-verbose -message "---------- Username to SID umwandeln ----------" -verbose
$DOMAIN = "XYZ"
$USERNAME = $env:UserName
$objUser = New-Object System.Security.Principal.NTAccount($DOMAIN, $USERNAME)
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
write-verbose -message "---------- Benutzername $DOMAIN\$env:UserName has SID ----------" -verbose
$strSID.Value
Write-verbose -message "" -verbose
write-verbose -message "----------  Write UserSID $strSID to HKCU ------------" -verbose
REG ADD "HKCU" /v "UserSID"  /d "$strSID" /t REG_SZ /f

Write-verbose -message "" -verbose
write-verbose -message "----------  Write Name to HKCU ------------" -verbose
$Vollername = (Get-ADUser -Identity $env:UserName -Properties DisplayName).DisplayName
REG ADD "HKCU" /v "Name"  /d "$Vollername" /t REG_SZ /f
write-verbose -message "----------  Wrote $Vollername to HKCU  ------------" -verbose

Write-verbose -message "" -verbose
write-verbose -message "----------------------------------------------------------------" -verbose
write-verbose -message "----------------------------------------------------------------" -verbose

write-verbose -message "----------------------------------------------------------------" -verbose
write-verbose -message "----------------------------------------------------------------" -verbose
write-verbose -message "---------- Ordnerumleitungen ----------" -verbose

Function Get-RegistryKeyPropertiesAndValues
{
  <#
    This function is used here to retrieve registry values while omitting the PS properties
    Example: Get-RegistryKeyPropertiesAndValues -path 'HKCU:\Volatile Environment'
    Origin: Http://www.ScriptingGuys.com/blog
    Via: http://stackoverflow.com/questions/13350577/can-powershell-get-childproperty-get-a-list-of-real-registry-keys-like-reg-query
  #>

 Param(
  [Parameter(Mandatory=$true)]
  [string]$path
  )

  Push-Location
  Set-Location -Path $path
  Get-Item . |
  Select-Object -ExpandProperty property |
  ForEach-Object {
      New-Object psobject -Property @{"Folder"=$_;
        "RedirectedLocation" = (Get-ItemProperty -Path . -Name $_).$_}}
  Pop-Location
}

# Get the user profile path, while escaping special characters because we are going to use the -match operator on it
$Profilepath = [regex]::Escape($env:USERPROFILE)

# List all folders
$RedirectedFolders = Get-RegistryKeyPropertiesAndValues -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" | Where-Object {$_.RedirectedLocation -notmatch "$Profilepath"}
if ($RedirectedFolders -eq $null) {
    Write-Output "No folders are redirected for this user"
} else {
    $RedirectedFolders | format-list *
}
write-verbose -message "----------------------------------------------------------------" -verbose
write-verbose -message "----------------------------------------------------------------" -verbose


""
Write-Verbose -Message  "-------------------Reg Eintrag für Fehleranlyse Outlook-------------------" -Verbose
""


#write-verbose -message "----------------------------------------------------------------" -verbose
#write-verbose -message "------ Auslesen Reg Eintrag für Fehleranlyse Outlook------------" -verbose
if(test-path "HKCU:\Software\Microsoft\Office\16.0\Outlook\AutoDiscover\RedirectServers\"){
    $Propertys= Get-Item "HKCU:\Software\Microsoft\Office\16.0\Outlook\AutoDiscover\RedirectServers\" | Select-Object -ExpandProperty Property
    $Propertys
}

#write-verbose -message "----------------------------------------------------------------" -verbose
#write-verbose -message "----------------------------------------------------------------" -verbose
#write-verbose -message "---------- Gruppenmitgliedschaften usw. ----------" -verbose
#whoami /groups
#net user endethor /domain

write-verbose -message "----------------------------------------------------------------" -verbose
write-verbose -message "----------------------------------------------------------------" -verbose
write-verbose -message "---------- GPresult /v - Angewendete GPOs, Gruppenmitgliedschaften usw. ----------" -verbose
GPRESULT.exe /v

start-sleep 1

write-verbose -message "---------- Citrix SessionID ----------" -verbose
# Citrix SessionID
$CitrixSessionID = Get-ChildItem -Path "HKCU:\Volatile Environment" –Name
$CitrixSessionID
#New-ItemProperty -Path $RegistryPath -Name "Citrix SessionID" -Value $CitrixSessionID -Force

write-verbose -message "---------- $env:USERPROFILE\add-ins.log wird erstellt ----------" -verbose
&"c:\program files (x86)\bootinstallationXD76\OfficeIns.exe" /stext $env:USERPROFILE\add-ins.log
#&"c:\windows\system32\OfficeIns.exe" /stext C:\Users\$env:UserName\add-ins.log
write-verbose -message "----------------------------------------------------------------" -verbose

write-verbose -message "---------- Addins HKCU\SOFTWARE\Microsoft\Office\Outlook\Addins auflisten (u.a. MailToPeo (alt) vs BG.MailToPEo (neu)) ----------" -verbose
write-verbose -message "------------- Einige User haben Probleme mit dem alten MailToPeo-Addin - das muss dann hier geloescht werden  ----------" -verbose
#Get-ChildItem -Path "HKCU:\SOFTWARE\Microsoft\Office\Outlook\Addins\" | Select-Object Name
$ABGEFRAGTERKEY="HKCU:\SOFTWARE\Microsoft\Office\Outlook\Addins\MailToPeo\"
IF ((Test-Path -Path $ABGEFRAGTERKEY))
{
        write-verbose "------------- Veralteter Key $ABGEFRAGTERKEY ist da und koennte Probleme verursachen" -Verbose
        Send-MailMessage -from "noreply@bgetem.de" -to "Enderlein.Thorsten@bgetem.de" -Subject "Alter Key $ABGEFRAGTERKEY Benutzer $env:username auf $env:COMPUTERNAME" -Body "$env:username - $usersid - $env:COMPUTERNAME - \\$env:COMPUTERNAME\c$\users\$env:username\" -SmtpServer "smtp.bg10.bgfe.local"
        #write-verbose "Key $ABGEFRAGTERKEY wird geloescht" -Verbose
        #remove-Item -Path $ABGEFRAGTERKEY -Force
}
IF (-not (Test-Path -Path $ABGEFRAGTERKEY))
{
        write-verbose "------------- Key $ABGEFRAGTERKEY ist NICHT DA" -Verbose
        #write-verbose "Key $ABGEFRAGTERKEY wird geloescht" -Verbose
        #remove-Item -Path $ABGEFRAGTERKEY -Force
}


start-sleep 2

write-verbose -message "----------------------------------------------------------------" -verbose
write-verbose -message "---------- App-V-Gruppen - Analyse über http://appv.bg10.bgfe.local:8991/ ----------" -verbose
write-verbose -message "---------- Pakete liegen unter $ENV:USERPROFILE\AppData\Roaming\Microsoft\AppV\Client\VFS ----------" -verbose
Get-ADPrincipalGroupMembership $env:USERNAME|Where-Object -FilterScript  {$_.name -match 'CTX-PApps-App-V'} | Sort-Object -Property Name| Format-table Name, distinguishedName
write-verbose -message "----------------------------------------------------------------" -verbose

write-verbose -message "---------- Logon phase timings --------------------------------" -verbose
$Sessionkey=gcim -Namespace root/citrix/hdx -ClassName Citrix_Sessions -Filter "SessionId = $CitrixSessionID " | select -ExpandProperty Sessionkey
write-verbose -message "---------- CitrixSessionID: $Sessionkey" -Verbose
$gcim= gcim -Namespace root/citrix/Profiles/Metrics -ClassName LogonTimings -Filter "SessionId = '$Sessionkey'"
$gcim
start-sleep 3
$gcimstart = $gcim.UPMStart
$gcimend = $gcim.DesktopReady
$timespan= New-TimeSpan -Start $gcimstart -End $gcimend
write-verbose -message "---------------- Sekunden zwischen UPMStart und DesktopReady: $($timespan.Seconds) ------------------------------------------------" -verbose 

write-verbose -message "---------- Citrix-Policies ----------" -verbose
start-sleep 3
Get-ItemProperty HKLM:\SOFTWARE\Policies\Citrix\$CitrixSessionID\User\*

write-verbose -message "----------------------------------------------------------------" -verbose
write-verbose -message "---------- directory-treesize.ps1 ----------" -verbose
####powershell.exe -executionpolicy bypass \\bg10\netlogon\Citrix\WEM\Profilgroesse\directory-treesize.ps1 -directory \\bg10\private\ProfileXD\$env:USERNAME #-notree #-detail
powershell.exe -executionpolicy bypass \\bg10\netlogon\Citrix\WEM\Profilgroesse\directory-treesize.ps1 -directory \\bg10\private\ProfileXD\$env:USERNAME -showPercent

Stop-Transcript











<#
$Query = "*[EventData[Data[@Name='PrincipalSamName'] and (Data='bg10\$env:username')]]"
[array]$Events = Get-WinEvent -ProviderName Microsoft-Windows-GroupPolicy -FilterXPath "$Query"

$message = Get-WinEvent -ProviderName Microsoft-Windows-GroupPolicy -FilterXPath "*[System[(EventID='5312')]]" #| Where-Object{$_.ActivityId -eq $ActivityId}
#Displays the 'Message Property'
Write-Host $message.Message
#>

<#
write-verbose -message "---------- Microsoft-Windows-GroupPolicy/Operational log muss groß genug sein! ----------" -verbose
write-verbose -message "---------- User-GPOs auflisten ----------" -verbose
$ErrorActionPreference = "Stop"     #   another way to try to stop the script in case of errors. Important for Try/Catch usage.</p>
$username = $args[0]
#Defines to filter by Event Id '4001' and by an positional argument which 'ControlUp' provide based on context
$Query = "*[EventData[Data[@Name='PrincipalSamName'] and (Data='$username')]] and *[System[(EventID='4001')]]"
try {
   # Gets all the events matching the criteria by $Query<br />
    [array]$Events = Get-WinEvent -ProviderName Microsoft-Windows-GroupPolicy -FilterXPath "$Query"
    $ActivityId = $Events[0].ActivityId.Guid
}
catch {
    Write-Host "Could not find relevant events in the Microsoft-Windows-GroupPolicy/Operational log. `nThe default log size (4MB) only supports user sessions that logged on a few hours ago. Please increase the log size to support older sessions."
    Exit 1
} 
$message = Get-WinEvent -ProviderName Microsoft-Windows-GroupPolicy -FilterXPath "*[System[(EventID='5312')]]" | Where-Object{$_.ActivityId -eq $ActivityId}
#Displays the 'Message Property'
Write-Host $message.Message
#>

#write-verbose -message "---------- Drucker auflisten ----------" -verbose
#$RedirectedFolders = Get-WmiObject -Class Win32_Printer | select -Property Name,Sharename
#if ($RedirectedFolders -eq $null) {
#write-verbose -message "---------- Keine Drucker ----------" -verbose
#} else {
#    $RedirectedFolders | Format-Table -Autosize
#write-verbose -message "---------- Standard-Drucker ist ----------" -verbose
#   (Get-WmiObject -Class Win32_Printer -Filter "Default = $true").Name
#}
