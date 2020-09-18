<#
    Collecting MTU-Information about Citrix Sessions with ctxsession.exe

    Author: Thorsten Enderlein - https://github.com/endoleg and https://twitter.com/endi24

    script layout is not the best, i know
    
    Many parts of the script are given/learned/stolen from some great guys:
    Thanks, Andreas Nick, https://twitter.com/NickInformation and to Pascal Röker for help with powershell scripting         
    Thanks https://twitter.com/sacha81 and https://twitter.com/R_Kossen for your know how
    
    More:
    https://docs.citrix.com/en-us/citrix-virtual-apps-desktops/technical-overview/hdx/adaptive-transport.html#edt-mtu-discovery
    https://support.citrix.com/article/CTX231821
    https://blog.sachathomet.ch/2020/06/04/citrix-cvad-und-mtu-discovery/
    https://www.citrix.com/blogs/2017/11/17/hdx-adaptive-transport-and-edt-icas-new-default-transport-protocol-part-i/
    https://www.citrix.com/blogs/2017/11/20/hdx-adaptive-transport-and-edt-icas-new-default-transport-protocol-part-ii/
#>

$StartDTM = (Get-Date)
$date = get-date -Format dd.MM.yyyy

Start-Transcript -Path "C:\Windows\Temp\MTU-$date.log" -IncludeInvocationHeader

Add-PSSnapin Citrix*

 $UID = Get-BrokerCatalog -Name "Win2016" -AdminAddress svacxdlcp3 | Select-Object -Property UID
 $Machines = (Get-BrokerMachine -CatalogUid  $UID.Uid).DNSName 

 $Results = Foreach( $cmp in $Machines){
 Invoke-Command -ComputerName $cmp -ScriptBlock {
    param
    (
    )

    write-host "Check $env:COMPUTERNAME"

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
             MTU = 0
             RTT = 0
             LastLatency = ""
             AverageLatency = ""
             SentPreCompression = ""
             SentPostCompression = ""
             CompressionRatio = ""
             RecvPreExpansion = ""
             RecvPostExpansion=""
             ExpansionRatio = ""
             IcaBufferLength = ""
             LocalAddress = ""
        }
        
        if($Result  -match 'Local\s+Address:\s+(?<IP>\d+\.\d+\.\d+\.\d+:\d+)') {$pso.LocalAddress =  $matches.IP; $matches = $null}
         $m = [REGEX]::Match($Result, 'Remote\s+Address:\s+(?<IP2>\d+\.\d+\.\d+\.\d+:\d+)'); if($m.Success) {$pso.RemoteAddress =  $m.Groups['IP2'].Value }
         $m = [REGEX]::Match($Result, 'EDT\s+MTU:\s+(?<MTU>\d+)'); if($m.Success) {$pso.MTU = [int] $m.Groups['MTU'].Value }     

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

#TransportType
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

#EDTBandwidth
        $pattern =  'Bandwidth\s+(?<EDTBandwidth>\d+\.\d+)\s+(?<Mbps>\w+),.*RTT\s+(?<RTT>\d+\.\d+)\s+(?<ms>\w+)' #57.995 Mbps,  Send Rate 0 bps,  Recv Rate 0 bps,  RTT 48.949 ms'
        $m = [REGEX]::Match($Result,$pattern); if($m.Success) {  
            $pso.EDTBandwidth = [float] $m.Groups['EDTBandwidth'].Value;  
            $pso.RTT =  [float] $m.Groups['RTT'].Value;  
            
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
 
    Write-Verbose -Message "------------------------ c:\Script\Logs add---------------  " -Verbose
    if(-not(Test-Path "c:\Script\Logs")){
    mkdir "c:\Script\Logs"
    }else{Write-Verbose -Message "------------------------ c:\Script\Logs exists ---------------  " -Verbose}

 $Results | Export-Csv -Path c:\Script\Logs\MTU-$date.csv -NoTypeInformation -UseCulture
Write-Verbose "Log: c:\Script\Logs\MTU-$date.csv" -Verbose

$EndDTM = (Get-Date)
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalSeconds) Seconds" -Verbose
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalMinutes) Minutes" -Verbose

Stop-Transcript
