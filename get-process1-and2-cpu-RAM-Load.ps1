
$Logfile = "C:\Windows\Temp\$processname-" + (Get-Date).Tostring("yyyy-MMMM-dd_HH-mm") + ".log" 
Start-Transcript -Path $logfile #-Append

$Zeit=(get-Date)


$blockTemp2 = {
    $Cores = (Get-WmiObject -class win32_processor -Property numberOfCores).numberOfCores;
    $LogicalProcessors = (Get-WmiObject –class Win32_processor -Property NumberOfLogicalProcessors).NumberOfLogicalProcessors;
    $TotalMemory = (get-ciminstance -class "cim_physicalmemory" | % {$_.Capacity})

    #Edge
    $DATA2=get-process -name msedg* -IncludeUserName | select @{Name='CPU_Usage%'; Expression = { $TotalSec = (New-TimeSpan -Start $_.StartTime).TotalSeconds
            [Math]::Round( ($_.CPU * 100 / $TotalSec) /$LogicalProcessors, 2) }}, WorkingSet, PrivateMemorySize, UserName, ProcessName, Path

    $DATA2  | Sort-Object UserName | group Username | Format-Table -Wrap  

    
 }

$blockTemp3 = {
    $Cores = (Get-WmiObject -class win32_processor -Property numberOfCores).numberOfCores;
    $LogicalProcessors = (Get-WmiObject –class Win32_processor -Property NumberOfLogicalProcessors).NumberOfLogicalProcessors;
    $TotalMemory = (get-ciminstance -class "cim_physicalmemory" | % {$_.Capacity})

    $DATA3=get-process winwor* -IncludeUserName | select `
    WorkingSet, PrivateMemorySize,`
    @{Name='CPU_Usage%'; Expression = { $TotalSec = (New-TimeSpan -Start $_.StartTime).TotalSeconds
            [Math]::Round( ($_.CPU * 100 / $TotalSec) /$LogicalProcessors, 2) }},`

    UserName, ProcessName, Path 

    $DATA3 | Sort-Object UserName | group Username | Format-Table -Wrap  


 }



#Prod 
for($i=101;$i -lt 110;$i++)
{
    $name = "computer$i"
    Write-verbose -message "----------------------------------------------------------------" -verbose
    Write-verbose -message "----------------------------------------------------------------" -verbose
    Write-verbose -message "------ Pruefung auf $name ------" -verbose
    Write-verbose -message "----------------------------------------------------------------" -verbose
    Write-verbose -message "----------------------------------------------------------------" -verbose

#Blocktemp2 
    Invoke-Command -ComputerName $name -ScriptBlock $blockTemp2

#Blocktemp3 
    Invoke-Command -ComputerName $name -ScriptBlock $blockTemp3

}

Stop-Transcript
