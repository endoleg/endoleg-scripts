$StartDTM = (Get-Date)
$date = get-date -Format dd.MM.yyyy

Start-Transcript -Path "C:\Windows\Temp\MTU-$date.log" -IncludeInvocationHeader

Add-PSSnapin Citrix*

 $UID = Get-BrokerCatalog -Name "Win2016" -AdminAddress svacxdlcp3 | Select-Object -Property UID

 #$BGETEMMachines = (Get-BrokerMachine -CatalogUid  $UID.Uid).DNSName #| Select-Object -first 10
 $BGETEMMachines = (Get-BrokerMachine -CatalogUid  $UID.Uid).DNSName 

 $Results = Foreach( $cmp in $BGETEMMachines){
 
 Invoke-Command -ComputerName $cmp -ScriptBlock {
        
    param
    (

    )

    write-host "Pruefe $env:COMPUTERNAME"

    function Get-CtxSession{
        Param([pscustomobject] $SessionInfo)


        $Result = $(& CtxSession.exe  -v -s $SessionInfo.SessionID) | Out-String

        $pso = [PSCustomobject] @{
             RemoteAddress = ""
             CitrixClientName = ""
             Username = $SessionInfo.Username
             SessionID = $SessionInfo.SessionID
             TransportType = ""
             WorkspaceVer  = ""
             EDTBandwidth = 0
             #Mbps = ''
             MTU = 0
             RTT = 0
             LastLatency = ""
             AverageLatency = ""
             #ms = ''
             #SentBandwidth = ""             
             SentPreCompression = ""
             SentPostCompression = ""
             CompressionRatio = ""
             RecvPreExpansion = ""
             RecvPostExpansion=""
             ExpansionRatio = ""
             IcaBufferLength = ""
             LocalAddress = ""
             #ProfileServerCount = ""
             #ProfileSizeServer = ""
        }
        
        if($Result  -match 'Local\s+Address:\s+(?<IP>\d+\.\d+\.\d+\.\d+:\d+)') {$pso.LocalAddress =  $matches.IP; $matches = $null}
         $m = [REGEX]::Match($Result, 'Remote\s+Address:\s+(?<IP2>\d+\.\d+\.\d+\.\d+:\d+)'); if($m.Success) {$pso.RemoteAddress =  $m.Groups['IP2'].Value }
         $m = [REGEX]::Match($Result, 'EDT\s+MTU:\s+(?<MTU>\d+)'); if($m.Success) {$pso.MTU = [int] $m.Groups['MTU'].Value }     
        # Write-Host "$($pso.MTU)" -ForegroundColor Green

#SentPreCompression 
         $m = [REGEX]::Match($Result, 'SentPreCompression\s+=\s+\d+'); if($m.Success) { $pso.SentPreCompression = $m.Groups.Value }
         $pso.SentPreCompression = $pso.SentPreCompression -ireplace ("  = ",":")
         $pso.SentPreCompression = $pso.SentPreCompression -ireplace ("SentPreCompression:","")

#SentPostCompression
         $m = [REGEX]::Match($Result, 'SentPostCompression\s+=\s+\d+'); if($m.Success) { $pso.SentPostCompression = $m.Groups.Value }
         $pso.SentPostCompression = $pso.SentPostCompression -ireplace (" = ",":")         
         $pso.SentPostCompression = $pso.SentPostCompression -ireplace ("SentPostCompression:","")

#LastLatency 
         $m = [REGEX]::Match($Result, 'LastLatency\s+=\s+\d+'); if($m.Success) { $pso.LastLatency = $m.Groups.Value }
         $pso.LastLatency = $pso.LastLatency -ireplace (" =  ",":")         
         $pso.LastLatency = $pso.LastLatency -ireplace ("LastLatency        :","")

#IcaBufferLength 
         $m = [REGEX]::Match($Result, 'IcaBufferLength\s+=\s+\d+'); if($m.Success) { $pso.IcaBufferLength = $m.Groups.Value }
         $pso.IcaBufferLength = $pso.IcaBufferLength -ireplace (" =  ",":")         
         $pso.IcaBufferLength = $pso.IcaBufferLength -ireplace ("IcaBufferLength    :","")

#RecvPreExpansion 
         $m = [REGEX]::Match($Result, 'RecvPreExpansion\s+=\s+\d+'); if($m.Success) { $pso.RecvPreExpansion = $m.Groups.Value }
         $pso.RecvPreExpansion = $pso.RecvPreExpansion -ireplace (" =  ",":")         
         $pso.RecvPreExpansion = $pso.RecvPreExpansion -ireplace ("RecvPreExpansion   :","")

#RecvPostExpansion
         $m = [REGEX]::Match($Result, 'RecvPostExpansion\s+=\s+\d+'); if($m.Success) { $pso.RecvPostExpansion = $m.Groups.Value }
         $pso.RecvPostExpansion = $pso.RecvPostExpansion -ireplace (" =  ",":")         
         $pso.RecvPostExpansion = $pso.RecvPostExpansion -ireplace ("RecvPostExpansion  :","")

#ExpansionRatio 
         $m = [REGEX]::Match($Result, 'Expansion Ratio %\s+=\s+\d+'); if($m.Success) { $pso.ExpansionRatio = $m.Groups.Value }
         $pso.ExpansionRatio = $pso.ExpansionRatio -ireplace (" =  ",":")         
         $pso.ExpansionRatio = $pso.ExpansionRatio -ireplace ("Expansion Ratio %  :","")

#CompressionRatio 
         $m = [REGEX]::Match($Result, 'Compression Ratio %\s+=\s+\d+'); if($m.Success) { $pso.CompressionRatio = $m.Groups.Value }
         $pso.CompressionRatio = $pso.CompressionRatio -ireplace (" =  ",":")         
         $pso.CompressionRatio = $pso.CompressionRatio -ireplace ("Compression Ratio %:","")

#AverageLatency
         $m = [REGEX]::Match($Result, 'AverageLatency\s+=\s+\d+'); if($m.Success) { $pso.AverageLatency = $m.Groups.Value }
         $pso.AverageLatency = $pso.AverageLatency -ireplace (" =  ",":")         
         $pso.AverageLatency = $pso.AverageLatency -ireplace ("AverageLatency     :","")

         $m = [REGEX]::Match($Result, 'UDP'); if($m.Success){$pso.TransportType = "UDP";} else {$pso.TransportType = "TCP"}

#Workspace App Version
         $Clientversion=(Get-ItemProperty "Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\Ica\Session\$($SessionInfo.SessionID)\Connection" -name ClientVersion)
         $ClientversionSession=$Clientversion.ClientVersion
         write-verbose -message "---------- Workspace App ClientVersion: $ClientversionSession ----------" -verbose
         $pso.WorkspaceVer = $ClientversionSession
         
#Clientname
         $Clientversion2=(Get-ItemProperty "Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\Ica\Session\$($SessionInfo.SessionID)\Connection" -name ClientName)
         $CitrixClientName=$Clientversion2.ClientName
         write-verbose -message "---------- CitrixClientName: $CitrixClientName ----------" -verbose
         $pso.CitrixClientName = $CitrixClientName   
         
<#
        $UName=($SessionInfo.Username)
         $ProfileSizeServer = "{0:N2} GB" -f ((Get-ChildItem "\\bg10\citrix\Profile\$UName" -Force -Recurse -EA SilentlyContinue | measure Length -s).Sum /1GB)
         write-verbose -message "---------- Profil Server \\bg10\citrix\Profile\$UName - Groesse - $ProfileSizeServer----------" -verbose
         $pso.ProfileSizeServer = $ProfileSizeServer

         $Zaehler1= Get-ChildItem \\bg10\citrix\Profile\$UName -Force -Recurse -EA SilentlyContinue; $Zaehler2=$Zaehler1.count 
         write-verbose -message "---------- Profil Server \\bg10\citrix\Profile\$UName - Anzahl Dateien: $Zaehler2 ----------" -verbose
         $pso.ProfileServerCount = $Zaehler2
#>         
         
        $pattern =  'Bandwidth\s+(?<EDTBandwidth>\d+\.\d+)\s+(?<Mbps>\w+),.*RTT\s+(?<RTT>\d+\.\d+)\s+(?<ms>\w+)' #57.995 Mbps,  Send Rate 0 bps,  Recv Rate 0 bps,  RTT 48.949 ms'
        $m = [REGEX]::Match($Result,$pattern); if($m.Success) {  
            $pso.EDTBandwidth = [float] $m.Groups['EDTBandwidth'].Value;  
            #$pso.Mbps = $m.Groups['Mbps'].Value;  
            $pso.RTT =  [float] $m.Groups['RTT'].Value;  
            #$pso.ms = $m.Groups['ms'].Value;  
            #$pso.SentBandwidth = [float] $m.Groups['SentBandwidth (bps)'].Value;
            
        }
        return $pso
        $pso
    }
    
   $Sessions = foreach($line in (& quser.exe)){

      Write-Host $line -ForegroundColor Cyan
        $sessionobj = $null

        $m = [regex]::match( $line,'^.{1}(?<Username>.+)\s+(ica|rdp)')

        if($m.Success){
                $sessionobj = [PSCustomobject] @{
                   Username = ""
                   SessionID = ""
                }

                $sessionobj.Username = $m.Groups['Username'] 
                $m = [regex]::match( $line,'\s+(?<sessionid>\d+)\s+')
                if($m.Success){
                   $sessionobj.SessionID = $m.Groups['sessionid']
                }               
                
                $sessionobj
        }
    }


    $Sessions | Foreach-Object -process {Get-CtxSession -SessionInfo $_}
    


 
 } -ErrorAction SilentlyContinue
 }
 
 
 $Results | Out-GridView
 $Results | Out-HtmlView -FilePath "c:\Script\Logs\MTU-$date.html"
  
 
    Write-Verbose -Message "------------------------ c:\Script\Logs anlegen---------------  " -Verbose
    if(-not(Test-Path "c:\Script\Logs")){
    mkdir "c:\Script\Logs"
    }else{Write-Verbose -Message "------------------------ c:\Script\Logs anlegen nicht notwendig - schon vorhanden---------------  " -Verbose}


#Because I am going to open the output in Microsoft Excel, the one thing I need to do is to remember to use the –NoTypeInformation switched parameter. 
#This will keep the Type information from being written to the first line of the file. If the Type information is written, it will mess up the column display in Excel.
 $Results | Export-Csv -Path c:\Script\Logs\MTU-$date.csv -NoTypeInformation -UseCulture
Write-Verbose "c:\Script\Logs\MTU-$date.csv" -Verbose

$EndDTM = (Get-Date)
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalSeconds) Seconds" -Verbose
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalMinutes) Minutes" -Verbose

Stop-Transcript



 #$Results.GetType()
 
 
 #Invoke-Command -ComputerName svacxxd602 -ScriptBlock {(& quser.exe) }#| % { $_ -match '\s+(?<sessionid>\d+)\s+'} | % {$matches.sessionid} | Select-Object -Unique; $Sessionid | % {CtxSession -v -s $_}}

<#
 $Citrix_Euem_RoundTrip = Get-WmiObject -Namespace root\Citrix\euem -Class Citrix_Euem_RoundTrip
$CurrentSessionID = [System.Diagnostics.Process]::GetCurrentProcess().SessionId

foreach ($Session in $Citrix_Euem_RoundTrip)
{
         $Username=(Get-ItemProperty "Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Citrix\Ica\Session\$($Session.SessionID)\Connection" -name Username)
         $UsernameDisplay=$Username.UserName
         Write-verbose -message "Username: $UsernameDisplay" -Verbose
         Write-verbose -message "SessionID: $($Session.SessionID)" -Verbose
         Write-Verbose -message "RoundtripTime: $($Session.RoundtripTime)" -Verbose
         Write-verbose -message "OutputBandwidthAvailable: $($Session.OutputBandwidthAvailable)" -Verbose
         Write-verbose -message "OutputBandwidthUsed: $($Session.OutputBandwidthUsed)" -Verbose
         Write-verbose -message "InputBandwidthUsed: $($Session.InputBandwidthUsed)" -Verbose
         Write-verbose -message "NetworkLatency: $($Session.NetworkLatency)" -Verbose
         Write-verbose -message "PSComputerName: $($Session.PSComputerName)" -Verbose
         Write-verbose -message "OutputBandwidthUsed: $($Session.OutputBandwidthUsed)" -Verbose
         Write-verbose -message "----------------------------------------------------" -Verbose
}
#>


# https://evotec.pl/out-htmlview-html-alternative-to-out-gridview/
#Get-Module PSWriteHTML
#Register-PSRepository -Name "PSGallery" –SourceLocation "https://www.powershellgallery.com/api/v2/" -InstallationPolicy Trusted
#Register-PSRepository -Default
[Net.ServicePointManager]::SecurityProtocol = "tls12"
Get-PSRepository
Install-Module -name PSWriteHTML -Force

