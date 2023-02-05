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
                if ($WorkingSetLimitInKBValueHEXDecimal) {
                    New-ItemProperty -LiteralPath $registryKey -Name $priorityname -Value $WorkingSetLimitInKBValueHEXDecimal -PropertyType DWord -Force # 0x2A
                } elseif ($WorkingSetLimitInKBValueDecimal) {
                    New-ItemProperty -LiteralPath $registryKey -Name $priorityname -Value $WorkingSetLimitInKBValueDecimal -PropertyType DWord -Force # 42
                }
            }    
        }
}

#SetProcessPriorityIFEO -processName "mrt.exe" -priorityname "CpuPriorityClass" -CpuPriorityClassValue High
#SetProcessPriorityIFEO -processName "notepad.exe" -priorityname WorkingSetLimitInKB -WorkingSetLimitInKBValueDecimal 1328
SetProcessPriorityIFEO -processName "notepad.exe" -priorityname WorkingSetLimitInKB -WorkingSetLimitInKBValueDecimal 41
