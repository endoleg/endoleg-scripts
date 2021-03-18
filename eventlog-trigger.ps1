# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/register-objectevent?view=powershell-5.1
# ObjectEvent, WMIEvent, EngineEvent

# EventLog Name
$Name = 'Application'

# get Eventlog by Name
$LogInstance = [System.Diagnostics.EventLog]$Name

# Do what?
$Action = {
  # get Event
  $entry = $event.SourceEventArgs.Entry

  # Filter incoming Events 
  if ($entry.EventId -eq 999 -and $entry.Source -eq 'Userinfo') {
    Write-verbose -message "Event occurred! Do something !" -Verbose
    Start-Process notepad.exe
  }
}

#InputObject = What Log ?
#EventName = Which Event to abo ?
#SourceIdentifier = Abo-name ?
#Action = Do what?

# Abo Events with type "EntryWritten"
# For different Events safe in different variables / und SourceIdentifiers
$job1 = Register-ObjectEvent -InputObject $LogInstance -EventName EntryWritten -SourceIdentifier 'MeinEventHandler4' -Action $Action

<#
# Stop Abo
Unregister-Event -SourceIdentifier 'MeinEventHandler4'
#>

# Test Eventlog-Entry
write-eventlog -entrytype "Warning" -logname "application" -eventID 999 -Source 'Userinfo' -Category 0 -Message "Test"
