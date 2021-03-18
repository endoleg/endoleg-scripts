# This Script registers a new Objectevent. When a special Event Log entry occures, a action is started
# Source: https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/responding-to-new-event-log-entries-part-2

# Register-Objectevent: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/register-objectevent?view=powershell-5.1
# Register-WMIEvent: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/register-wmievent?view=powershell-5.1
# Register-EngineEvent: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/register-engineevent?view=powershell-5.1
# Wait-Event: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/wait-event?view=powershell-5.1
# https://livebook.manning.com/book/windows-powershell-in-action-second-edition/chapter-20/

##########################################################################################################################################

##########################################################################################################################################
# EventLog Name
$Name = 'Application'

# get Eventlog by Name
$LogInstance = [System.Diagnostics.EventLog]$Name

# Action to do
$Action = {
  # get Event
  $entry = $event.SourceEventArgs.Entry

  # Filter incoming Events 
  if ($entry.EventId -eq 999 -and $entry.Source -eq 'MyLog') {
    
    Write-verbose -message "Event occurred! Do something !" -Verbose
    Start-Process notepad.exe
  
  }
}
##########################################################################################################################################

# Abo Events with type "EntryWritten"
# For different Events safe in different variables / und SourceIdentifiers
# Help: InputObject => What Log - EventName => Which Event to abo - SourceIdentifier => Abo-name - Action => Do what?

$job1 = Register-ObjectEvent -InputObject $LogInstance -EventName EntryWritten -SourceIdentifier 'MyEventHandler' -Action $Action

##########################################################################################################################################

<#
  # To stop Abo use this line
  Unregister-Event -SourceIdentifier 'MyEventHandler'
  Remove-Job -Name 'MyEventHandler' -force
#>

<#
  # To register new Eventlog (only needed once) use this
  New-EventLog -LogName Application -Source ‘MyLog’
#>

##########################################################################################################################################

# Write new Eventlog to test Eventlog trigger
write-eventlog -entrytype "Warning" -logname "application" -eventID 999 -Source 'MyLog' -Category 0 -Message "Test"
