<#
.SYNOPSIS
Kill Process with Powershell remotly or on localhost
.DESCRIPTION
Kill Process with Powershell remotly or on localhost

.PARAMETER computername
Remote-Computername to scan for processes

.EXAMPLE
Show-Taskkiller -computername remotecomputer

.EXAMPLE
Show-Taskkiller -computername localhost

.NOTES
Test, test and test before you use it in production!

Thorsten Enderlein, 2023
Twitter: @endi24
github: https://github.com/endoleg/
#>

function Show-Taskkiller {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true,ValueFromPipeline=$false)]
        [string]$computername
    )

   process{

        $ProcessArray = Get-Process -IncludeUserName
        $CIMProcesses = Get-CimInstance -class win32_Process
        $CIMServices = Get-CIMinstance -class Win32_Service        
        $PerfProcArray = Get-CIMinstance -class Win32_PerfFormattedData_PerfProc_Process

        foreach ($Process in $ProcessArray){
            
            $Services = $CIMServices | Where-Object ProcessID -eq $Process.ID 
            $Services = $Services.PathName -Join "; "
            
            $CommandLine = $CIMProcesses | Where-Object ProcessID -eq $Process.ID | Select-Object -ExpandProperty CommandLine
            $PercentProcessorTime = $PerfProcArray | Where-Object IDProcess -eq $Process.ID | Select-Object -ExpandProperty PercentProcessorTime
            $MemoryMB = $PerfProcArray | Where-Object IDProcess -eq $Process.ID | Select-Object -ExpandProperty workingSetPrivate
            $MemoryMB = try {[Math]::Round(($MemoryMB / 1mb),2)} Catch{}

            $Process | Add-Member -MemberType NoteProperty -Name "Host" -Value $env:COMPUTERNAME
            $Process | Add-Member -MemberType NoteProperty -Name "DateScanned" -Value $DateScanned
            $Process | Add-Member -MemberType NoteProperty -Name "CommandLine" -Value $CommandLine
            $Process | Add-Member -MemberType NoteProperty -Name "Services" -Value $Services
            $Process | Add-Member -MemberType NoteProperty -Name "PercentProcessorTime" -Value $PercentProcessorTime
            $Process | Add-Member -MemberType NoteProperty -Name "MemoryMB" -Value $MemoryMB
            $Process | Add-Member -MemberType NoteProperty -Name "ModuleCount" -Value @($Process.Modules).Count
            $Process | Add-Member -MemberType NoteProperty -Name "ThreadCount" -Value @($Process.Threads).Count
        }

           $Processes =  $ProcessArray | Select-Object Host, DateScanned, CommandLine, Services, UserName, PercentProcessorTime, MemoryMB, BasePriority, Id, MainWindowHandle, MainWindowTitle, PriorityBoostEnabled, PriorityClass, PrivateMemorySize, PrivilegedProcessorTime, ProcessName, Responding, SessionId, StartTime, TotalProcessorTime, UserProcessorTime, Company, CPU, Description, FileVersion, Path, Product, ProductVersion, ModuleCount, ThreadCount, HandleCount | Out-GridView -PassThru  -Title "$($perf.PSComputerName) - Select process to kill"
           Invoke-Command -ComputerName  svacxa -ScriptBlock {param($Processes) $Processes | ForEach-Object {Stop-Process -Id $Processes.ProcessId -force  }} -ArgumentList $Processes 

    }

}

#Show-Taskkiller -computername localhost
#Show-Taskkiller -computername remotecomputer
