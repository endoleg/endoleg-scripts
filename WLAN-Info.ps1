  Write-Verbose -Message "netsh.exe command to get wirelss profile info" -Verbose
  $output = netsh.exe wlan show interfaces

  Write-Verbose -Message "  # Name" -Verbose
  $Name_line = $output | Select-String -Pattern 'Name'
  $Name = ($Name_line -split ":")[-1].Trim()
  $Name 

  Write-Verbose -Message "# Description" -Verbose
  $Description_line = $output | Select-String -Pattern 'Beschreibung'
  $Adaptor = ($Description_line -split ":")[-1].Trim()
  $Adaptor

  Write-Verbose -Message "# GUID" -Verbose
  $GUID_line = $output | Select-String -Pattern 'GUID'
  $GUID = ($GUID_line -split ":")[-1].Trim()
  $GUID 

<#
  Write-Verbose -Message "# State" -Verbose
  $State_line = $output | Select-String -Pattern 'Status'
  $State = ($State_line -split ":")[-1].Trim()
  $State
#>

    Write-Verbose -Message "# SSID" -Verbose
    $SSID_line = $output | Select-String 'SSID'| select -First 1
    $SSIDText = ($SSID_line -split ":")[-1].Trim()
    $SSIDText 

    Write-Verbose -Message "# BSSID" -Verbose
    $BSSID_line = $output | Select-String -Pattern 'BSSID'
    $BSSIDText = ($BSSID_line -split ":", 2)[-1].Trim()
    $BSSIDText

    Write-Verbose -Message "# NetworkType" -Verbose
    $NetworkType_line = $output | Select-String -Pattern 'Netzwerktyp'
    $NetworkType = ($NetworkType_line -split ":")[-1].Trim()
    $NetworkType

    Write-Verbose -Message "# Authentication" -Verbose
    $Authentication_line = $output | Select-String -Pattern 'Authentifizierung'
    $Auth = ($Authentication_line -split ":")[-1].Trim()
    $Auth

    Write-Verbose -Message "# Cipher" -Verbose
    $Cipher_line = $output | Select-String -Pattern 'Funktyp'
    $CipherText = ($Cipher_line -split ":")[-1].Trim()
    $CipherText


    Write-Verbose -Message "# Connection mode" -Verbose
    $Connection_line = $output | Select-String -Pattern 'Verbindungsmodus'
    $Connection = ($Connection_line -split ":")[-1].Trim()
    $Connection 

    Write-Verbose -Message "# Channel" -Verbose
    $Channel_line = $output | Select-String -Pattern 'Kanal'
    $Chan = ($Channel_line -split ":")[-1].Trim()
    $Chan

    Write-Verbose -Message "# Receive Rate" -Verbose
    $RecRate_line = $output | Select-String -Pattern 'Empfangsrate'
    $RxRate = ($RecRate_line -split ":")[-1].Trim()
    $RxRate
	
	Write-Verbose -Message "# Transmit Rate" -Verbose
    $TransRate_line = $output | Select-String -Pattern 'bertragungsrate'
    $TxRate = ($TransRate_line -split ":")[-1].Trim()
    $TxRate

    Write-Verbose -Message "# Signal (%)" -Verbose
    $SignalLevelPercent_line = $output | Select-String -Pattern 'Signal'
    $SignalLevelPercent = ($SignalLevelPercent_line -split ":")[-1].Trim()	
    $SignalLevelPercent

	Write-Verbose -Message "# Signal (dBm)" -Verbose
    $SignalLevelPercent_trimmed = $SignalLevelPercent.TrimEnd('%')
    $dBmSig = (([int]$SignalLevelPercent_trimmed)/2) - 100
	$dBmSig

    Write-Verbose -Message "# Profile" -Verbose
    $Profile_line = $output | Select-String -Pattern 'Profil'
    $Profile = ($Profile_line -split ":")[-1].Trim()
    $Profile 
