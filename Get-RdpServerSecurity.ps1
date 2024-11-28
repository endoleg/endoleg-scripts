##############################################################################
#.SYNOPSIS
# Get the security-related RDP server settings.
#
#.DESCRIPTION
# Get the security-related Remote Desktop Protocol server settings, such as 
# minimum encryption level, encryption type, and whether NLA is required. 
# Requires access to WMI service and membership in the local Administrators 
# group at the target. 
#
#.PARAMETER ComputerName
# One or more hostnames, FQDNs, or IP addresses.  Defaults to localhost.
#
#.NOTES
# To interpret the output properties, search the Internet for the term 
# "Win32_TSGeneralSetting" and the terms "rdp security layer tls" and also
# for "rdp network level authentication nla".
#
# Some of the possible property values are:
#
#    EncryptionLevel: Low, ClientCompatible, High, FIPS
#
#    SecurityLayer: NativeRDP, Negotiate, TLS, NEWTBD
#
#    RequireNLA: True, False
#
# Legal: 0BSD.  
#
# Author: Enclave Consulting LLC (https://www.sans.org/sec505)
#
# Version: 1.1
#
##############################################################################


[CmdletBinding()]
Param ( [String[]] $ComputerName = @("localhost") ) 

ForEach ($Computer in $ComputerName)
{

# Create a hashtable for the return:
$out = [Ordered] @{ ComputerName = $Computer.ToUpper();
                    DnsName = $null; IP = $null; EncryptionLevel = $null; SecurityLayer = $null; 
                    Protocol =$null; RequireNLA = $null; CertificateStatus =$null; CertificateHash = $null
                  }


# Try to resolve name and extract IP:
Try { $fqdn = [System.Net.Dns]::GetHostByName($Computer) } 
Catch { $IP = "CouldNotResolveName" } 

if ($IP -eq "CouldNotResolveName")
{ 
    $out.DnsName = "CouldNotResolveName" 
    $out.IP = "CouldNotResolveName"
} 
else
{ 
    $out.DnsName = $fqdn.HostName.ToLower()
    $out.IP = ($fqdn.AddressList)[0]
}



# To connect to the \root\CIMV2\TerminalServices namespace, the 
# authentication level must be PacketPrivacy:
Try 
{
  $ts = Get-WmiObject -Query "Select * From Win32_TSGeneralSetting" -Namespace root\CIMv2\TerminalServices -ComputerName $Computer -Authentication PacketPrivacy 
}
Catch
{
    Write-Verbose "ERROR: Failed to query $Computer"
    Continue #to next $Computer
}


switch ($ts.MinEncryptionLevel)
{
    1 { $out.EncryptionLevel = "Low" }               #56-bit for client-to-server, plaintext for server-to-client
    2 { $out.EncryptionLevel = "ClientCompatible" }  #Largest key supported by client
    3 { $out.EncryptionLevel = "High" }              #At least a 128-bit key
    4 { $out.EncryptionLevel = "FIPS" }              #Federal Information Processing Standard
}


switch ($ts.SecurityLayer)
{
    0 { $out.SecurityLayer = "NativeRDP" } #Default
    1 { $out.SecurityLayer = "Negotiate" } #TLS preferred, NativeRDP acceptable
    2 { $out.SecurityLayer = "TLS" }       #SSL (TLS 1.0) only, no NativeRDP
    3 { $out.SecurityLayer = "NEWTBD" }    #Research this Jason...

}


switch ($ts.SSLCertificateSHA1HashType)
{
    0 { $out.CertificateStatus = "NotValid" } 
    1 { $out.CertificateStatus = "DefaultSelfSigned" } 
    2 { $out.CertificateStatus = "GroupPolicyDefined" } 
    3 { $out.CertificateStatus = "Custom" } #Configured explicitly or directly, not auto.
}


switch ($ts.UserAuthenticationRequired)
{
    1 { $out.RequireNLA = $True  }
    0 { $out.RequireNLA = $False }
}



$out.Protocol = $ts.TerminalProtocol
$out.CertificateHash = $ts.SSLCertificateSHA1Hash


#Emit and move on to next machine:
$out 

}#END.FOREACH




# RDP Checks
    Write-host ""
    Write-host "##########################"
    Write-host "# Now checking RDP stuff #"
    Write-host "##########################"
    Write-host "References: https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.TerminalServer::TS_SECURITY_LAYER_POLICY" -ForegroundColor DarkGray
    Write-host "References: https://viperone.gitbook.io/pentest-everything/everything/everything-active-directory/adversary-in-the-middle/rdp-mitm" -ForegroundColor DarkGray
    Write-host "References: https://www.tenable.com/plugins/nessus/18405" -ForegroundColor DarkGray
    Write-host ""

    # Check if RDP is enabled
    $rdpEnabled = Get-CimInstance -Namespace "root/CIMv2/TerminalServices" -ClassName "Win32_TerminalServiceSetting" | Select-Object -ExpandProperty AllowTSConnections
    if ($rdpEnabled -eq 1) {
        Write-Host "Remote Desktop is enabled." -ForegroundColor Magenta
        $rdp_enabled = 1
    } else {
        Write-Host "Remote Desktop is disabled." -ForegroundColor Green
        $rdp_enabled = 0
    }

    # Check Security Settings for RDP
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
    $securityLayer = (Get-ItemProperty -Path $regPath -Name "SecurityLayer").SecurityLayer
    switch ($securityLayer) {
        0 {
            Write-Host "RDP Security Layer: Disabled" -ForegroundColor Red
            $rdp_sec = 2
            break
        }
        1 {
            Write-Host "RDP Security Layer: Negotiate" -ForegroundColor Magenta
            $rdp_sec = 1
            break
        }
        2 {
            Write-Host "RDP Security Layer: SSL" -ForegroundColor Green
            $rdp_sec = 0
            break
        }
        default {
            Write-Host "RDP Security Layer: Unknown" -ForegroundColor Yellow
            $rdp_sec = 3
            break
        }
    }



    ####################



<#
#prüft, ob der Remotedesktop-Dienst auf automatisch steht und läuft. Falls nicht, wird dies korrigiert:

# Dienst-Name für Remotedesktop
$serviceName = "TermService"

# Prüfe den aktuellen Status des Dienstes
$service = Get-Service -Name $serviceName

# Prüfe, ob der Dienst auf automatisch steht
if ($service.StartType -ne "Automatic") {
    Set-Service -Name $serviceName -StartupType Automatic
    Write-Host "Remotedesktop-Dienst wurde auf automatisch gesetzt."
}

# Prüfe, ob der Dienst läuft
if ($service.Status -ne "Running") {
    Start-Service -Name $serviceName
    Write-Host "Remotedesktop-Dienst wurde gestartet."
}

# Abschließende Statusmeldung
$updatedService = Get-Service -Name $serviceName
Write-Host "Remotedesktop-Dienst Status: $($updatedService.Status), Starttyp: $($updatedService.StartType)"
#>


<#
#    Using MS PowerShell to Set RDP Access Settings on Remote Computer 
#    Sets a registry setting on a remote computer to allow RDP access
#    Enter the server name when prompted 
#    Requires WinRM to access the remote machine/s and rights on that machine

$Server=Read-Host "Enter ServerName"

invoke-command $Server -Scriptblock {

     Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0

}
#>



Write-Host ""
Write-Host ""
Write-Host ""


Write-Host " NLA------------------------------------------------------------------------------------------"
# Definiere die beiden möglichen Registry-Pfade
$path1 = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
$path2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"

# Funktion zum Überprüfen des NLA-Status
function Check-NLA($path) {
    if (Test-Path $path) {
        $value = (Get-ItemProperty $path).UserAuthentication
        return @{
            Value = $value
            Path = $path
        }
    }
    return $null
}

# Überprüfe beide Pfade
$nla1 = Check-NLA $path1
$nla2 = Check-NLA $path2

# Bestimme die effektive NLA-Einstellung
if ($null -ne $nla2) {
    $nla = $nla2
    $effectivePath = $path2
} else {
    $nla = $nla1
    $effectivePath = $path1
}

# Ausgabe der Ergebnisse
if ($null -eq $nla -or $nla.Value -ne 1) {
    Write-Host "[*] UserAuthentication (NLA)`t: NLA ist nicht erforderlich. Empfohlene Einstellung ist '1'" -ForegroundColor Red
} else {
    Write-Host "[*] UserAuthentication (NLA) `t: NLA ist erforderlich" -ForegroundColor Green
}

Write-Host "`nWerte in den Registry-Pfaden:"
if ($null -ne $nla1) {
    Write-Host "- $($path1): $($nla1.Value)"
} else {
    Write-Host "- $($path1): Nicht gesetzt"
}
if ($null -ne $nla2) {
    Write-Host "- $($path2): $($nla2.Value)"
} else {
    Write-Host "- $($path2): Nicht gesetzt"
}

Write-Host "`nEffektiver Wert für UserAuthentication (NLA) wird verwendet von: $effectivePath"
Write-Host "------------------------------------------------------------------------------------------"


Write-Host ""
Write-Host ""

Write-Host " MinEncryptionLevel------------------------------------------------------------------------------------------"
# Definiere die beiden möglichen Registry-Pfade
$path1 = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
$path2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"

# Funktion zum Überprüfen der Verschlüsselungsebene
function Check-EncryptionLevel($path) {
    if (Test-Path $path) {
        return (Get-ItemProperty $path).MinEncryptionLevel
    }
    return $null
}

# Überprüfe beide Pfade
$encryption1 = Check-EncryptionLevel $path1
$encryption2 = Check-EncryptionLevel $path2

# Bestimme die effektive Verschlüsselungsebene
$encryption = if ($null -ne $encryption2) { $encryption2 } else { $encryption1 }
$effectivePath = if ($null -ne $encryption2) { $path2 } else { $path1 }

# Ausgabe der Ergebnisse
if ($null -eq $encryption -or $encryption -le 2) {
    Write-Host "[*] MinEncryptionLevel`t`t: Nicht auf 'High' oder 'FIPS-Compliant' gesetzt. Empfohlene Einstellung ist '3' oder '4'" -ForegroundColor Red
} elseif ($encryption -eq 3) {
    Write-Host "[*] MinEncryptionLevel`t`t: Sie verwenden 'High' (3), dies ist akzeptabel" -ForegroundColor Green
} elseif ($encryption -eq 4) {
    Write-Host "[*] MinEncryptionLevel`t`t: Sie verwenden 'FIPS-Compliant' (4), dies wird empfohlen" -ForegroundColor Green
}

Write-Host "`nWerte in den Registry-Pfaden:"
Write-Host "- $($path1): $(if ($null -ne $encryption1) { $encryption1 } else { 'Nicht gesetzt' })"
Write-Host "- $($path2): $(if ($null -ne $encryption2) { $encryption2 } else { 'Nicht gesetzt' })"

Write-Host "`nEffektiver Wert für MinEncryptionLevel wird verwendet von: $effectivePath"
Write-Host "------------------------------------------------------------------------------------------"


Write-Host ""
Write-Host ""
Write-Host " SecurityLayer------------------------------------------------------------------------------------------"


# Definiere die beiden möglichen Registry-Pfade
$path1 = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
$path2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"

# Funktion zum Überprüfen der SecurityLayer
function Check-SecurityLayer($path) {
    if (Test-Path $path) {
        return (Get-ItemProperty $path).SecurityLayer
    }
    return $null
}

# Überprüfe beide Pfade
$tlsImplementation1 = Check-SecurityLayer $path1
$tlsImplementation2 = Check-SecurityLayer $path2

# Bestimme die effektive SecurityLayer-Einstellung
$tlsImplementation = if ($null -ne $tlsImplementation2) { $tlsImplementation2 } else { $tlsImplementation1 }
$effectivePath = if ($null -ne $tlsImplementation2) { $path2 } else { $path1 }

# Ausgabe der Ergebnisse
if ($null -eq $tlsImplementation -or $tlsImplementation -ne 2) {
    Write-Host "[*] SecurityLayer`t`t: Wurde nicht auf 'High' gesetzt. Empfohlene Einstellung ist '2'" -ForegroundColor Red
} else {
    Write-Host "[*] SecurityLayer`t`t: Sie verwenden die sicherste TLS-Implementierung. (2)" -ForegroundColor Green
}

Write-Host "`nWerte in den Registry-Pfaden:"
Write-Host "- $($path1): $(if ($null -ne $tlsImplementation1) { $tlsImplementation1 } else { 'Nicht gesetzt' })"
Write-Host "- $($path2): $(if ($null -ne $tlsImplementation2) { $tlsImplementation2 } else { 'Nicht gesetzt' })"

Write-Host "`nEffektiver Wert für SecurityLayer wird verwendet von: $effectivePath"

# Erklärung der Werte
Write-Host "`nErklärung der Werte:"
Write-Host "0 - 'Low' Sicherheit"
Write-Host "1 - 'Medium' Sicherheit (Standard)"
Write-Host "2 - 'High' Sicherheit (empfohlen)"

Write-Host ""

Write-Host "------------------------------------------------------------------------------------------"
Write-Host ""
# Check if the PortNumber is not 3389
$port = (Get-ItemProperty  HKLM:\SYSTEM\CurrentControlSet\Control\Termin*Server\WinStations\RDP*CP\).PortNumber
if ( $port -eq 3389 )
{
    Write-Output "[*] PortNumber  `t`t: Malware will look for 3389 by default. Consider altering this."
} 
else 
{
    Write-Output "[*] PortNumber  `t`t: Congratulations you have modified the default port."
}
Write-Host ""

Write-Host ""
Write-Host "------------------------------------------------------------------------------------------"
Write-Host ""
Write-Host "https://www.mvps.net/docs/how-to-secure-remote-desktop-rdp/"
Write-Host "https://raw.githubusercontent.com/cornerpirate/rdp-enum/refs/heads/main/rdp-enum.ps1"
Write-Host ""
Write-Host ""
