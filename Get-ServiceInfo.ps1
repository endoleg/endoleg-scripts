
# function Get-ServiceInfo - Zeig mir, gesammelt über get-service, get-wmiobject und get-eventlog Details über einen Service-Zustand, dessen Startzeit etc. an
function Get-ServiceInfo{
    param(
        [parameter(Mandatory=$true)]
        [string]$Name
    )

    $wmiObject = Get-WmiObject -Class Win32_Service -Filter "Name='$Name'"
    $eventLogEntries = Get-EventLog -LogName "System" -Source "Service Control Manager" | Where-Object {$_.EventID -eq 7036 -and $_.Message -like "*$Name*"}
    $lastTime = if ($eventLogEntries) {
    if ($eventLogEntries | Where-Object {$_.Message -like "*Ausgef*"}) {
        "Start: " + ($eventLogEntries | Where-Object {$_.Message -like "*Ausgef*"})[-1].TimeGenerated
    } elseif ($eventLogEntries | Where-Object {$_.Message -like "*beendet*"}) {
        "Stop: " + ($eventLogEntries | Where-Object {$_.Message -like "*beendet*"})[-1].TimeGenerated
    } else {
        "N/A"
    }
    } else {
    "Eventlog has no start or stop entries for Service - Dienst laut Eventlog noch nicht ein einziges Mal erfolgreich gestartet oder gestoppt worden"
    }
    $serviceProperties = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$Name"

    Get-Service -Name $Name | Select-Object DisplayName, Status, StartType, ServiceType, CanPauseAndContinue, CanShutdown, CanStop, DependentServices, 
    @{Name='Account'; Expression={$wmiObject.StartName -replace '^.*\\',''}},
    @{Name='Path'; Expression={$wmiObject.PathName -replace '^"|"$',''}},
    @{Name='Description'; Expression={$wmiObject.Description -replace '^"|"$',''}},
    @{Name='LastTimeStampsEventlog'; Expression={$lastTime}},
    @{Name='NumberOfEventlogSourceService'; Expression={($eventLog | Where-Object {$_.Source -eq $Name}).count}},
    @{Name='EventlogSourceServiceLastError'; Expression={
    if ((Get-EventLog -LogName "System" -Source $Name -Newest 1 | Where-Object {$_.Message -like "*error*"})) {(Get-EventLog -LogName "System" -Source $Name -Newest 1 | Where-Object {$_.Message -like "*error*"})} else {"N/A"}}},
    @{Name='ErrorControl'; Expression={$serviceProperties.ErrorControl}},
    @{Name='Group'; Expression={$serviceProperties.Group}},
    @{Name='Type'; Expression={$serviceProperties.Type}}
}

#Get-ServiceInfo -Name "netlogon"
Get-ServiceInfo -Name "wudfsvc"
#Get-ServiceInfo -Name "WemAgentSvc"
