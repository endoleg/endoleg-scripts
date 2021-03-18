# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/register-objectevent?view=powershell-5.1
# ObjectEvent, WMIEvent, EngineEvent

# Name des EventLogs
$Name = 'Application'

# Eventlog Instanz holen anhand von Name
$LogInstance = [System.Diagnostics.EventLog]$Name

# Was soll getan werden?
$Aktion = {
  # Event aus der Historie holen
  $eintrag = $event.SourceEventArgs.Entry

  # eingehende Einträge filtern
  if ($eintrag.EventId -eq 0 -and $eintrag.Source -eq 'DockerService') {
    Write-Host "Achtung! Event hat stattgefunden. Es ist an der Zeit DINGE zu tun"
  }
}

#InputObject = Was/welches Log soll ich überwachen?
#EventName = Welche Art von Event will ich Abonieren?
#SourceIdentifier = Wie soll dein 'Abo' heißen?
#Aktion = Selbsterklärend

# Events vom typ "EntryWritten" abonnieren
# Willst du verschiedene Events abonnieren speichere einfach in verschiedenen Variablen und verschiedenen SourceIdentifier
$job1 = Register-ObjectEvent -InputObject $LogInstance -EventName EntryWritten -SourceIdentifier 'MeinEventHandler' -Action $Aktion

# Um Abo zu beenden
# Unregister-Event -SourceIdentifier 'MeinEventHandler'

# Test Eventlog-Eintrag
write-eventlog -entrytype "Warning" -logname "application" -eventID 999 -Source 'BGETEM-LOG' -Category 0 -Message "Test"
