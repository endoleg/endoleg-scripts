function Show-TaskmanagerPermanentPriorityRegistryIFEO {
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

        $Processes = $colTasklist | Sort-Object PercentProcessorTime -Desc | Out-GridView -PassThru  -Title "$($perf.PSComputerName) - Select process to manipulate"

   Invoke-Command -ComputerName  $computername -ScriptBlock {
       param($Processes) $Processes | ForEach-Object {

                function SetProcessPriorityIFEO {
                    param (
                        [Parameter(Mandatory=$true)]
                        [string]$processName,
                        [Parameter(Mandatory=$true)]
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
    
                    if (!(Test-Path -Path $registryKey)) {
                        New-Item -Path $registryKey -Force | Out-Null
                    }
    
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
                                if ($WorkingSetLimitInKBValueHEXDecimal) {
                                    New-ItemProperty -LiteralPath $registryKey -Name $priorityname -Value $WorkingSetLimitInKBValueHEXDecimal -PropertyType DWord -Force # 0x2A
                                } elseif ($WorkingSetLimitInKBValueDecimal) {
                                    New-ItemProperty -LiteralPath $registryKey -Name $priorityname -Value $WorkingSetLimitInKBValueDecimal -PropertyType DWord -Force # 42
                                }
                            }    
                        }
                }

}
   } -ArgumentList $Processes 


    }
}

#Show-TaskmanagerPermanentPriorityRegistryIFEO -computername localhost
#Show-TaskmanagerPermanentPriorityRegistryIFEO -computername remotecomputer
Show-TaskmanagerPermanentPriorityRegistryIFEO -computername svacxadmp1


# https://github.com/controlup/script-library/blob/master/Adjust%20Process%20Priority%20based%20on%20Session%20State/Adjust%20Process%20Priority%20based%20on%20Session%20State.ps1
# https://github.com/controlup/script-library/blob/master/Process%20CPU%20Usage%20Limit/Process%20CPU%20Usage%20Limit.ps1

# page priority - process hakcer? - https://www.raymond.cc/blog/download/did/1714/

#https://docs.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-setprocessinformation
#SetProcessInformation -IoPriorityHint IoprioLow -ProcessName notepad.exe

#https://answers.microsoft.com/en-us/windows/forum/all/how-to-permanently-set-priority-processes-using/df82bd40-ce52-4b84-af34-4d93da17d079

# komplex:
# https://github.com/controlup/script-library/blob/master/Trim%20Process%20Working%20Sets/Trim%20Process%20Working%20Sets.ps1
# https://github.com/guyrleech/Microsoft/blob/master/Trimmer.ps1

