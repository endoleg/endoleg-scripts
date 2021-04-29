function GetWLANINFO
{
  Write-Verbose -Message "-- netsh.exe command to get wirelss profile info --" -Verbose
  $output = netsh.exe wlan show interfaces

  $Name_line = $output | Select-String -Pattern 'Name'
  $Name = ($Name_line -split ":")[-1].Trim()
  Write-Verbose -Message "Name: $Name " -Verbose

  $Profile_line = $output | Select-String -Pattern 'Profil'
  $Profile = ($Profile_line -split ":")[-1].Trim()
  Write-Verbose -Message "Profile: $Profile" -Verbose

  $Description_line = $output | Select-String -Pattern 'Beschreibung'
  $Adaptor = ($Description_line -split ":")[-1].Trim()
  Write-Verbose -Message "Description: $Adaptor" -Verbose

  $GUID_line = $output | Select-String -Pattern 'GUID'
  $GUID = ($GUID_line -split ":")[-1].Trim()
  Write-Verbose -Message "GUID: $GUID" -Verbose 

    Write-Verbose -Message "SSID: $SSIDText" -Verbose
    $SSID_line = $output | Select-String 'SSID'| select -First 1
    $SSIDText = ($SSID_line -split ":")[-1].Trim()    

    Write-Verbose -Message "BSSID: $BSSIDText" -Verbose
    $BSSID_line = $output | Select-String -Pattern 'BSSID'
    $BSSIDText = ($BSSID_line -split ":", 2)[-1].Trim()

    Write-Verbose -Message "NetworkType: $NetworkType" -Verbose
    $NetworkType_line = $output | Select-String -Pattern 'Netzwerktyp'
    $NetworkType = ($NetworkType_line -split ":")[-1].Trim()

    $Authentication_line = $output | Select-String -Pattern 'Authentifizierung'
    $Auth = ($Authentication_line -split ":")[-1].Trim()
    Write-Verbose -Message "Authentication: $Auth" -Verbose
    
    $Cipher_line = $output | Select-String -Pattern 'Funktyp'
    $CipherText = ($Cipher_line -split ":")[-1].Trim()
    Write-Verbose -Message "Cipher: $CipherText" -Verbose
    
    $Connection_line = $output | Select-String -Pattern 'Verbindungsmodus'
    $Connection = ($Connection_line -split ":")[-1].Trim()
    Write-Verbose -Message "Connection mode: $Connection" -Verbose
     
    $Channel_line = $output | Select-String -Pattern 'Kanal'
    $Chan = ($Channel_line -split ":")[-1].Trim()
    Write-Verbose -Message "Channel: $Chan" -Verbose
    
    $RecRate_line = $output | Select-String -Pattern 'Empfangsrate'
    $RxRate = ($RecRate_line -split ":")[-1].Trim()
    Write-Verbose -Message "Receive Rate: $RxRate" -Verbose
    
    $TransRate_line = $output | Select-String -Pattern 'bertragungsrate'
    $TxRate = ($TransRate_line -split ":")[-1].Trim()
	Write-Verbose -Message "Transmit Rate: $TxRate" -Verbose
    
    $SignalLevelPercent_line = $output | Select-String -Pattern 'Signal'
    $SignalLevelPercent = ($SignalLevelPercent_line -split ":")[-1].Trim()	
    Write-Verbose -Message "Signal (%): $SignalLevelPercent" -Verbose
    

    $SignalLevelPercent_trimmed = $SignalLevelPercent.TrimEnd('%')
    $dBmSig = (([int]$SignalLevelPercent_trimmed)/2) - 100
	Write-Verbose -Message "Signal (dBm): $dBmSig" -Verbose
	
    
}
GetWLANINFO
