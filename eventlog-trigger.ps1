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
# Willst du verschiedene Events abonnieren speichere einfach in verschiedenen Variablen und verschiedenen SourceIdentifier
$job1 = Register-ObjectEvent -InputObject $LogInstance -EventName EntryWritten -SourceIdentifier 'MeinEventHandler' -Action $Aktion

# Um Abo zu beenden
# Unregister-Event -SourceIdentifier 'MeinEventHandler'

# Test Eventlog-Eintrag
write-eventlog -entrytype "Warning" -logname "application" -eventID 999 -Source 'BGETEM-LOG' -Category 0 -Message "Test"
