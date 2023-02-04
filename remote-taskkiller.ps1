function Show-Taskkiller {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$false)]
        [string]$computername
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
            $process | Add-Member -type NoteProperty -name "VirtualSizeMB" -value ([math]::Round(($proc.VirtualSize / 1024 /1024), 2))
            $process | Add-Member -type NoteProperty -name "PriorityBase" -value $perf.PriorityBase
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

        #$colTasklist | Sort-Object PercentProcessorTime -Desc | Out-GridView -PassThru  -Title "Select processes to kill"
        $Processes = $colTasklist | Sort-Object PercentProcessorTime -Desc | Out-GridView -PassThru  -Title "$($perf.PSComputerName) Select processes to kill"
        #$Processes 

   
   Invoke-Command -ComputerName  $computername -ScriptBlock {param($Processes) $Processes | ForEach-Object {Stop-Process -Id $Processes.ProcessId -force  }} -ArgumentList $Processes 

        #$colTasklist | Sort-Object PercentProcessorTime -Desc 
 
        #return $colTasklist
    }
}

#Show-Taskkiller -computername localhost
Show-Taskkiller -computername remotecomputer

<# (Get-Process note*).PriorityClass
BasePriority	Priorityclass
4	Idle
8	Normal
13	High
24	RealTime
#>