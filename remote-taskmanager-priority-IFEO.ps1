function Show-Taskmanager-Basepriority {
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

   
   #Invoke-Command -ComputerName  $computername -ScriptBlock {param($Processes) $Processes | ForEach-Object {Stop-Process -Id $Processes.ProcessId -force  }} -ArgumentList $Processes 
   Invoke-Command -ComputerName  $computername -ScriptBlock {
       param($Processes) $Processes | ForEach-Object {
           #Stop-Process -Id $Processes.ProcessId -force  

            function Set-ProcessPriority {
              [CmdletBinding()] Param(
                [Int32] $Id,
                [System.Diagnostics.ProcessPriorityClass] $Priority
              )
              Get-Process -Id $Processes.ProcessId | %{ $_.PriorityClass = $Priority }
              Gwmi Win32_Process -Filter "ProcessId = '$Id'" | %{ $_.SetPriority( $Priority.Value__ ) }
            }
            Set-ProcessPriority -id $($Processes.ProcessId) High
            #Set-ProcessPriority -id $($Processes.ProcessId) Normal
            #Set-ProcessPriority -id $($Processes.ProcessId) BelowNormal
            #Set-ProcessPriority -id $($Processes.ProcessId) AboveNormal
            #Set-ProcessPriority -id $($Processes.ProcessId) Idle
            #Set-ProcessPriority -id $($Processes.ProcessId) RealTime
       }
   } -ArgumentList $Processes 

        #$colTasklist | Sort-Object PercentProcessorTime -Desc 
        #return $colTasklist
    }
}

#Show-Taskmanager-Basepriority -computername localhost
#Show-Taskmanager-Basepriority -computername remotecomputer
Show-Taskmanager-Basepriority -computername svacxadmp1

<# (Get-Process note*).PriorityClass
BasePriority	Priorityclass
4	Idle
8	Normal
13	High
24	RealTime
#>

# https://github.com/controlup/script-library/blob/master/Adjust%20Process%20Priority%20based%20on%20Session%20State/Adjust%20Process%20Priority%20based%20on%20Session%20State.ps1
# https://github.com/controlup/script-library/blob/master/Process%20CPU%20Usage%20Limit/Process%20CPU%20Usage%20Limit.ps1

<#
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\tiworker.exe\PerfOptions]
"CpuPriorityClass"=dword:00000001
"IoPriority"=dword:00000000

[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\mrt.exe\PerfOptions]
"CpuPriorityClass"=dword:00000001
"IoPriority"=dword:00000000

{  New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\mrt.exe\PerfOptions" -force}
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\mrt.exe\PerfOptions' -Name 'CpuPriorityClass' -Value 1 -PropertyType DWord -Force
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\mrt.exe\PerfOptions' -Name 'IoPriority' -Value 0 -PropertyType DWord -Force

#>

# page priority - process hakcer? - https://www.raymond.cc/blog/download/did/1714/
You can set …
CpuPriorityClass 
IoPriority
PagePriority
and
WorkingSetLimitInKB

"PagePriority"=dword:00000005
;00000000 = Idle
;00000001 = Very Low
;00000002 = Low
;00000003 = Background
;00000004 = Background
;00000005 = Normal (default)

"WorkingSetLimitInKB"=dword:00001382
;00001382 is default

"CpuPriorityClass"=dword:00000002
;00000001 = Idle
;00000002 = Normal (default)
;00000003 = High
;00000004 = RealTime or normal (n.a.)
;00000005 = Below Normal
;00000006 = Above Normal
;Other values set it to normal.

"IoPriority"=dword:00000002
;00000000 = Very Low
;00000001 = Low
;00000002 = Normal (default)
;00000003 = High
;00000004 = Critical (only for memory io)





#https://docs.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-setprocessinformation
#SetProcessInformation -IoPriorityHint IoprioLow -ProcessName notepad.exe

#https://answers.microsoft.com/en-us/windows/forum/all/how-to-permanently-set-priority-processes-using/df82bd40-ce52-4b84-af34-4d93da17d079

# komplex:
# https://github.com/controlup/script-library/blob/master/Trim%20Process%20Working%20Sets/Trim%20Process%20Working%20Sets.ps1
# https://github.com/guyrleech/Microsoft/blob/master/Trimmer.ps1


function SetProcessPriorityIFEO {
    param (
        [string]$processName,
        [ValidateSet("CpuPriorityClass", "PagePriority", "IOPriority", "WorkingSetLimitInKB")]
        [string]$priorityname,
        [ValidateSet("VeryLow", "Low", "Normal", "High", "Critical")]
        [string]$IOpriorityValue,
        [ValidateSet("Idle", "Normal", "High", "Realtime", "BelowNormal", "AboveNormal")]
        [string]$CpuPriorityClassValue,
        [ValidateSet("Idle", "VeryLow", "Low", "Background3", "Background4", "Normal")]
        [string]$PagePriorityValue,
        [string]$WorkingSetLimitInKBValueHEXDecimal,
        [string]$WorkingSetLimitInKBValueDecimal
    )
    switch ($IOpriorityValue) {
        "VeryLow" {$value = 0}
        "Low" {$value = 1}
        "Normal" {$value = 2}
        "High" {$value = 3}
        "Critical" {$value = 4}
    }
    switch ($CpuPriorityClassValue) {
        "Idle" {$value = 1}
        "Normal" {$value = 2}
        "High" {$value = 3}
        "Realtime" {$value = 4}
        "BelowNormal" {$value = 5}
        "AboveNormal" {$value = 6}
    }
    switch ($PagePriorityValue) {
        "Idle" {$value = 0}
        "VeryLow" {$value = 1}
        "Low" {$value = 2}
        "Background3" {$value = 3}
        "Background4" {$value = 4}
        "Normal" {$value = 5}
    }

    $registryKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$processName\PerfOptions"
    New-Item -Path $registryKey -Force | Out-Null
    switch ($priorityname) {
        "CpuPriorityClass" {
            New-ItemProperty -LiteralPath $registryKey -Name $priorityname -Value $value -PropertyType DWord -Force
        }
        "PagePriority" {
            New-ItemProperty -LiteralPath $registryKey -Name $priorityname -Value $value -PropertyType DWord -Force
        }
        "IOPriority" {
            New-ItemProperty -LiteralPath $registryKey -Name $priorityname -Value $value -PropertyType DWord -Force
        }
        "WorkingSetLimitInKB" {
            #New-ItemProperty -LiteralPath $registryKey -Name $priorityname -Value $WorkingSetLimitInKBValueDecimal -PropertyType DWord -Force # 42
            New-ItemProperty -LiteralPath $registryKey -Name $priorityname -Value $WorkingSetLimitInKBValueHEXDecimal -PropertyType DWord -Force # 0x2A
        }
    }
}

#SetProcessPriorityIFEO -processName "mrt.exe" -priorityname "CpuPriorityClass" -CpuPriorityClassValue High
#SetProcessPriorityIFEO -processName "notepad.exe" -priorityname WorkingSetLimitInKB -WorkingSetLimitInKBValueDecimal 1328
SetProcessPriorityIFEO -processName "notepad.exe" -priorityname WorkingSetLimitInKB -WorkingSetLimitInKBValueHEXDecimal 0x2A

