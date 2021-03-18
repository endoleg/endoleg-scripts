function Write-WinEvent2 {
    [CmdLetBinding()]
    param(
        [string]$LogName,
        [string]$Provider,
        [int64]$EventId,
        [System.Diagnostics.EventLogEntryType]$EventType,
        [System.Collections.Specialized.OrderedDictionary]$EventData,
        [ValidateSet('JSON','CSV','XML','PLAIN')]
        [string]$MessageFormat='JSON'
    )
    
    $EventMessage = @()
    
    switch ($MessageFormat) {
        'JSON' {$EventMessage += $EventData | ConvertTo-Json }
        'CSV' {$EventMessage += ($EventData.GetEnumerator() | Select-Object -Property Key,Value | ConvertTo-Csv -NoTypeInformation) -join "`n"}
        'XML' {$EventMessage += ($EventData | ConvertTo-Xml).OuterXml }
    }
        
    $EventMessage += foreach ($Key in $EventData.Keys) {
        '{0}:{1}' -f $Key,$EventData.$Key
    }
    
    try {
        $Event = [System.Diagnostics.EventInstance]::New($EventId,$null,$EventType)
        $EventLog = [System.Diagnostics.EventLog]::New()
        $EventLog.Log = $LogName
        $EventLog.Source = $Provider
        $EventLog.WriteEvent($Event,$EventMessage)
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

$EventData = [ordered]@{Program = 'MyProgram';ThisEvent = 'This is an event I want to track'; SomethingElse = 'I like the C64'}

Write-WinEventEventdata -LogName "Application" -Provider BGETEM-LOG -EventId 999 -EventType Information -EventData $EventData 
#Write-WinEventEventdata -LogName Application -Provider Userinfo -EventId 1000 -EventType Information -EventData $EventData
