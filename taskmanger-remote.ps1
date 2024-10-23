
# Definieren Sie den Remote-Server
$RemoteServer = "svacitrixpvsp01"  # Ersetzen Sie dies durch den Namen oder die IP-Adresse Ihres Remote-Servers

# Definieren Sie das Skript, das auf dem Remote-Server ausgeführt werden soll
$ScriptBlock = {
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

# Abrufen aller Prozesse ohne Filterung nach Session-ID
Get-Process -IncludeUserName |
Select-Object Username, SessionId, Responding, HasExited, PriorityClass,
             $MemoryMB, $CPUPercent, Name, Description, Product, MainWindowTitle, Path |
Sort-Object -Property Description

}

# Führen Sie den Befehl auf dem Remote-Server aus und speichern Sie die Ergebnisse lokal
$Results = Invoke-Command -ComputerName $RemoteServer -ScriptBlock $ScriptBlock

# Zeigen Sie die Ergebnisse lokal in Out-GridView an und wählen Sie einen Prozess aus
$SelectedProcess = $Results | Out-GridView -Title 'PS-Taskmanager -------- Filter mögliche!' -PassThru

# Überprüfen, ob ein Prozess ausgewählt wurde
if ($SelectedProcess -and $SelectedProcess.Name) {
   # Hinzufügen der .exe-Erweiterung zum Prozessnamen
   $ProcessNameWithExtension = "$($SelectedProcess.Name).exe"

   # Beenden des ausgewählten Prozesses auf dem Remote-Server mit TASKKILL
   Invoke-Command -ComputerName $RemoteServer -ScriptBlock {
       param ($ProcessName)  # Parameter für den Prozessnamen
       # TASKKILL-Befehl ausführen
       cmd.exe /c "taskkill /f /im $ProcessName"
   } -ArgumentList $ProcessNameWithExtension
} else {
   Write-Host "Kein Prozess ausgewählt oder der Prozess hat keinen gültigen Namen."
}
