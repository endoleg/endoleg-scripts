# function Get-ServiceInfo - Zeig mir, gesammelt über get-service, get-wmiobject und get-eventlog Details über einen Service-Zustand, dessen Startzeit etc. an
function Get-ServiceInfo{
    <#
    #################################################################
    # 
    # The Get-ServiceInfo function displays detailed information about the state, start time, and other properties of a service. 
    # It uses Get-Service, Get-WmiObject, and Get-EventLog to retrieve this information. The service name is specified as a 
    # mandatory parameter and the computer name is specified as an optional parameter. The function also displays information 
    # about the service's properties from the registry. If the ComputerName parameter is specified, the function is run on the remote computer.
    #
    #################################################################
    #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory=$true)]
        [string]$Name, #= "netlogon",
        [parameter(Mandatory=$false)]
        [string]$ComputerName = "localhost"
    )
    
    $wmiObject = Get-WmiObject -Class Win32_Service -Filter "Name='$Name'"
    #$wmiObject
    #Clear-Variable -Name eventLogEntries
    $eventLogEntries = $null
    $eventLogEntries = Get-EventLog -LogName "System" -Source "Service Control Manager" -after $(Get-Date).AddDays(-2) | Where-Object {$_.EventID -eq 7036 -and $_.Message -like "*$Name*"}
    #$eventLogEntries
    #Clear-Variable -Name lastTime
    $lastTime = $null
    $lastTime = if ($eventLogEntries) {
    if ($eventLogEntries | Where-Object {$_.Message -like "*Ausgef*"}) {
        "Start: " + ($eventLogEntries | Where-Object {$_.Message -like "*Ausgef*"})[-1].TimeGenerated
    } elseif ($eventLogEntries | Where-Object {$_.Message -like "*beendet*"}) {
        "Stop: " + ($eventLogEntries | Where-Object {$_.Message -like "*beendet*"})[-1].TimeGenerated
    } else {
        "N/A"
    }
    } else {
    "Eventlog has no start or stop entries for this Service"
    }
    $serviceProperties = Invoke-Command -ComputerName $ComputerName -ArgumentList $Name -ScriptBlock {
    param($Name)
    Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$Name"
    }

    write-verbose "Service-Details: $computername" -Verbose
    #Get-Service -Name $Name | Select-Object DisplayName, Status, StartType, ServiceType, CanPauseAndContinue, CanShutdown, CanStop, DependentServices, 
    Get-Service -Name $Name | Select-Object DisplayName, 
    @{Name='Account'; Expression={$wmiObject.StartName -replace '^.*\\',''}},
    @{Name='Path'; Expression={$wmiObject.PathName -replace '^"|"$',''}},
    @{Name='Description'; Expression={$wmiObject.Description -replace '^"|"$',''}},
    @{Name='LastTimeStampsEventlog'; Expression={$lastTime}},
    @{Name='NumberOfEventlogSourceService'; Expression={($eventLogEntries | Where-Object {$_.Source -eq $Name}).count}},
    @{Name='EventlogSourceServiceLastError'; Expression={
    if ((Get-EventLog -LogName "System" -Source $Name -Newest 1 | Where-Object {$_.Message -like "*error*"})) {(Get-EventLog -LogName "System" -Source $Name -Newest 1 | Where-Object {$_.Message -like "*error*"})} else {"N/A"}}},
    @{Name='ErrorControl'; Expression={$serviceProperties.ErrorControl}},
    @{Name='Group'; Expression={$serviceProperties.Group}},
    @{Name='Computername'; Expression={$ComputerName}},
    @{Name='Type'; Expression={$serviceProperties.Type}}
}

#Get-ServiceInfo -Name "netlogon" -ComputerName svacxxd609
#Get-ServiceInfo -Name "WSearch" #-ComputerName svacxxd610


####################################################################################################################################################

# Namen, Displaynamen, den Status und den Ursprung jedes Diensts anzeigen, der von ihm abhängig ist oder von dem der Dienst abhängig ist
# 
# The script defines a function called Get-ServiceDependencies that takes a mandatory parameter called ServiceName. 
# The function uses the Get-WmiObject cmdlet to retrieve a list of services that are either dependent on or depend on the specified service. 
# It then iterates through the list of services and creates a custom object for each service, containing the name and source (either "Antecedent" or "Dependent") of the service.
# Next, the function sorts the list of custom objects by name and retrieves the full service object for each service 
# using the Get-Service cmdlet. It then creates a new custom object for each service, containing the name, display name, status, 
# and source of the service. Finally, the function outputs the list of custom objects.
# The script then calls the Get-ServiceDependencies function and passes the service name "WSearch" as an argument. 
# If the ComputerName parameter is not specified, the function will run on the local computer. If a different computer name is specified, the function will run on the remote computer specified by the ComputerName parameter.

function Get-ServiceDependencies {
    <#
    #################################################################
    # 
    # Displays the name, display name, status, and source of each 
    # service that is dependent on or depends on the specified 
    # service.
    #
    #################################################################
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$ServiceName,
        [parameter(Mandatory=$false)]
        [string]$ComputerName = "localhost"
    )

    Invoke-Command -ComputerName $ComputerName -ScriptBlock {
        param($ServiceName)

        $services = Get-WmiObject -Class Win32_DependentService | 
            Where-Object { $_.Antecedent -match $ServiceName -or $_.Dependent -match $ServiceName } |
            ForEach-Object {
                [PSCustomObject]@{
                    Name = ($_.Antecedent -split 'Name=')[1].Trim('"')
                    Source = 'Antecedent'
                }
                [PSCustomObject]@{
                    Name = ($_.Dependent -split 'Name=')[1].Trim('"')
                    Source = 'Dependent'
                }
            }

        $services | 
            Sort-Object Name | 
            ForEach-Object {
                $service = Get-Service -Name $_.Name 
                [PSCustomObject]@{
                    Name = $service.Name
                    DisplayName = $service.DisplayName
                    Status = $service.Status
                    Source = $_.Source
                }
            }
    } -ArgumentList $ServiceName
}

#Get-ServiceDependencies -ServiceName "WSearch" -ComputerName "svacxxd607"
Get-ServiceDependencies -ServiceName "netlogon" #-ComputerName "svacxxd608"
