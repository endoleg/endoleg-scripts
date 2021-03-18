# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/register-objectevent?view=powershell-5.1
# ObjectEvent, WMIEvent, EngineEvent

# EventLog Name
$Name = 'Application'

# get Eventlog by Name
$LogInstance = [System.Diagnostics.EventLog]$Name

# Do what?
$Aktion = {
  # get Event
  $eintrag = $event.SourceEventArgs.Entry

  # Filter incoming Events 
  if ($eintrag.EventId -eq 0 -and $eintrag.Source -eq 'DockerService') {
    Write-Host "Event occurred! Do something !"
  }
}

#InputObject = What Log ?
#EventName = Which Event to abo ?
#SourceIdentifier = Abo-name ?
#Aktion = Do what?

# Abo Events with type "EntryWritten"
# For different Events safe in different variables / und SourceIdentifiers
$job1 = Register-ObjectEvent -InputObject $LogInstance -EventName EntryWritten -SourceIdentifier 'MeinEventHandler' -Action $Aktion

# Stop Abo
# Unregister-Event -SourceIdentifier 'MeinEventHandler'

# Test Eventlog-Entry
write-eventlog -entrytype "Warning" -logname "application" -eventID 999 -Source 'LOGXY' -Category 0 -Message "Test"
