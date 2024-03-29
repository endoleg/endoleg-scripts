<#
.SYNOPSIS
Manipulate the Process BasePriority with Powershell
.DESCRIPTION
Manipulate the Process BasePriority with Powershell
This is not permanent, but takes effect immediately. These settings remains not in effect if the system or process is restarted.

.PARAMETER computername
Remote-Computername to scan for processes

.PARAMETER PriorityValue
Value-Parameter used for Basepriority (default is "Normal")
BasePriority	Priorityclass
4	Idle
8	Normal
13	High

.EXAMPLE
Show-TaskmanagerBasepriority -computername remotecomputer -PriorityValue High

.EXAMPLE
Show-TaskmanagerBasepriority -computername localhost -PriorityValue BelowNormal

.NOTES
Test, test and test before you use it in production!
#Check with Get-Process <Prozessname> | Select-Object PriorityClass

Thorsten Enderlein, 2023
Twitter: @endi24
github: https://github.com/endoleg/
#>


function Show-TaskmanagerBasepriority {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$false)]
        [string]$computername,
        [ValidateSet("High", "Normal", "BelowNormal", "AboveNormal", "Idle", "RealTime")]
        [string]$PriorityValue = "Normal"
    )    

    PROCESS {
        $colProcs = Get-wmiobject win32_process -computername $computername  | select *,@{Name=”Owner”;Expression={($_.GetOwner()).User}}
        #$colProcs
        $colPerfs = Get-wmiobject win32_perfformatteddata_perfproc_process -computername $computername 
        #$colPerfs
        $colTasklist = @()

        foreach ($proc in $colProcs) {
            $process = New-Object System.Object

            $perf = $colPerfs | Where-Object { $_.IDProcess -eq $proc.ProcessId }

            $process | Add-Member -type NoteProperty -name "PSComputerName" -value $perf.PSComputerName
            $process | Add-Member -type NoteProperty -name "Name" -value $proc.Name       
            $process | Add-Member -type NoteProperty -name "Owner" -value $proc.Owner
            $process | Add-Member -type NoteProperty -name "SessionId" -value $proc.SessionId
            $process | Add-Member -type NoteProperty -name "PriorityBase" -value $perf.PriorityBase
            $process | Add-Member -type NoteProperty -name "VirtualSizeMB" -value ([math]::Round(($proc.VirtualSize / 1024 /1024), 2))
            $process | Add-Member -type NoteProperty -name "PercentProcessorTime" -value $perf.PercentProcessorTime
            $process | Add-Member -type NoteProperty -name "Commandline" -value $proc.Commandline
            $process | Add-Member -type NoteProperty -name "OSName" -value $proc.OSName
            $process | Add-Member -type NoteProperty -name "Description" -value $proc.Description
            $process | Add-Member -type NoteProperty -name "ProcessId" -value $proc.ProcessId
            $process | Add-Member -type NoteProperty -name "ThreadCount" -value $perf.ThreadCount
            $process | Add-Member -type NoteProperty -name "Handles" -value $proc.Handles
            $process | Add-Member -type NoteProperty -name "Handle" -value $proc.Handle

            $colTasklist += $process
        }

        $Processes = $colTasklist | Sort-Object PercentProcessorTime -Desc | Out-GridView -PassThru  -Title "$($perf.PSComputerName) - Select process to manipulate with BasePriority: $PriorityValue"
        
   
   Invoke-Command -ComputerName  $computername -ScriptBlock {
       param($Processes, $PriorityValue) $Processes | ForEach-Object {

            function Set-ProcessPriority {
              [CmdletBinding()] Param(
                [Int32] $Id,
                [System.Diagnostics.ProcessPriorityClass] $Priority
              )
              Get-Process -Id $Processes.ProcessId | %{ $_.PriorityClass = $Priority }
              Gwmi Win32_Process -Filter "ProcessId = '$Id'" | %{ $_.SetPriority( $Priority.Value__ ) }
            }

            write-host "PriorityValue: $PriorityValue"
                 
                 switch ($PriorityValue) {
                    "High" {
                        Set-ProcessPriority -id $($Processes.ProcessId) High
                    }
                    "Normal" {
                        Set-ProcessPriority -id $($Processes.ProcessId) Normal
                    }
                    "BelowNormal" {
                        Set-ProcessPriority -id $($Processes.ProcessId) BelowNormal
                    }
                    "AboveNormal" {
                        Set-ProcessPriority -id $($Processes.ProcessId) AboveNormal
                    }    
                    "Idle" {
                        Set-ProcessPriority -id $($Processes.ProcessId) Idle
                    }    
                    "RealTime" {
                        Set-ProcessPriority -id $($Processes.ProcessId) RealTime
                    }    
                }                   
       }
   } -ArgumentList $Processes, $PriorityValue

    }
}

#Show-TaskmanagerBasepriority -computername localhost -PriorityValue High
#Show-TaskmanagerBasepriority -computername remotecomputer -PriorityValue High
