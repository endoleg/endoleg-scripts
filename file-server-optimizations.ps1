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

# Konfiguriere die Anzahl der SMB-Verbindungen pro Netzwerk-Interface
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "ConnectionCountPerNetworkInterface" -Value "8" -PropertyType DWORD -Force

# Konfiguriere die Anzahl der SMB-Verbindungen pro RSS-Netzwerk-Interface
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "ConnectionCountPerRssNetworkInterface" -Value "4" -PropertyType DWORD -Force

#https://raw.githubusercontent.com/slpcat/NT6xTweaking/2c948a911f07e6d45d70b2cf85ffd6b51fdce7c0/Win/%E8%B0%83%E6%95%B4SMB%E5%8F%82%E6%95%B0.reg
# Reg2CI (c) 2022 by Roger Zander
if((Test-Path -LiteralPath "HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters") -ne $true) {  New-Item "HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" -force -ea SilentlyContinue };
if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters" -force -ea SilentlyContinue };
if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\services\mrxsmb10") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\services\mrxsmb10" -force -ea SilentlyContinue };
if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\services\mrxsmb20") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\services\mrxsmb20" -force -ea SilentlyContinue };
if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\services\LanmanWorkstation") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\services\LanmanWorkstation" -force -ea SilentlyContinue };
if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Services\MRxSmb\Parameters") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Services\MRxSmb\Parameters" -force -ea SilentlyContinue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -force -ea SilentlyContinue };
Remove-Item -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\DelegateFolders\{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -force;
if((Test-Path -LiteralPath "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa") -ne $true) {  New-Item "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -force -ea SilentlyContinue };
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'EnablePlainTextPassword' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'EnableSecuritySignature' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'KeepConn' -Value 204800 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'RequireSecuritySignature' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'ServiceDllUnloadOnStop' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'MaxCmds' -Value 32768 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'DisableBandwidthThrottling' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'DisableLargeMtu' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'ConnectionCountPerNetworkInterface' -Value 16 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'ConnectionCountPerRssNetworkInterface' -Value 16 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'ConnectionCountPerRdmaNetworkInterface' -Value 16 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'MaximumConnectionCountPerServer' -Value 64 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'DormantDirectoryTimeout' -Value 600 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'FileInfoCacheLifetime' -Value 60 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'DirectoryCacheLifetime' -Value 60 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'DirectoryCacheEntrySizeMax' -Value 65536 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'FileNotFoundCacheLifetime' -Value 5 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'CacheFileTimeout' -Value 10 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'FileInfoCacheEntriesMax' -Value 32768 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'FileNotFoundCacheEntriesMax' -Value 206696 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'DormantFileLimit' -Value 32768 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'DirectoryCacheEntriesMax' -Value 8192 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'ScavengerTimeLimit' -Value 60 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'SMB1' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'SMB2' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'EnableAuthenticateUserSharing' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'ServiceDllUnloadOnStop' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'autodisconnect' -Value -1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'enableforcedlogoff' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'enablesecuritysignature' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'IRPStackSize' -Value 48 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'requiresecuritysignature' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'restrictnullsessaccess' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'AdjustedNullSessionPipes' -Value 3 -PropertyType DWord -Force -ea SilentlyContinue;

# 禁用公用文件夹共享
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'AutoShareWks' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'AutoShareServer' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'Size' -Value 3 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'MaxWorkItems' -Value 8192 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'MaxMpxCt' -Value 32768 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'MaxRawWorkItems' -Value 512 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'MaxFreeConnections' -Value 100 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'MinFreeConnections' -Value 32 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'Smb2CreditsMin' -Value 512 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'Smb2CreditsMax' -Value 8192 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'MaxThreadsPerQueue' -Value 64 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'TreatHostAsStableStorage' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\Lanmanserver\Parameters' -Name 'SizReqBuf' -Value 25344 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\mrxsmb10' -Name 'Start' -Value 4 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\mrxsmb20' -Name 'Start' -Value 3 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\services\LanmanWorkstation' -Name 'DependOnService' -Value @("Bowser","MRxSmb20","NSI") -PropertyType MultiString -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Services\MRxSmb\Parameters' -Name 'MultiUserEnabled' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoRemoteRecursiveEvents' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name 'restrictanonymous' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name 'limitblankpassworduse' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;
