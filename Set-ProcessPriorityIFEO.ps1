<#
.SYNOPSIS
Manipulate the Process Priority with IFEO (registry)
IFEO is mentioned in Windows Internals book
#https://answers.microsoft.com/en-us/windows/forum/windows_10-performance/how-to-permanently-set-priority-processes-using/df82bd40-ce52-4b84-af34-4d93da17d079

.DESCRIPTION
Manipulate the Process Priority with IFEO (registry)
Image File Execution Options are registry settings that are permanent and take effect immediately, as long as they are not changed or deleted manually. 
These settings remain in effect even if the system is restarted.

.PARAMETER processName
Name of process with .exe - in the following format: processname.exe

.PARAMETER priorityname
What Priority you want to manipulate?

.PARAMETER IOpriorityValue
Special Value-Parameter used for IOpriority

.PARAMETER CpuPriorityClassValue
Special Value-Parameter used for CpuPriorityClass 

.PARAMETER PagePriorityValue
Special Value-Parameter used for PagePriority

.PARAMETER WorkingSetLimitInKBValueHEXDecimal
Special HEXDecimal-Value-Parameter (for example 0x2A) used for WorkingSetLimitInKB

.PARAMETER WorkingSetLimitInKBValueDecimal
Special Decimal-Value-Parameter used for WorkingSetLimitInKB

.EXAMPLE
Set-ProcessPriorityIFEO -processName "mrt.exe" -priorityname "CpuPriorityClass" -CpuPriorityClassValue High

.EXAMPLE
Set-ProcessPriorityIFEO -processName "notepad.exe" -priorityname WorkingSetLimitInKB -WorkingSetLimitInKBValueDecimal 1328

.EXAMPLE
Set-ProcessPriorityIFEO -processName "notepad.exe" -priorityname WorkingSetLimitInKB -WorkingSetLimitInKBValueDecimal 41

.NOTES
Image File Execution Options are registry settings that are permanent and take effect immediately, as long as they are not changed or deleted manually. 
These settings remain in effect even if the system is restarted.

Test, test and test before you use it in production!

Thorsten Enderlein, 2023
Twitter: @endi24
github: https://github.com/endoleg/
#>

function Set-ProcessPriorityIFEO {
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

<# for Remote-action
#Aufbau einer Remotesession auf einen einzugebenden Computer
$computerName = Read-Host "Computername, auf dem SetProcessPriorityIFEO ausgeführt werden soll"
$session = New-PSSession -ComputerName $computerName

#Ausfuehren eines Sciprtblocks auf dem Computer - hier: SetProcessPriorityIFEO aus ca. Zeile 123
Invoke-Command -Session $session -ScriptBlock { 
    #Block
}

#Disconnect-PSSession -Session $session
Remove-PSSession -Session $session

#>
