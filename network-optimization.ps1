<#
Dieses Skript enthält verschiedene Befehle zur Konfiguration von TCP-Einstellungen in einem Windows-Betriebssystem.
Die ersten beiden Befehle setzen die Einstellungen für "InternetCustom" und "DataCenterCustom", um die DCTCP-Kongestionskontrolle zu verwenden, Time-Stamps zu aktivieren, den Initial-RTO auf 1000 ms zu setzen, ForceWS zu aktivieren und den Memory-Pressure-Schutz zu aktivieren.
Die nächsten vier Befehle setzen spezifische Einstellungen für "InternetCustom" und "DataCenterCustom", die auf dem Windows Server 2012 basieren. Diese Einstellungen umfassen die Größe des Initial-Congestion-Fensters, die Verzögerungszeit für Acknowledgements und die Häufigkeit von Verzögerungs-Acknowledgements.
Die restlichen Befehle verwenden den "netsh" Befehl, um weitere TCP-Einstellungen zu konfigurieren, einschließlich der Aktivierung von experimentellem Autotuning, DCA und ECN-Fähigkeit, Deaktivierung von NetDMA, Aktivierung von Non-SACK-RTT-Resilienz, Aktivierung von Fast-Open, Festlegung des Pacing-Profils auf "always", Aktivierung von Heuristiken für das Windows-Scaling und ForceWS sowie Aktivierung des Memory-Pressure-Schutzes für einen bestimmten Portbereich.
Insgesamt zielt dieses Skript darauf ab, die TCP-Einstellungen für bessere Leistung und Stabilität zu optimieren, sowohl für den Einsatz in normalen Internetumgebungen als auch in Rechenzentren.
#>

Set-NetTCPSetting -SettingName InternetCustom -CongestionProvider DCTCP
Set-NetTCPSetting -SettingName InternetCustom -Timestamps enabled
Set-NetTCPSetting -SettingName InternetCustom -InitialRto 1000
Set-NetTCPSetting -SettingName InternetCustom -ForceWS enabled
Set-NetTCPSetting -SettingName InternetCustom -MemoryPressureProtection enabled

Set-NetTCPSetting -SettingName DataCenterCustom -CongestionProvider DCTCP
Set-NetTCPSetting -SettingName DataCenterCustom -Timestamps enabled
Set-NetTCPSetting -SettingName DataCenterCustom -InitialRto 1000
Set-NetTCPSetting -SettingName DataCenterCustom -ForceWS enabled
Set-NetTCPSetting -SettingName DataCenterCustom -MemoryPressureProtection enabled
 
#win2012
Set-NetTCPSetting -SettingName InternetCustom -InitialCongestionWindow 10
Set-NetTCPSetting -SettingName InternetCustom -DelayedAckTimeoutMs 10
Set-NetTCPSetting -SettingName InternetCustom -DelayedAckFreq 1

Set-NetTCPSetting -SettingName DataCenterCustom -InitialCongestionWindow 10
Set-NetTCPSetting -SettingName DataCenterCustom -DelayedAckTimeoutMs 10
Set-NetTCPSetting -SettingName DataCenterCustom -DelayedAckFreq 1

netsh int tcp set global autotuninglevel=experimental
netsh int tcp set global dca=enabled
netsh int tcp set global ecncapability=enabled
netsh int tcp set global netdma=disabled
netsh int tcp set global nonsackrttresiliency=enabled
netsh int tcp set global initialrto=1000
netsh int tcp set global rss=enabled
netsh int tcp set global rsc=enabled
netsh int tcp set global fastopen=enabled
netsh int tcp set global pacingprofile=always
netsh int tcp set heuristics wsh=enabled forcews=enabled
netsh int tcp set security mpp=enabled startport=1024 numberofports=64500
