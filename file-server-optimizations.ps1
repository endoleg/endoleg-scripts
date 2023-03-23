#https://learn.microsoft.com/en-us/windows-server/administration/performance-tuning/role/file-server/smb-file-server
#https://learn.microsoft.com/en-us/windows-server/administration/performance-tuning/role/file-server/

# Set the network adapter settings for maximum throughput
Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "Interrupt Moderation" -DisplayValue "Disabled"
Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "Interrupt Moderation Rate" -DisplayValue "Extreme"
Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "Jumbo Packet" -DisplayValue "9014"
Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "Large Send Offload V2 (IPv4)" -DisplayValue "Enabled"
Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "Large Send Offload V2 (IPv6)" -DisplayValue "Enabled"
Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "Maximum Number of RSS Queues" -DisplayValue "8"
Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "Receive Buffers" -DisplayValue "2048"
Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "TCP Checksum Offload (IPv4)" -DisplayValue "Rx & Tx Enabled"
Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "TCP Checksum Offload (IPv6)" -DisplayValue "Rx & Tx Enabled"
Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "UDP Checksum Offload (IPv4)" -DisplayValue "Rx & Tx Enabled"
Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "UDP Checksum Offload (IPv6)" -DisplayValue "Rx & Tx Enabled"

# Erhöhe den Timeout für den Server-Service
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SizReqBuf" -Value "16777216" -Type DWORD
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "MaxWorkItems" -Value "65535" -Type DWORD
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "MaxMpxCt" -Value "65535" -Type DWORD

# Erhöhe den Timeout für den Client-S

# Deaktiviere SMBv1
Set-SmbServerConfiguration -EnableSMB1Protocol $false

# Aktiviere SMBv2 und SMBv3
Set-SmbServerConfiguration -EnableSMB2Protocol $true
Set-SmbServerConfiguration -EnableSMB2ProtocolWithLeasing $true
Set-SmbServerConfiguration -EnableSMB3Protocol $true

# Konfiguriere Opportunistic Locking
Set-SmbServerConfiguration -EnableOplocks $true

# Aktiviere Large Send Offload (LSO)
Get-NetAdapter | Where-Object { $_.LinkSpeed -ge "1 Gbps" } | ForEach-Object { Set-NetAdapterAdvancedProperty $_.Name -DisplayName "Large Send Offload Version 2 (IPv4)" -DisplayValue "Enabled" }

# Erhöhe den Server-Cache
Set-SmbServerConfiguration -DirectoryCacheEntriesMax 2097152
Set-SmbServerConfiguration -FileInformationCacheEntriesMax 524288
Set-SmbServerConfiguration -DirectoryCacheEntrySizeMax 8192
Set-SmbServerConfiguration -FileInformationCacheEntrySizeMax 16384

# Aktiviere das SMB-Verbindungswarnprotokoll
Set-SmbServerConfiguration -EnableSessionInfoRecording $true

# Konfiguriere die Übertragungsgröße
Set-SmbServerConfiguration -MaxSendIoSize 1048576
Set-SmbServerConfiguration -MaxReceiveIoSize 1048576

# Aktiviere SMB Direct
Enable-NetAdapterRdma

# Konfiguriere SMB Multichannel
Set-SmbServerConfiguration -EnableMultiChannel $true

# Konfiguriere SMB Bandbreitenbegrenzung
Set-SmbBandwidthLimit -Category Default -BytesPerSecond 50000000

# Aktiviere SMB Leasing
Set-SmbServerConfiguration -EnableLeasing $true

# Aktiviere SMB-Verschlüsselung
Set-SmbServerConfiguration -EncryptData $true

# Aktiviere SMB-Verbindungsdiagnose
Set-SmbServerConfiguration -EnableConnectionTableEntry $true

# Konfiguriere SMB-Drosselung
Set-SmbServerConfiguration -ConnectionLimitPerIP $500

# Aktiviere SMB-Datendeduplizierung
Enable-DedupVolume -Volume <volume letter>

# Aktiviere SMB-Transparente Verarbeitung
Set-SmbServerConfiguration -EnableTransparentCompression $true
Set-SmbServerConfiguration -EnableTransparentCache $true

# Aktiviere Large Send Offload (LSO)
Get-NetAdapter | Where-Object { $_.LinkSpeed -ge "1 Gbps" } | ForEach-Object { Set-NetAdapterAdvancedProperty $_.Name -DisplayName "Large Send Offload Version 2 (IPv4)" -DisplayValue "Enabled" }

# Erhöhe den Server-Cache
Set-SmbServerConfiguration -DirectoryCacheEntriesMax 2097152
Set-SmbServerConfiguration -FileInformationCacheEntriesMax 524288
Set-SmbServerConfiguration -DirectoryCacheEntrySizeMax 8192
Set-SmbServerConfiguration -FileInformationCacheEntrySizeMax 16384

# Konfiguriere Opportunistic Locking
Set-SmbServerConfiguration -EnableOplocks $true

# Aktiviere SMB-Verschlüsselung
Set-SmbServerConfiguration -EncryptData $true

# Aktiviere SMB-Verbindungsdiagnose
Set-SmbServerConfiguration -EnableConnectionTableEntry $true

# Aktiviere das SMB-Verbindungswarnprotokoll
Set-SmbServerConfiguration -EnableSessionInfoRecording $true

# Konfiguriere SMB-Drosselung
Set-SmbServerConfiguration -ConnectionLimitPerIP $500

# Aktiviere SMB-Transparente Verarbeitung
Set-SmbServerConfiguration -EnableTransparentCompression $true
Set-SmbServerConfiguration -EnableTransparentCache $true

# Aktiviere BranchCache für den Dateiserver
Enable-BCLocal
