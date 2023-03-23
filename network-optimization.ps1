<#
Dieses Skript enthält verschiedene Befehle zur Konfiguration von TCP-Einstellungen in einem Windows-Betriebssystem.
Die ersten beiden Befehle setzen die Einstellungen für "InternetCustom" und "DataCenterCustom", um die DCTCP-Kongestionskontrolle zu verwenden, Time-Stamps zu aktivieren, den Initial-RTO auf 1000 ms zu setzen, ForceWS zu aktivieren und den Memory-Pressure-Schutz zu aktivieren.
Die nächsten vier Befehle setzen spezifische Einstellungen für "InternetCustom" und "DataCenterCustom", die auf dem Windows Server 2012 basieren. Diese Einstellungen umfassen die Größe des Initial-Congestion-Fensters, die Verzögerungszeit für Acknowledgements und die Häufigkeit von Verzögerungs-Acknowledgements.
Die restlichen Befehle verwenden den "netsh" Befehl, um weitere TCP-Einstellungen zu konfigurieren, einschließlich der Aktivierung von experimentellem Autotuning, DCA und ECN-Fähigkeit, Deaktivierung von NetDMA, Aktivierung von Non-SACK-RTT-Resilienz, Aktivierung von Fast-Open, Festlegung des Pacing-Profils auf "always", Aktivierung von Heuristiken für das Windows-Scaling und ForceWS sowie Aktivierung des Memory-Pressure-Schutzes für einen bestimmten Portbereich.
Insgesamt zielt dieses Skript darauf ab, die TCP-Einstellungen für bessere Leistung und Stabilität zu optimieren, sowohl für den Einsatz in normalen Internetumgebungen als auch in Rechenzentren.
#>

# Konfiguration der TCP-Einstellungen für bessere Leistung und Stabilität

# InternetCustom Einstellungen
Set-NetTCPSetting -SettingName InternetCustom -CongestionProvider DCTCP  # Verwendung der DCTCP-Kongestionskontrolle
Set-NetTCPSetting -SettingName InternetCustom -Timestamps enabled  # Aktivierung von Time-Stamps
Set-NetTCPSetting -SettingName InternetCustom -InitialRto 1000  # Setzen des Initial-RTO auf 1000 ms
Set-NetTCPSetting -SettingName InternetCustom -ForceWS enabled  # Aktivierung von ForceWS
Set-NetTCPSetting -SettingName InternetCustom -MemoryPressureProtection enabled  # Aktivierung des Memory-Pressure-Schutzes

# DataCenterCustom Einstellungen
Set-NetTCPSetting -SettingName DataCenterCustom -CongestionProvider DCTCP  # Verwendung der DCTCP-Kongestionskontrolle
Set-NetTCPSetting -SettingName DataCenterCustom -Timestamps enabled  # Aktivierung von Time-Stamps
Set-NetTCPSetting -SettingName DataCenterCustom -InitialRto 1000  # Setzen des Initial-RTO auf 1000 ms
Set-NetTCPSetting -SettingName DataCenterCustom -ForceWS enabled  # Aktivierung von ForceWS
Set-NetTCPSetting -SettingName DataCenterCustom -MemoryPressureProtection enabled  # Aktivierung des Memory-Pressure-Schutzes

# Windows Server 2012 Einstellungen
# Diese Einstellungen gelten nur für Windows Server 2012 und beeinflussen die Größe des Initial-Congestion-Fensters,
# die Verzögerungszeit für Acknowledgements und die Häufigkeit von Verzögerungs-Acknowledgements.

# InternetCustom Einstellungen für Windows Server 2012
Set-NetTCPSetting -SettingName InternetCustom -InitialCongestionWindow 10  # Setzen der Größe des Initial-Congestion-Fensters auf 10
Set-NetTCPSetting -SettingName InternetCustom -DelayedAckTimeoutMs 10  # Setzen der Verzögerungszeit für Acknowledgements auf 10 ms
Set-NetTCPSetting -SettingName InternetCustom -DelayedAckFreq 1  # Setzen der Häufigkeit von Verzögerungs-Acknowledgements auf 1

# DataCenterCustom Einstellungen für Windows Server 2012
Set-NetTCPSetting -SettingName DataCenterCustom -InitialCongestionWindow 10  # Setzen der Größe des Initial-Congestion-Fensters auf 10
Set-NetTCPSetting -SettingName DataCenterCustom -DelayedAckTimeoutMs 10  # Setzen der Verzögerungszeit für Acknowledgements auf 10 ms
Set-NetTCPSetting -SettingName DataCenterCustom -DelayedAckFreq 1  # Setzen der Häufigkeit von Verzögerungs-Acknowledgements auf 1

# Weitere TCP-Einstellungen
# Diese Befehle verwenden den "netsh" Befehl, um weitere TCP-Einstellungen zu konfigurieren, die für eine bessere Leistung und Stabilität sorgen sollen.

netsh int tcp set global autotuninglevel=experimental # Dieser Befehl aktiviert das experimentelle Auto-Tuning für TCP auf globaler Ebene. Dadurch wird die Übertragungsrate für Datenverbindungen automatisch optimiert.
netsh int tcp set global dca=enabled # Hiermit wird die Data Center Bridging Capability Exchange (DCB) aktiviert, die für den Datenaustausch zwischen Servern in Rechenzentren eingesetzt wird.
netsh int tcp set global ecncapability=enabled # Durch die Aktivierung der Explicit Congestion Notification (ECN) kann das Netzwerk Staus erkennen und den Datenverkehr besser regulieren.
netsh int tcp set global netdma=disabled # Der Network Direct Memory Access (NetDMA) ermöglicht es Netzwerkadaptern, auf den Arbeitsspeicher zuzugreifen, ohne dass der Prozessor involviert ist. Mit diesem Befehl wird NetDMA deaktiviert.
netsh int tcp set global nonsackrttresiliency=enabled # Hiermit wird die Resilienz von TCP-Verbindungen verbessert, indem eine Alternative für SACK-basierte Wiederherstellungsmechanismen genutzt wird, wenn diese nicht verfügbar sind.
netsh int tcp set global initialrto=1000 # Dieser Befehl legt den Initial Retransmission Time Out (RTO) Wert auf 1000 Millisekunden fest. Dies ist die Zeit, die TCP wartet, bevor es versucht, ein erneut gesendetes Datenpaket zu übertragen.
netsh int tcp set global rss=enabled # Receive Side Scaling (RSS) verbessert die TCP-Verbindung durch eine bessere Lastverteilung auf die verfügbaren CPU-Kerne.
netsh int tcp set global rsc=enabled # Die Receive Segment Coalescing (RSC) kombiniert mehrere Segmente von Datenpaketen zu einem einzigen Segment. Dadurch werden Overhead-Kosten für die Übertragung reduziert.
netsh int tcp set global fastopen=enabled # Hiermit wird das TCP Fast Open Protokoll aktiviert, welches die Verbindungsaufbauzeit von TCP-Verbindungen reduziert.
netsh int tcp set global pacingprofile=always # Der Pacing-Algorithmus von TCP kann genutzt werden, um den Datenaustausch besser zu regulieren und Überlastungen des Netzwerks zu vermeiden. Mit diesem Befehl wird Pacing auf "always" gesetzt.
netsh int tcp set heuristics wsh=enabled forcews=enabled # Der Befehl aktiviert die Windows Scaling Heuristik (WSH) und die Forced Windows Scaling (FWS) für die TCP-Verbindungen. WSH erhöht die TCP-Übertragungsgeschwindigkeit, während FWS sicherstellt, dass das Maximum Segment Size (MSS) für alle TCP-Verbindungen gleich bleibt.
netsh int tcp set security mpp=enabled startport=1024 numberofports=64500 # Hiermit wird das Memory Pressure Protection (MPP) für TCP aktiviert, welches gegen Denial-of-Service-Angriffe schützt, die den Arbeitsspeicher des Systems überlasten. 
