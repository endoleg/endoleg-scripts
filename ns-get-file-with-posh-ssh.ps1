Install-Module -Name Posh-SSH 

$NetscalerIP = '10.00.00.1'
$SSHSession = New-SSHSession -ComputerName $NetscalerIP

$ShellCommand = 'shell cat /var/log/nsvpn.log'
$Output = Invoke-SSHCommand -Index $($SSHSession.SessionId) -Command $ShellCommand
$Output.Output | out-file c:\windows\temp\nsvpn.log.txt -Force
start c:\windows\temp\nsvpn.log.txt

$ShellCommand = 'shell cat /flash/nsconfig/ns.conf'
$Output = Invoke-SSHCommand -Index $($SSHSession.SessionId) -Command $ShellCommand
$Output.Output | out-file c:\windows\temp\ns.conf.txt -Force
start c:\windows\temp\ns.conf.txt

$ShellCommand = 'shell cat /var/log/ns.log'
$Output = Invoke-SSHCommand -Index $($SSHSession.SessionId) -Command $ShellCommand
$Output.Output | out-file c:\windows\temp\ns.log.txt -Force
start c:\windows\temp\ns.log.txt

write-verbose -Message "Get-SSHSession" -Verbose
Get-SSHSession
Start-Sleep 3

write-verbose -Message "Remove-SSHSession" -Verbose
Remove-SSHSession -SessionId $($SSHSession.SessionId) 
Start-Sleep 3

write-verbose -Message "Get-SSHSession" -Verbose
Get-SSHSession
Start-Sleep 3
