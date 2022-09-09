$CPUPercent = @{
  Name = 'CPUPercent'
  Expression = {
    $TotalSec = (New-TimeSpan -Start $_.StartTime).TotalSeconds
    [Math]::Round( ($_.CPU * 100 / $TotalSec), 2)
  }
}
 
$MemoryMB = @{
Name = 'Memory(MB)'
Expression = {
[Math]::Round( ($_.WS / 1MB), 2)
}
}
 
Get-Process -IncludeUserName | Where-Object SessionId -eq (Get-Process -id $pid).SessionId |
select Username, SessionId, Responding, HasExited, PriorityClass, $MemoryMB, $CPUPercent, Name, Description, Product, MainWindowTitle, Path |
Sort-Object -Property Description | Out-GridView -PassThru  -Title 'PS-Taskmanager -------- Filter possible!' | Stop-Process
