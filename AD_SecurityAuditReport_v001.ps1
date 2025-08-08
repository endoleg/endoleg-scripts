# AD_SecurityAuditReport_Improved_v3.ps1
# Active Directory Sicherheitsaudit-Skript mit Fehlerkorrekturen, Live-Ticker und optimierter SYSVOL-Prüfung
# Erstellt am: 08.08.2025

# Prüfen und Installieren der erforderlichen Module
$requiredModules = @("ActiveDirectory", "PSWriteHTML")
$useCSVFallback = $false
foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Warning "Modul $module ist nicht installiert. Versuche, es zu installieren..."
        try {
            Install-Module -Name $module -Scope CurrentUser -Force -SkipPublisherCheck -ErrorAction Stop
            Write-Host "Modul $module erfolgreich installiert." -ForegroundColor Green
        } catch {
            Write-Warning "Fehler beim Installieren von $module $_"
            if ($module -eq "PSWriteHTML") {
                Write-Warning "Fahre mit CSV-Export fort, da PSWriteHTML nicht verfügbar ist."
                $useCSVFallback = $true
            } else {
                Write-Error "Kritisches Modul $module fehlt. Skript wird abgebrochen."
                exit
            }
        }
    }
    try {
        Import-Module $module -ErrorAction Stop
        Write-Host "Modul $module erfolgreich geladen." -ForegroundColor Green
    } catch {
        Write-Warning "Fehler beim Laden von $module $_"
        if ($module -eq "PSWriteHTML") {
            Write-Warning "Fahre mit CSV-Export fort, da PSWriteHTML nicht geladen werden konnte."
            $useCSVFallback = $true
        } else {
            Write-Error "Kritisches Modul $module konnte nicht geladen werden. Skript wird abgebrochen."
            exit
        }
    }
}

# Zentrale Fehlerbehandlungsfunktion mit Logfile
function Handle-Error {
    param(
        [string]$Message,
        $ReturnValue = $null
    )
    $logPath = ".\AD_SecurityAudit_Log.txt"
    $logMessage = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] WARNUNG: $Message"
    Write-Warning $logMessage
    Add-Content -Path $logPath -Value $logMessage -ErrorAction SilentlyContinue
    return $ReturnValue
}

# Funktion für Fortschrittsmeldungen
function Write-ProgressMessage {
    param(
        [string]$Activity,
        [int]$PercentComplete,
        [string]$Status
    )
    Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] $Activity - $Status" -ForegroundColor Cyan
    Add-Content -Path ".\AD_SecurityAudit_Log.txt" -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] INFO: $Activity - $Status" -ErrorAction SilentlyContinue
}

<#
.SYNOPSIS
    Wandelt eine SID in einen Gruppennamen um.
.PARAMETER sidString
    Die SID der Gruppe (z. B. S-1-5-32-551).
.RETURNS
    Der Gruppenname ohne Domänenpräfix oder $null bei Fehler.
#>
function Get-GroupNameBySid {
    param (
        [string]$sidString
    )
    Write-ProgressMessage -Activity "SID-Auflösung" -Status "Verarbeite SID: $sidString" -PercentComplete 0
    $knownSids = @{
        "S-1-5-32-548" = "Account Operators"
        "S-1-5-32-544" = "Administrators"
        "S-1-5-32-551" = "Backup Operators"
    }
    try {
        $sid = New-Object System.Security.Principal.SecurityIdentifier($sidString)
        $account = $sid.Translate([System.Security.Principal.NTAccount])
        $parts = $account.Value.Split('\')
        if ($parts.Length -gt 1) { return $parts[1] } else { return $account.Value }
    } catch {
        if ($knownSids.ContainsKey($sidString)) {
            return $knownSids[$sidString]
        }
        return Handle-Error -Message "SID $sidString konnte nicht aufgelöst werden: $_" -ReturnValue $null
    }
}

# Funktion: Inaktive Benutzer
function Get-InactiveUsers {
    param (
        [int]$Days = 90
    )
    Write-ProgressMessage -Activity "Inaktive Benutzer prüfen" -Status "Suche nach Benutzern (älter als $Days Tage)" -PercentComplete 10
    $threshold = (Get-Date).AddDays(-$Days)
    $allUsers | Where-Object { $null -ne $_.LastLogonTimeStamp -and ([DateTime]::FromFileTime($_.LastLogonTimeStamp) -lt $threshold) } |
        Select-Object Name, SamAccountName, @{Name='LastLogon';Expression={[DateTime]::FromFileTime($_.LastLogonTimeStamp)}}
}

# Funktion: Inaktive Computer
function Get-InactiveComputers {
    param (
        [int]$Days = 90
    )
    Write-ProgressMessage -Activity "Inaktive Computer prüfen" -Status "Suche nach Computern (älter als $Days Tage)" -PercentComplete 20
    $threshold = (Get-Date).AddDays(-$Days)
    $allComputers | Where-Object { $null -ne $_.LastLogonTimestamp -and ([DateTime]::FromFileTime($_.LastLogonTimestamp) -lt $threshold) } |
        Select-Object Name, OperatingSystem, @{Name='LastLogon';Expression={[DateTime]::FromFileTime($_.LastLogonTimestamp)}}
}

# Funktion: Benutzer mit Passwort läuft nie ab
function Get-PasswordNeverExpiresUsers {
    Write-ProgressMessage -Activity "Passwort nie ablaufend prüfen" -Status "Suche nach Benutzern" -PercentComplete 30
    $allUsers | Where-Object { $_.PasswordNeverExpires -eq $true } |
        Select-Object Name, SamAccountName
}

# Funktion: Benutzer mit Passwort nicht erforderlich
function Get-PasswordNotRequiredUsers {
    Write-ProgressMessage -Activity "Passwort nicht erforderlich prüfen" -Status "Suche nach Benutzern" -PercentComplete 40
    $allUsers | Where-Object { $_.PasswordNotRequired -eq $true -and $_.Enabled -eq $true } |
        Select-Object Name, SamAccountName
}

# Funktion: Mitglieder privilegierter Gruppen
function Get-PrivilegedGroupMembers {
    $domainSid = (Get-ADDomain).DomainSID.Value
    $groupSids = @{
        "Domain Admins"     = "$domainSid-512"
        "Enterprise Admins" = "$domainSid-519"
        "Schema Admins"     = "$domainSid-518"
        "Administrators"    = "S-1-5-32-544"
        "Backup Operators"  = "S-1-5-32-551"
        "Account Operators" = "S-1-5-32-548"
    }

    $results = @()
    $groupCount = $groupSids.Keys.Count
    $currentGroup = 0
    foreach ($groupKey in $groupSids.Keys) {
        $currentGroup++
        Write-ProgressMessage -Activity "Privilegierte Gruppen prüfen" -Status "Verarbeite Gruppe: $groupKey" -PercentComplete (50 + ($currentGroup / $groupCount * 10))
        $localGroupName = Get-GroupNameBySid -sidString $groupSids[$groupKey]
        if (-not $localGroupName) {
            Handle-Error -Message "Gruppe für SID $($groupSids[$groupKey]) nicht gefunden, überspringe $groupKey."
            continue
        }
        try {
            $members = Get-ADGroupMember -Identity $localGroupName -Recursive -ErrorAction Stop | 
                       Where-Object { $_.ObjectClass -eq 'user' } |
                       Select-Object Name, SamAccountName, ObjectClass
            $results += [PSCustomObject]@{
                Group   = $localGroupName
                Members = $members
            }
        } catch {
            Handle-Error -Message "Fehler beim Abrufen der Mitglieder von Gruppe '$localGroupName': $_"
        }
    }
    return $results
}

# Funktion: Vertrauensstellungen (Trusts)
function Get-ADTrusts {
    Write-ProgressMessage -Activity "Vertrauensstellungen prüfen" -Status "Abrufen von AD-Trusts" -PercentComplete 60
    Get-ADTrust -Filter * | Select-Object Name, TrustType, TrustDirection, TrustAttributes
}

#Kerberos-Delegation-Prüfung
function Get-KerberosDelegation {
    Write-ProgressMessage -Activity "Kerberos-Delegation prüfen" -Status "Suche nach Konten mit Delegation" -PercentComplete 70
    $results = @()
    try {
        $delegatedUsers = Get-ADUser -Filter 'userAccountControl -band 0x0080000 -or userAccountControl -band 0x1000000' -Properties SamAccountName, userAccountControl, msDS-AllowedToDelegateTo -ErrorAction Stop
        foreach ($user in $delegatedUsers) {
            $delegationType = if ($user.userAccountControl -band 0x0080000) { "Unconstrained" } elseif ($user.userAccountControl -band 0x1000000) { "Constrained" } else { "Unknown" }
            $results += [PSCustomObject]@{
                SamAccountName   = $user.SamAccountName
                DelegationType   = $delegationType
                AllowedToDelegateTo = $user.'msDS-AllowedToDelegateTo' -join "; "
            }
        }
        $delegatedComputers = Get-ADComputer -Filter 'userAccountControl -band 0x0080000 -or userAccountControl -band 0x1000000' -Properties SamAccountName, userAccountControl, msDS-AllowedToDelegateTo -ErrorAction Stop
        foreach ($computer in $delegatedComputers) {
            $delegationType = if ($computer.userAccountControl -band 0x0080000) { "Unconstrained" } elseif ($computer.userAccountControl -band 0x1000000) { "Constrained" } else { "Unknown" }
            $results += [PSCustomObject]@{
                SamAccountName   = $computer.SamAccountName
                DelegationType   = $delegationType
                AllowedToDelegateTo = $computer.'msDS-AllowedToDelegateTo' -join "; "
            }
        }
    } catch {
        Handle-Error -Message "Fehler beim Abrufen von Kerberos-Delegation: $_"
    }
    return $results
}


# Funktion: Suche nach GPP cpasswords in SYSVOL
function Get-GPPCpasswords {
    param (
        [string]$SysvolPath = "\\$((Get-ADDomain).DNSRoot)\SYSVOL\$((Get-ADDomain).DNSRoot)\Policies",
        [string]$DomainController = $null
    )
    Write-ProgressMessage -Activity "SYSVOL auf GPP-Passwörter prüfen" -Status "Prüfe Zugriff auf $SysvolPath" -PercentComplete 65
    $found = @()
    try {
        # Wenn ein spezifischer DC angegeben ist, SYSVOL-Pfad anpassen
        if ($DomainController) {
            $SysvolPath = "\\$DomainController\SYSVOL\$((Get-ADDomain).DNSRoot)\Policies"
            Write-ProgressMessage -Activity "SYSVOL-Prüfung" -Status "Verwende DC: $DomainController" -PercentComplete 66
        }
        # Netzwerk- und Berechtigungsprüfung
        if (-not (Test-Connection -ComputerName ($SysvolPath.Split('\')[2]) -Count 1 -Quiet)) {
            return Handle-Error -Message "Domänencontroller $($SysvolPath.Split('\')[2]) nicht erreichbar." -ReturnValue @([PSCustomObject]@{ FilePath = "Fehler"; FileName = "DC nicht erreichbar" })
        }
        if (-not (Test-Path $SysvolPath -ErrorAction Stop)) {
            return Handle-Error -Message "SYSVOL-Pfad $SysvolPath ist nicht zugänglich. Überprüfen Sie Berechtigungen oder Netzwerkkonnektivität." -ReturnValue @([PSCustomObject]@{ FilePath = "Fehler"; FileName = "Pfad nicht zugänglich" })
        }
        Write-ProgressMessage -Activity "SYSVOL-Prüfung" -Status "Durchsuche Dateien in $SysvolPath" -PercentComplete 67
        $files = Get-ChildItem -Path $SysvolPath -Recurse -Include *groups.xml, *services.xml, *scheduledtasks.xml -ErrorAction Stop
        $fileCount = ($files | Measure-Object).Count
        $currentFile = 0
        foreach ($file in $files) {
            $currentFile++
            Write-ProgressMessage -Activity "SYSVOL-Dateien prüfen" -Status "Verarbeite Datei: $($file.Name)" -PercentComplete (67 + ($currentFile / $fileCount * 3))
            [xml]$xml = Get-Content $file.FullName -ErrorAction Stop
            if ($xml.InnerXml -match "cpassword") {
                $found += [PSCustomObject]@{
                    FilePath = $file.FullName
                    FileName = $file.Name
                }
            }
        }
    } catch {
        return Handle-Error -Message "Zugriff auf SYSVOL fehlgeschlagen: $_" -ReturnValue @([PSCustomObject]@{ FilePath = "Fehler"; FileName = "Zugriff fehlgeschlagen: $_" })
    }
    return $found
}

# Funktion: AdminSDHolder-Vererbung prüfen
function Check-AdminSDHolderInheritance {
    Write-ProgressMessage -Activity "AdminSDHolder-Vererbung prüfen" -Status "Prüfe Benutzerobjekte" -PercentComplete 70
    $results = @()
    $userCount = ($allUsers | Measure-Object).Count
    $currentUser = 0
    foreach ($user in $allUsers) {
        $currentUser++
        Write-ProgressMessage -Activity "AdminSDHolder-Prüfung" -Status "Verarbeite Benutzer: $($user.SamAccountName)" -PercentComplete (70 + ($currentUser / $userCount * 5))
        try {
            $userEntry = [ADSI]"LDAP://$($user.DistinguishedName)"
            $acl = $userEntry.psbase.ObjectSecurity
            if ($acl.AreAccessRulesProtected) {
                $results += [PSCustomObject]@{
                    User                = $user.SamAccountName
                    DistinguishedName   = $user.DistinguishedName
                    InheritanceProtected = $true
                }
            }
        } catch {
            Handle-Error -Message "Fehler beim Zugriff auf ACL für Benutzer $($user.SamAccountName): $_"
        }
    }
    return $results
}

# Funktion: Ungewöhnliche ACLs auf Benutzerobjekten
function Check-UserObjectACLs {
    Write-ProgressMessage -Activity "Ungewöhnliche ACLs prüfen" -Status "Prüfe Benutzerobjekte" -PercentComplete 99
    $results = @()
    # Nur privilegierte oder aktive Benutzer prüfen
    $filteredUsers = $allUsers | Where-Object { $_.AdminCount -eq 1 -or $_.Enabled -eq $true }
    $userCount = ($filteredUsers | Measure-Object).Count
    $currentUser = 0
    foreach ($user in $filteredUsers) {
        $currentUser++
        Write-ProgressMessage -Activity "ACL-Prüfung" -Status "Verarbeite Benutzer: $($user.SamAccountName)" -PercentComplete (99 + ($currentUser / $userCount * 1))
        try {
            $userEntry = [ADSI]"LDAP://$($user.DistinguishedName)"
            $acl = $userEntry.psbase.ObjectSecurity
            if ($null -eq $acl) { continue }
            foreach ($ace in $acl.Access) {
                if ($ace.IdentityReference -notmatch 'Domain Admins' -and $ace.AccessControlType -eq 'Allow') {
                    $results += [PSCustomObject]@{
                        User    = $user.SamAccountName
                        Delegate = $ace.IdentityReference.Value
                        Rights  = $ace.ActiveDirectoryRights
                    }
                }
            }
        } catch {
            Handle-Error -Message "Fehler beim Zugriff auf ACL für Benutzer $($user.SamAccountName): $_"
        }
    }
    return $results
}


# Funktion: Veraltete Protokolle prüfen (SMBv1, NTLMv1, LM-Auth)
function Check-DeprecatedProtocols {
    Write-ProgressMessage -Activity "Veraltete Protokolle prüfen" -Status "Prüfe Server" -PercentComplete 80
    $results = @()
    $servers = $allComputers | Where-Object { $_.OperatingSystem -like '*Server*' }
    $serverCount = ($servers | Measure-Object).Count
    $currentServer = 0
    foreach ($srv in $servers) {
        $currentServer++
        Write-ProgressMessage -Activity "Protokollprüfung" -Status "Verarbeite Server: $($srv.Name)" -PercentComplete (80 + ($currentServer / $serverCount * 5))
        try {
            if (-not (Test-Connection -ComputerName $srv.Name -Count 1 -Quiet)) {
                $results += [PSCustomObject]@{
                    Server        = $srv.Name
                    SMB1Enabled   = "Server nicht erreichbar"
                    LMCompatLevel = "Unbekannt"
                }
                continue
            }
            $smbv1 = Invoke-Command -ComputerName $srv.Name -ScriptBlock {
                Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -ErrorAction SilentlyContinue
            }
            $lmhash = Invoke-Command -ComputerName $srv.Name -ScriptBlock {
                Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LmCompatibilityLevel" -ErrorAction SilentlyContinue
            }
            $results += [PSCustomObject]@{
                Server        = $srv.Name
                SMB1Enabled   = if ($smbv1.State -eq "Enabled") { $true } else { $false }
                LMCompatLevel = $lmhash.LmCompatibilityLevel
            }
        } catch {
            $results += [PSCustomObject]@{
                Server        = $srv.Name
                SMB1Enabled   = "Fehler beim Abruf"
                LMCompatLevel = "Unbekannt"
            }
        }
    }
    return $results
}

# Funktion: Unsichere SMB-Freigaben prüfen
function Find-InsecureShares {
    Write-ProgressMessage -Activity "Unsichere SMB-Freigaben prüfen" -Status "Prüfe Server" -PercentComplete 85
    $results = @()
    $servers = $allComputers | Where-Object { $_.OperatingSystem -like '*Server*' }
    $serverCount = ($servers | Measure-Object).Count
    $currentServer = 0
    foreach ($srv in $servers) {
        $currentServer++
        Write-ProgressMessage -Activity "SMB-Freigaben prüfen" -Status "Verarbeite Server: $($srv.Name)" -PercentComplete (85 + ($currentServer / $serverCount * 5))
        try {
            $shares = Invoke-Command -ComputerName $srv.Name -ScriptBlock {
                Get-SmbShare | Where-Object { $_.Name -ne "ADMIN$" -and $_.Name -ne "C$" }
            }
            foreach ($share in $shares) {
                $perms = Invoke-Command -ComputerName $srv.Name -ScriptBlock {
                    param($sharename)
                    Get-SmbShareAccess -Name $sharename
                } -ArgumentList $share.Name
                foreach ($perm in $perms) {
                    if (($perm.Name -match "Everyone" -or $perm.Name -match "Authenticated Users") -and
                        ($perm.AccessRight -match "Change|Full")) {
                        $results += [PSCustomObject]@{
                            Server      = $srv.Name
                            Share       = $share.Name
                            Path        = $share.Path
                            Trustee     = $perm.Name
                            AccessRight = $perm.AccessRight
                        }
                    }
                }
            }
        } catch {
            $results += [PSCustomObject]@{
                Server      = $srv.Name
                Share       = "Fehler beim Abruf"
                Path        = ""
                Trustee     = ""
                AccessRight = ""
            }
        }
    }
    return $results
}

# Funktion: Lokale Administratorrechte prüfen
function Get-LocalAdministrators {
    Write-ProgressMessage -Activity "Lokale Administratoren prüfen" -Status "Prüfe Clients" -PercentComplete 90
    $results = @()
    $clients = $allComputers | Where-Object { $_.OperatingSystem -notlike '*Server*' }
    $clientCount = ($clients | Measure-Object).Count
    $currentClient = 0
    foreach ($client in $clients) {
        $currentClient++
        Write-ProgressMessage -Activity "Lokale Administratoren prüfen" -Status "Verarbeite Client: $($client.Name)" -PercentComplete (90 + ($currentClient / $clientCount * 5))
        try {
            $admins = Invoke-Command -ComputerName $client.Name -ScriptBlock {
                try {
                    $group = Get-LocalGroupMember -Group "Administrators" -ErrorAction Stop
                    $group | Select-Object Name, ObjectClass
                } catch { @() }
            }
            foreach ($adm in $admins) {
                $results += [PSCustomObject]@{
                    Computer   = $client.Name
                    MemberName = $adm.Name
                    MemberType = $adm.ObjectClass
                }
            }
        } catch {
            $results += [PSCustomObject]@{
                Computer   = $client.Name
                MemberName = "Fehler beim Zugriff"
                MemberType = "Unbekannt"
            }
        }
    }
    return $results
}

# region CarlWebster
# Funktionen basierend auf https://raw.githubusercontent.com/CarlWebster/Active-Directory-V3/refs/heads/master/ADDS_Inventory_V3.ps1

function Get-ADUsersDetailed {
    Write-ProgressMessage -Activity "Detaillierte Benutzerdaten abrufen" -Status "Verarbeite Benutzer" -PercentComplete 95
    $allUsers | Select-Object Name, SamAccountName, Enabled, LastLogonDate, PasswordLastSet, PasswordNeverExpires, MemberOf, AdminCount
}

function Get-ADComputersDetailed {
    Write-ProgressMessage -Activity "Detaillierte Computerdaten abrufen" -Status "Verarbeite Computer" -PercentComplete 96
    $allComputers | Select-Object Name, OperatingSystem, OperatingSystemVersion, Enabled, LastLogonDate, PasswordLastSet
}

function Get-ADGroupsDetailed {
    Write-ProgressMessage -Activity "Gruppeninventar abrufen" -Status "Verarbeite Gruppen" -PercentComplete 97
    Get-ADGroup -Filter * -Properties Name, GroupCategory, GroupScope, Members
}

function Get-ADSites {
    Write-ProgressMessage -Activity "AD-Sites abrufen" -Status "Verarbeite Sites" -PercentComplete 98
    Get-ADReplicationSite -Filter *
}

function Get-ADOrganizationalUnits {
    Write-ProgressMessage -Activity "Organisationseinheiten abrufen" -Status "Verarbeite OUs" -PercentComplete 99
    Get-ADOrganizationalUnit -Filter * -Properties Name, Description, DistinguishedName
}

function Get-ADGroupPolicyObjects {
    Write-ProgressMessage -Activity "Gruppenrichtlinien abrufen" -Status "Verarbeite GPOs" -PercentComplete 100
    Get-GPO -All
}

function Get-PrivilegedUsersExtended {
    Write-ProgressMessage -Activity "Privilegierte Benutzer abrufen" -Status "Verarbeite Benutzer mit AdminCount=1" -PercentComplete 95
    $allUsers | Where-Object { $_.AdminCount -eq 1 } | Select-Object AdminCount, MemberOf, PasswordNeverExpires
}

function Get-GroupMembersDetailed($groupName) {
    Write-ProgressMessage -Activity "Gruppenmitglieder detailliert abrufen" -Status "Verarbeite Gruppe: $groupName" -PercentComplete 95
    Get-ADGroupMember -Identity $groupName -Recursive | Get-ADUser -Properties *
}

function Get-ADTrustsExtended {
    Write-ProgressMessage -Activity "Erweiterte Vertrauensstellungen abrufen" -Status "Verarbeite Trusts" -PercentComplete 95
    Get-ADTrust -Filter * | Select-Object Name, TrustType, TrustDirection, IsForestTransitive, TrustAttributes
}

function Get-DCHardwareAndServices {
    Write-ProgressMessage -Activity "DC-Hardware und Dienste prüfen" -Status "Verarbeite Domain Controller" -PercentComplete 95
    $dcs = $allComputers | Where-Object { $_.OperatingSystem -like "*Domain Controller*" }
    $results = @()
    $dcCount = ($dcs | Measure-Object).Count
    $currentDC = 0
    foreach ($dc in $dcs) {
        $currentDC++
        Write-ProgressMessage -Activity "DC-Hardware und Dienste" -Status "Verarbeite DC: $($dc.Name)" -PercentComplete (95 + ($currentDC / $dcCount * 2))
        try {
            $services = Invoke-Command -ComputerName $dc.Name -ScriptBlock {
                Get-Service | Where-Object { $_.Status -eq "Running" } | Select-Object Name, DisplayName
            }
            $os = Invoke-Command -ComputerName $dc.Name -ScriptBlock {
                (Get-CimInstance Win32_OperatingSystem).Caption
            }
            $results += [PSCustomObject]@{
                DCName    = $dc.Name
                OS        = $os
                Services  = ($services | ForEach-Object { $_.Name }) -join ", "
            }
        } catch {
            $results += [PSCustomObject]@{
                DCName    = $dc.Name
                OS        = "Fehler beim Abruf"
                Services  = "Fehler beim Abruf"
            }
        }
    }
    return $results
}

function Get-DCNTPStatus {
    Write-ProgressMessage -Activity "NTP-Status prüfen" -Status "Verarbeite Domain Controller" -PercentComplete 97
    $dcs = $allComputers | Where-Object { $_.OperatingSystem -like "*Domain Controller*" }
    $results = @()
    $dcCount = ($dcs | Measure-Object).Count
    $currentDC = 0
    foreach ($dc in $dcs) {
        $currentDC++
        Write-ProgressMessage -Activity "NTP-Status" -Status "Verarbeite DC: $($dc.Name)" -PercentComplete (97 + ($currentDC / $dcCount * 1))
        try {
            $ntp = Invoke-Command -ComputerName $dc.Name -ScriptBlock {
                w32tm /query /configuration
            }
            $results += [PSCustomObject]@{
                DCName      = $dc.Name
                NTPSettings = $ntp -join "`n"
            }
        } catch {
            $results += [PSCustomObject]@{
                DCName      = $dc.Name
                NTPSettings = "Fehler beim Abruf"
            }
        }
    }
    return $results
}

function Get-SYSVOLReplicationStatus {
    Write-ProgressMessage -Activity "SYSVOL-Replikationsstatus prüfen" -Status "Abrufen des DFSR-Backlogs" -PercentComplete 98
    try {
        Get-DfsrBacklog -GroupName "Domain System Volume" -ErrorAction Stop
    } catch {
        Handle-Error -Message "Fehler beim Abrufen des SYSVOL-Replikationsstatus: $_" -ReturnValue $null
    }
}

function Get-DCEVENTLogStatus {
    Write-ProgressMessage -Activity "Event-Log-Status prüfen" -Status "Verarbeite Domain Controller" -PercentComplete 99
    $dcs = $allComputers | Where-Object { $_.OperatingSystem -like "*Domain Controller*" }
    $results = @()
    $dcCount = ($dcs | Measure-Object).Count
    $currentDC = 0
    foreach ($dc in $dcs) {
        $currentDC++
        Write-ProgressMessage -Activity "Event-Log-Status" -Status "Verarbeite DC: $($dc.Name)" -PercentComplete (99 + ($currentDC / $dcCount * 1))
        try {
            $logs = Invoke-Command -ComputerName $dc.Name -ScriptBlock {
                Get-WinEvent -ListLog * | Select-Object LogName, RecordCount, FileSize
            }
            $results += [PSCustomObject]@{
                DCName = $dc.Name
                Logs   = $logs
            }
        } catch {
            $results += [PSCustomObject]@{
                DCName = $dc.Name
                Logs   = $null
            }
        }
    }
    return $results
}

# endregion CarlWebster

# Funktion: Risiko-Score berechnen
function Get-RiskScore {
    param(
        [hashtable]$Results
    )
    Write-ProgressMessage -Activity "Risiko-Score berechnen" -Status "Berechne Gesamtscore" -PercentComplete 100
    $score = 0
    if ($Results.InactiveUsersCount -gt 0) { $score += 10 }
    if ($Results.InactiveComputersCount -gt 0) { $score += 10 }
    if ($Results.DeprecatedProtocols) { $score += 15 }
    if ($Results.WeakPasswords) { $score += 20 }
    if ($Results.PrivilegedGroupIssues) { $score += 15 }
    if ($Results.LocalAdminsCount -gt 0) { $score += 20 }
    if ($Results.InsecureSharesCount -gt 0) { $score += 15 }
    if ($score -ge 80) { $level = "Kritisch" }
    elseif ($score -ge 50) { $level = "Hoch" }
    elseif ($score -ge 20) { $level = "Mittel" }
    else { $level = "Niedrig" }
    return [PSCustomObject]@{
        GesamtScore = $score
        Einstufung  = $level
    }
}

# System- und Registry-Settings Prüfung
function Check-SystemRegistrySettings {
    Write-ProgressMessage -Activity "System- und Registry-Settings prüfen" -Status "Prüfe SMB, Defender, UAC" -PercentComplete 95
    $results = @()
    $smb1key = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
    $smb1value = "SMB1"
    try {
        $smb1enabled = Get-ItemProperty -Path $smb1key -Name $smb1value -ErrorAction Stop | Select-Object -ExpandProperty $smb1value
    } catch {
        $smb1enabled = $null
    }
    $results += [PSCustomObject]@{
        Setting    = "SMBv1 Protocol deaktiviert"
        Path       = $smb1key
        Expected   = "0 (deaktiviert)"
        Actual     = if ($null -ne $smb1enabled) { $smb1enabled } else { "Nicht gesetzt" }
        Status     = if ($smb1enabled -eq 0) { "OK" } else { "Warnung" }
    }
    $defenderPath = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection"
    $defenderValue = "DisableRealtimeMonitoring"
    try {
        $realtime = Get-ItemProperty -Path $defenderPath -Name $defenderValue -ErrorAction Stop | Select-Object -ExpandProperty $defenderValue
    } catch {
        $realtime = $null
    }
    $results += [PSCustomObject]@{
        Setting    = "Windows Defender Echtzeitschutz"
        Path       = $defenderPath
        Expected   = "0 (aktiviert)"
        Actual     = if ($null -ne $realtime) { $realtime } else { "Nicht gesetzt" }
        Status     = if ($realtime -eq 0) { "OK" } else { "Warnung" }
    }
    $uacPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    $uacValue = "ConsentPromptBehaviorAdmin"
    try {
        $uac = Get-ItemProperty -Path $uacPath -Name $uacValue -ErrorAction Stop | Select-Object -ExpandProperty $uacValue
    } catch {
        $uac = $null
    }
    $expectedUAC = 2
    $results += [PSCustomObject]@{
        Setting    = "UAC Admin Approval Mode"
        Path       = $uacPath
        Expected   = $expectedUAC
        Actual     = if ($null -ne $uac) { $uac } else { "Nicht gesetzt" }
        Status     = if ($uac -eq $expectedUAC) { "OK" } else { "Warnung" }
    }
    return $results
}

# Audit & Logging Einstellungen prüfen
function Check-AuditAndLoggingSettings {
    Write-ProgressMessage -Activity "Audit- und Logging-Einstellungen prüfen" -Status "Prüfe Kategorien und Eventlog" -PercentComplete 96
    $results = @()
    $categories = @("System", "Logon", "Account Management", "Policy Change", "Object Access")
    $categoryCount = $categories.Count
    $currentCategory = 0
    foreach ($cat in $categories) {
        $currentCategory++
        Write-ProgressMessage -Activity "Audit-Einstellungen" -Status "Verarbeite Kategorie: $cat" -PercentComplete (96 + ($currentCategory / $categoryCount * 1))
        try {
            $auditSetting = auditpol /get /category:"$cat" | Select-String ".*"
            $enabled = ($auditSetting -match "Success|Failure") -and ($auditSetting -notmatch "No Auditing")
        } catch {
            $enabled = $false
        }
        $results += [PSCustomObject]@{
            Setting    = "Audit '$cat' Kategorie aktiviert"
            Expected   = "Success und Failure"
            Actual     = if ($enabled) { "Erfüllt" } else { "Nicht erfüllt" }
            Status     = if ($enabled) { "OK" } else { "Warnung" }
        }
    }
    try {
        $logInfo = Get-WinEvent -ListLog Security
        $maxSizeMB = [Math]::Round($logInfo.MaximumSizeInBytes / 1MB, 0)
        $results += [PSCustomObject]@{
            Setting    = "Security Eventlog Max. Größe"
            Expected   = "Größe ausreichend (> 50MB)"
            Actual     = "$maxSizeMB MB"
            Status     = if ($maxSizeMB -gt 50) { "OK" } else { "Warnung" }
        }
    } catch {
        $results += [PSCustomObject]@{
            Setting    = "Security Eventlog Max. Größe"
            Expected   = "Größe ausreichend (> 50MB)"
            Actual     = "Fehler beim Abruf"
            Status     = "Warnung"
        }
    }
    return $results
}

# Monitoring- und Angriffserkennungsrelevante Einstellungen
function Check-MonitoringAndAttackDetection {
    Write-ProgressMessage -Activity "Monitoring- und Angriffserkennung prüfen" -Status "Prüfe Defender und Firewall" -PercentComplete 97
    $results = @()
    try {
        $defenderService = Get-Service -Name "WinDefend" -ErrorAction Stop
        $status = if ($defenderService.Status -eq "Running") { "OK" } else { "Warnung (nicht laufend)" }
    } catch {
        $status = "Warnung (Dienst nicht gefunden)"
    }
    $results += [PSCustomObject]@{
        Setting    = "Windows Defender Antivirus Dienst"
        Expected   = "Dienst läuft"
        Actual     = $status
        Status     = if ($status -eq "OK") { "OK" } else { "Warnung" }
    }
    $tpPath = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features"
    $tpValue = "TamperProtection"
    try {
        $tpStatus = Get-ItemProperty -Path $tpPath -Name $tpValue -ErrorAction Stop | Select-Object -ExpandProperty $tpValue
        $tpEnabled = $tpStatus -eq 5
    } catch {
        $tpEnabled = $false
    }
    $results += [PSCustomObject]@{
        Setting    = "Windows Defender Tamper Protection"
        Expected   = "Aktiv (5)"
        Actual     = if ($tpEnabled) { "Aktiv" } else { "Inaktiv" }
        Status     = if ($tpEnabled) { "OK" } else { "Warnung" }
    }
    try {
        $firewallProfiles = Get-NetFirewallProfile
        $allEnabled = $true
        foreach ($profile in $firewallProfiles) {
            if (-not $profile.Enabled) { $allEnabled = $false }
        }
    } catch {
        $allEnabled = $false
    }
    $results += [PSCustomObject]@{
        Setting    = "Windows Defender Firewall - alle Profile aktiviert"
        Expected   = "Alle Profile aktiviert"
        Actual     = if ($allEnabled) { "OK" } else { "Mindestens ein Profil deaktiviert" }
        Status     = if ($allEnabled) { "OK" } else { "Warnung" }
    }
    return $results
}

# Detaillierte GPO- und Security-Policy-Konformitätsprüfung
function Check-GPOSecurityPolicies {
    Write-ProgressMessage -Activity "GPO- und Sicherheitsrichtlinien prüfen" -Status "Prüfe Passwort- und Auditing-Einstellungen" -PercentComplete 98
    $results = @()
    try {
        $passwordComplexity = (Get-ADDefaultDomainPasswordPolicy).ComplexityEnabled
        $results += [PSCustomObject]@{
            Setting = "Passwortkomplexität aktiviert"
            Expected = $true
            Actual = $passwordComplexity
            Status = if ($passwordComplexity) { "OK" } else { "Warnung" }
        }
    } catch {
        $results += [PSCustomObject]@{
            Setting = "Passwortkomplexität aktiviert"
            Expected = $true
            Actual = "Fehler beim Abruf"
            Status = "Warnung"
        }
    }
    try {
        $minPasswordAge = (Get-ADDefaultDomainPasswordPolicy).MinPasswordAge.Days
        $results += [PSCustomObject]@{
            Setting = "Minimales Passwortalter (Tage)"
            Expected = ">=1"
            Actual = $minPasswordAge
            Status = if ($minPasswordAge -ge 1) { "OK" } else { "Warnung" }
        }
    } catch {
        $results += [PSCustomObject]@{
            Setting = "Minimales Passwortalter (Tage)"
            Expected = ">=1"
            Actual = "Fehler beim Abruf"
            Status = "Warnung"
        }
    }
    try {
        $lockoutThreshold = (Get-ADDefaultDomainLockoutPolicy).LockoutThreshold
        $results += [PSCustomObject]@{
            Setting = "Kontosperrungsschwelle (fehlgeschl. Anm.)"
            Expected = ">=3"
            Actual = $lockoutThreshold
            Status = if ($lockoutThreshold -ge 3) { "OK" } else { "Warnung" }
        }
    } catch {
        $results += [PSCustomObject]@{
            Setting = "Kontosperrungsschwelle (fehlgeschl. Anm.)"
            Expected = ">=3"
            Actual = "Fehler beim Abruf"
            Status = "Warnung"
        }
    }
    try {
        $auditPolicy = auditpol /get /category:"Logon"
        $auditingEnabled = $auditPolicy -match "Success"
        $results += [PSCustomObject]@{
            Setting = "Anmeldeereignis-Auditing aktiviert"
            Expected = "Success (Erfolg)"
            Actual = if ($auditingEnabled) { "Aktiv" } else { "Inaktiv" }
            Status = if ($auditingEnabled) { "OK" } else { "Warnung" }
        }
    } catch {
        $results += [PSCustomObject]@{
            Setting = "Anmeldeereignis-Auditing aktiviert"
            Expected = "Success (Erfolg)"
            Actual = "Fehler beim Abruf"
            Status = "Warnung"
        }
    }
    return $results
}

# Systemweites Patch- und Update-Management prüfen
function Check-WindowsUpdateStatus {
    Write-ProgressMessage -Activity "Windows Update Status prüfen" -Status "Prüfe letzte Updates" -PercentComplete 99
    $results = @()
    try {
        $lastUpdate = Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 1
        $daysSinceUpdate = (New-TimeSpan -Start $lastUpdate.InstalledOn).Days
        $status = if ($daysSinceUpdate -gt 30) { "Warnung" } else { "OK" }
        $results += [PSCustomObject]@{
            Setting = "Letztes install. Windows-Update"
            Expected = "≤ 30 Tage alt"
            Actual = "$($lastUpdate.HotFixID) am $($lastUpdate.InstalledOn.ToShortDateString())"
            Status = $status
        }
    } catch {
        $results += [PSCustomObject]@{
            Setting = "Windows Update Status"
            Expected = "Update-Information verfügbar"
            Actual = "Fehler beim Abruf"
            Status = "Warnung"
        }
    }
    return $results
}

# Verschlüsselungsstandards-Checks auf Systemebene
function Check-EncryptionStandards {
    Write-ProgressMessage -Activity "Verschlüsselungsstandards prüfen" -Status "Prüfe TLS und Cipher Suites" -PercentComplete 99
    $results = @()
    $tls12Path = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server"
    $t12Enabled = 0
    try {
        $t12Enabled = Get-ItemProperty -Path $tls12Path -Name "Enabled" -ErrorAction Stop | Select-Object -ExpandProperty Enabled
    } catch {
        $t12Enabled = $null
    }
    $results += [PSCustomObject]@{
        Setting = "TLS 1.2 Server aktiviert"
        Expected = "1 (aktiviert)"
        Actual = if ($null -ne $t12Enabled) { $t12Enabled } else { "Nicht gesetzt" }
        Status = if ($t12Enabled -eq 1) { "OK" } else { "Warnung" }
    }
    $cipherSuitesPath = "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002"
    $cipherSuites = ""
    try {
        $cipherSuites = Get-ItemProperty -Path $cipherSuitesPath -Name "Functions" -ErrorAction Stop | Select-Object -ExpandProperty Functions
    } catch {
        $cipherSuites = ""
    }
    $weakCiphers = @("RC4", "DES", "NULL")
    $foundWeak = $weakCiphers | Where-Object { $cipherSuites -match $_ }
    $results += [PSCustomObject]@{
        Setting = "Unsichere Cipher Suites"
        Expected = "Keine RC4, DES, NULL"
        Actual = if ($foundWeak) { ($foundWeak -join ", ") } else { "Keine gefunden" }
        Status = if ($foundWeak) { "Warnung" } else { "OK" }
    }
    return $results
}

# Applikations- und Dienst-Härtungsspezifische Prüfungen
function Check-ApplicationHardening {
    Write-ProgressMessage -Activity "Applikations-Härtung prüfen" -Status "Prüfe Defender-Dienst" -PercentComplete 99
    $results = @()
    try {
        $service = Get-Service -Name "WinDefend" -ErrorAction Stop
        $status = if ($service.Status -eq "Running") { "OK" } else { "Warnung (nicht laufend)" }
    } catch {
        $status = "Warnung (Dienst nicht gefunden)"
    }
    $results += [PSCustomObject]@{
        Setting = "Windows Defender Dienst läuft"
        Expected = "Laufend"
        Actual = $status
        Status = if ($status -eq "OK") { "OK" } else { "Warnung" }
    }
    return $results
}

# Erweiterte Prüfungen von lokaler Firewall, Netzwerkeinstellungen und Protokollkonfiguration
function Check-FirewallNetworkSettings {
    Write-ProgressMessage -Activity "Firewall- und Netzwerkeinstellungen prüfen" -Status "Prüfe Firewall-Profile" -PercentComplete 99
    $results = @()
    try {
        $profiles = Get-NetFirewallProfile
        $allEnabled = $true
        foreach ($p in $profiles) {
            if (-not $p.Enabled) { $allEnabled = $false }
        }
        $status = if ($allEnabled) { "OK" } else { "Warnung (Mind. ein Profil deaktiviert)" }
    } catch {
        $status = "Warnung (Fehler beim Abruf)"
    }
    $results += [PSCustomObject]@{
        Setting = "Windows Firewall - alle Profile aktiviert"
        Expected = "Alle aktiviert"
        Actual = $status
        Status = if ($status -eq "OK") { "OK" } else { "Warnung" }
    }
    return $results
}

# Checks zu TLS- und Zertifikatseinstellungen
function Check-TLSAndCertificates {
    Write-ProgressMessage -Activity "TLS- und Zertifikate prüfen" -Status "Prüfe Zertifikatstore" -PercentComplete 99
    $results = @()
    try {
        $certs = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.NotAfter -gt (Get-Date) }
        $expiringSoon = $certs | Where-Object { $_.NotAfter -lt (Get-Date).AddDays(30) }
        $results += [PSCustomObject]@{
            Setting = "Gültige Zertifikate im LocalMachine-Store"
            Expected = "Mindestens 1 gültiges Zertifikat"
            Actual = "$($certs.Count) gültige Zertifikate"
            Status = if ($certs.Count -gt 0) { "OK" } else { "Warnung" }
        }
        $results += [PSCustomObject]@{
            Setting = "Zertifikate, die in 30 Tagen oder weniger ablaufen"
            Expected = "Keine"
            Actual = "$($expiringSoon.Count) Zertifikate"
            Status = if ($expiringSoon.Count -eq 0) { "OK" } else { "Warnung" }
        }
    } catch {
        $results += [PSCustomObject]@{
            Setting = "Zertifikatüberprüfung"
            Expected = "Erfolgreich"
            Actual = "Fehler beim Abruf"
            Status = "Warnung"
        }
    }
    return $results
}

# Authentifizierungs- und Zugriffskontrollmechanismen
function Check-UserRightsAssignments {
    Write-ProgressMessage -Activity "Benutzerrechte prüfen" -Status "Prüfe Zugriffsrechte" -PercentComplete 99
    $results = @()
    try {
        $rights = secedit /export /cfg "$env:TEMP\secpol.cfg" | Out-Null
        $content = Get-Content "$env:TEMP\secpol.cfg"
        Remove-Item "$env:TEMP\secpol.cfg" -Force -ErrorAction SilentlyContinue
        $denyRemoteLogon = ($content | Where-Object { $_ -match "^SeDenyRemoteInteractiveLogonRight" }) -join ""
        $results += [PSCustomObject]@{
            Setting = "Verweigerte Rechte: Remote Interactive Logon"
            Expected = "Nicht leer (Benutzer/Gruppen definiert)"
            Actual = if ($denyRemoteLogon) { $denyRemoteLogon.Split("=")[1].Trim() } else { "Nicht gesetzt" }
            Status = if ($denyRemoteLogon) { "OK" } else { "Warnung" }
        }
    } catch {
        $results += [PSCustomObject]@{
            Setting = "User Rights Assignments"
            Expected = "Erfolgreich ausgelesen"
            Actual = "Fehler beim Abruf"
            Status = "Warnung"
        }
    }
    return $results
}

# Prüfung auf unsichere LDAP-Bindungen
function Test-UnsafeLDAPBindings {
    Write-ProgressMessage -Activity "Unsichere LDAP-Bindungen prüfen" -Status "Prüfe Domain Controller" -PercentComplete 99
    $results = @()
    try {
        $dcs = Get-ADDomainController -Filter * | Select-Object -ExpandProperty HostName
        $dcCount = ($dcs | Measure-Object).Count
        $currentDC = 0
        foreach ($dc in $dcs) {
            $currentDC++
            Write-ProgressMessage -Activity "LDAP-Bindungen" -Status "Verarbeite DC: $dc" -PercentComplete (99 + ($currentDC / $dcCount * 1))
            try {
                $tcpClient = New-Object System.Net.Sockets.TcpClient
                $tcpClient.Connect($dc, 389)
                $stream = $tcpClient.GetStream()
                $status = "LDAP (Port 389) offen - ungesicherte Bindungen möglich"
                $tcpClient.Close()
            } catch {
                $status = "LDAP (Port 389) nicht erreichbar / gesichert"
            }
            $results += [PSCustomObject]@{
                DomainController = $dc
                LDAPPort389Status = $status
            }
        }
    } catch {
        $results += [PSCustomObject]@{
            DomainController = "Fehler"
            LDAPPort389Status = $_.Exception.Message
        }
    }
    return $results
}

# Detaillierte Replikationsstatus-Checks
function Test-ADReplicationHealth {
    Write-ProgressMessage -Activity "AD-Replikationsstatus prüfen" -Status "Prüfe Domain Controller" -PercentComplete 99
    $results = @()
    try {
        $dcNames = Get-ADDomainController -Filter * | Select-Object -ExpandProperty Name
        $dcCount = ($dcNames | Measure-Object).Count
        $currentDC = 0
        foreach ($dc in $dcNames) {
            $currentDC++
            Write-ProgressMessage -Activity "Replikationsstatus" -Status "Verarbeite DC: $dc" -PercentComplete (99 + ($currentDC / $dcCount * 1))
            try {
                $repStatus = Invoke-Command -ComputerName $dc -ScriptBlock {
                    repadmin /showrepl * /errorsonly
                } 2>&1
                $status = if ($repStatus) { "Fehler bei Replikation: $($repStatus -join '; ')" } else { "Replikation OK" }
            } catch {
                $status = "Fehler beim Abruf: $_"
            }
            $results += [PSCustomObject]@{
                DomainController = $dc
                ReplicationStatus = $status
            }
        }
    } catch {
        $results += [PSCustomObject]@{
            DomainController = "Fehler"
            ReplicationStatus = $_.Exception.Message
        }
    }
    return $results
}

# FSMO-Rollen-Status und Erreichbarkeit
function Test-FSMORoleStatus {
    Write-ProgressMessage -Activity "FSMO-Rollen prüfen" -Status "Prüfe Rolleninhaber" -PercentComplete 99
    $results = @()
    try {
        $fsmoRoles = @("SchemaMaster", "DomainNamingMaster", "PDCEmulator", "RIDMaster", "InfrastructureMaster")
        $roleCount = $fsmoRoles.Count
        $currentRole = 0
        foreach ($role in $fsmoRoles) {
            $currentRole++
            Write-ProgressMessage -Activity "FSMO-Rollen" -Status "Verarbeite Rolle: $role" -PercentComplete (99 + ($currentRole / $roleCount * 1))
            try {
                $owner = Get-ADDomain | Select-Object -ExpandProperty ($role)
                $results += [PSCustomObject]@{
                    FSMORole = $role
                    OwnerDC = $owner
                    Reachable = if (Test-Connection -ComputerName $owner -Count 1 -Quiet) { "Ja" } else { "Nein" }
                }
            } catch {
                $results += [PSCustomObject]@{
                    FSMORole = $role
                    OwnerDC = "Nicht ermittelbar"
                    Reachable = "Unbekannt"
                }
            }
        }
    } catch {
        $results += [PSCustomObject]@{
            FSMORole = "Fehler"
            OwnerDC = $_.Exception.Message
            Reachable = "Unbekannt"
        }
    }
    return $results
}

# LAPS Konfigurationsprüfung
function Test-LAPSConfiguration {
    Write-ProgressMessage -Activity "LAPS-Konfiguration prüfen" -Status "Prüfe Schema und GPOs" -PercentComplete 99
    $results = @()
    try {
        $lapsAttr = Get-ADObject -SearchBase "CN=Schema,CN=Configuration,$((Get-ADRootDSE).ConfigurationNamingContext)" -Filter 'Name -eq "ms-Mcs-AdmPwd"' -Properties Name
        $lapsInstalled = if ($lapsAttr) { $true } else { $false }
        $lapsGPOs = Get-GPOReport -All -ReportType Xml | Select-String -Pattern "AdmPwdExpirationProtection"
        $results += [PSCustomObject]@{
            Setting = "LAPS Schema Erweiterung vorhanden"
            Expected = "Ja"
            Actual = if ($lapsInstalled) { "Ja" } else { "Nein" }
            Status = if ($lapsInstalled) { "OK" } else { "Warnung" }
        }
        $results += [PSCustomObject]@{
            Setting = "LAPS GPO Konfigurationen gefunden"
            Expected = "Mindestens 1"
            Actual = if ($lapsGPOs) { "Vorhanden" } else { "Keine LAPS GPOs" }
            Status = if ($lapsGPOs) { "OK" } else { "Warnung" }
        }
    } catch {
        $results += [PSCustomObject]@{
            Setting = "LAPS Konfiguration"
            Expected = "Erfolgreich geprüft"
            Actual = "Fehler: $_"
            Status = "Warnung"
        }
    }
    return $results
}

#Backup-Prüfung (aus PSADHealth)
function Get-ADBackupStatus {
    Write-ProgressMessage -Activity "AD-Backup-Status prüfen" -Status "Prüfe letzte Backups" -PercentComplete 75
    $results = @()
    try {
        $dcs = (Get-ADDomainController -Filter *).Name
        foreach ($dc in $dcs) {
            $backupInfo = Get-WmiObject -Class Win32_NTBackup -ComputerName $dc -ErrorAction Stop
            $lastBackup = if ($backupInfo) { $backupInfo.LastBackupTime } else { $null }
            $status = if ($lastBackup -and $lastBackup -gt (Get-Date).AddDays(-7)) { "OK" } else { "Critical" }
            $results += [PSCustomObject]@{
                DCName = $dc
                LastBackup = $lastBackup
                Status = $status
            }
        }
    } catch {
        Handle-Error -Message "Fehler beim Abrufen des AD-Backup-Status: $_"
    }
    return $results
}

# SysVol/NetLogon-Status und GPO-Zustand
function Test-SysVolNetLogonStatus {
    Write-ProgressMessage -Activity "SYSVOL und NETLOGON prüfen" -Status "Prüfe Zugriff" -PercentComplete 99
    $results = @()
    try {
        $dcs = Get-ADDomainController -Filter * | Select-Object -ExpandProperty HostName
        $dcCount = ($dcs | Measure-Object).Count
        $currentDC = 0
        foreach ($dc in $dcs) {
            $currentDC++
            Write-ProgressMessage -Activity "SYSVOL/NETLOGON" -Status "Verarbeite DC: $dc" -PercentComplete (99 + ($currentDC / $dcCount * 1))
            try {
                $sysvolPath = "\\$dc\SYSVOL"
                $netlogonPath = "\\$dc\NETLOGON"
                $sysvolAccessible = Test-Path $sysvolPath
                $netlogonAccessible = Test-Path $netlogonPath
                $results += [PSCustomObject]@{
                    DomainController = $dc
                    SYSVOLAccessible = if ($sysvolAccessible) { "Ja" } else { "Nein" }
                    NetLogonAccessible = if ($netlogonAccessible) { "Ja" } else { "Nein" }
                }
            } catch {
                $results += [PSCustomObject]@{
                    DomainController = $dc
                    SYSVOLAccessible = "Fehler"
                    NetLogonAccessible = "Fehler"
                }
            }
        }
    } catch {
        $results += [PSCustomObject]@{
            DomainController = "Fehler"
            SYSVOLAccessible = $_.Exception.Message
            NetLogonAccessible = $_.Exception.Message
        }
    }
    return $results
}

# Detaillierte Domain Controller Health Checks
function Test-DCDetailedHealth {
    Write-ProgressMessage -Activity "Detaillierte DC-Health-Checks" -Status "Prüfe Netlogon und DNS" -PercentComplete 99
    $results = @()
    try {
        $dcs = Get-ADDomainController -Filter * | Select-Object -ExpandProperty Name
        $dcCount = ($dcs | Measure-Object).Count
        $currentDC = 0
        foreach ($dc in $dcs) {
            $currentDC++
            Write-ProgressMessage -Activity "DC-Health-Check" -Status "Verarbeite DC: $dc" -PercentComplete (99 + ($currentDC / $dcCount * 1))
            try {
                $netlogonStatus = Invoke-Command -ComputerName $dc -ScriptBlock {
                    nltest /sc_query:$(Get-ADDomain).DNSRoot
                }
                $dnsService = Invoke-Command -ComputerName $dc -ScriptBlock {
                    Get-Service -Name DNS
                }
                $results += [PSCustomObject]@{
                    DomainController = $dc
                    NetlogonStatus = if ($netlogonStatus -match "Trusted DC") { "OK" } else { "Warnung" }
                    DNSStatus = if ($dnsService.Status -eq "Running") { "OK" } else { "Warnung" }
                }
            } catch {
                $results += [PSCustomObject]@{
                    DomainController = $dc
                    NetlogonStatus = "Fehler"
                    DNSStatus = "Fehler"
                }
            }
        }
    } catch {
        $results += [PSCustomObject]@{
            DomainController = "Fehler"
            NetlogonStatus = $_.Exception.Message
            DNSStatus = $_.Exception.Message
        }
    }
    return $results
}

#DCDiag-Tests für detaillierte DC-Gesundheitsprüfung
function Get-DCDiagHealth {
    Write-ProgressMessage -Activity "DCDiag-Tests durchführen" -Status "Prüfe Domänencontroller" -PercentComplete 80
    $results = @()
    $dcServers = (Get-ADDomain).DomainControllers | ForEach-Object { $_.Name }
    $dcCount = $dcServers.Count
    $currentDC = 0
    foreach ($dc in $dcServers) {
        $currentDC++
        Write-ProgressMessage -Activity "DCDiag-Tests" -Status "Prüfe DC: $dc" -PercentComplete (80 + ($currentDC / $dcCount * 5))
        try {
            $dcdiag = dcdiag /s:$dc /test:Connectivity,Advertising,Replications,Services /q
            if ($dcdiag) {
                $results += [PSCustomObject]@{
                    DCName = $dc
                    Test   = "DCDiag"
                    Status = "Failed"
                    Details = ($dcdiag -join "; ")
                }
            } else {
                $results += [PSCustomObject]@{
                    DCName = $dc
                    Test   = "DCDiag"
                    Status = "Passed"
                    Details = "All tests passed"
                }
            }
        } catch {
            $results += [PSCustomObject]@{
                DCName = $dc
                Test   = "DCDiag"
                Status = "Error"
                Details = "Fehler beim Ausführen von DCDiag: $_"
            }
            Handle-Error -Message "Fehler bei DCDiag für $dc: $_"
        }
    }
    return $results
}

#E-Mail-Bericht
function Send-AuditReportEmail {
    param (
        [string]$SmtpServer = "smtp.yourdomain.com",
        [string]$From = "ad-audit@yourdomain.com",
        [string[]]$To = @("admin@yourdomain.com"),
        [string]$Subject = "AD Security Audit Report $(Get-Date -Format 'yyyy-MM-dd')",
        [string]$AttachmentPath = ".\AD_SecurityAudit_Log.txt"
    )
    try {
        $body = "Der AD Security Audit wurde abgeschlossen. Ergebnisse sind im Anhang und im Verzeichnis gespeichert.`n`nExportierte Dateien:`n"
        $exportedFiles = Get-ChildItem -Path ".\AD_*.csv" | Select-Object -ExpandProperty Name
        $body += $exportedFiles -join "`n"
        Send-MailMessage -SmtpServer $SmtpServer -From $From -To $To -Subject $Subject -Body $body -Attachments $AttachmentPath -Encoding UTF8 -ErrorAction Stop
        Write-Host "E-Mail-Bericht erfolgreich gesendet an: $($To -join ', ')" -ForegroundColor Green
        Add-Content -Path ".\AD_SecurityAudit_Log.txt" -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] INFO: E-Mail-Bericht gesendet an: $($To -join ', ')" -ErrorAction SilentlyContinue
    } catch {
        Handle-Error -Message "Fehler beim Senden des E-Mail-Berichts: $_"
    }
}




# Zwischenspeichern der AD-Daten
#Write-ProgressMessage -Activity "AD-Daten abrufen" -Status "Lade Benutzer und Computer" -PercentComplete 5
#$allUsers = Get-ADUser -Filter * -Properties DistinguishedName, SamAccountName, LastLogonTimeStamp, PasswordNeverExpires, PasswordNotRequired, Enabled, AdminCount, MemberOf, LastLogonDate, PasswordLastSet
#$allComputers = Get-ADComputer -Filter * -Properties OperatingSystem, LastLogonTimestamp, OperatingSystemVersion, Enabled, PasswordLastSet

Write-ProgressMessage -Activity "Daten initialisieren" -Status "Lade Benutzer- und Computerdaten" -PercentComplete 5
try {
    $allUsers = Get-ADUser -Filter * -Properties DistinguishedName, SamAccountName, LastLogonTimeStamp, PasswordNeverExpires, PasswordNotRequired, Enabled, AdminCount, MemberOf, LastLogonDate, PasswordLastSet -ErrorAction Stop
    $allComputers = Get-ADComputer -Filter * -Properties OperatingSystem, LastLogonTimestamp, OperatingSystemVersion, Enabled, PasswordLastSet -ErrorAction Stop
} catch {
    Handle-Error -Message "Fehler beim Abrufen von AD-Daten: $_"
    exit
}

# Sammeln der Ergebnisse
Write-ProgressMessage -Activity "Sicherheitsprüfungen starten" -Status "Initialisiere Prüfungen" -PercentComplete 10
$inactiveUsers = Get-InactiveUsers
$inactiveComputers = Get-InactiveComputers
$pwdNeverExpires = Get-PasswordNeverExpiresUsers
$pwdNotRequired = Get-PasswordNotRequiredUsers
$privilegedGroups = Get-PrivilegedGroupMembers
$trusts = Get-ADTrusts
# Versuche SYSVOL-Prüfung mit jedem verfügbaren Domänencontroller
$dcs = Get-ADDomainController -Filter * | Select-Object -ExpandProperty HostName
$gppPasswords = $null
foreach ($dc in $dcs) {
    Write-ProgressMessage -Activity "SYSVOL-Prüfung" -Status "Versuche DC: $dc" -PercentComplete 65
    $gppPasswords = Get-GPPCpasswords -DomainController $dc
    if ($gppPasswords -and $gppPasswords[0].FilePath -ne "Fehler") {
        break
    }
}

#$adminSDHolderUsers = Check-AdminSDHolderInheritance
$adminSDHolderUsers = @()

#$deprecatedProtocols = Check-DeprecatedProtocols
$deprecatedProtocols = @()

#$localAdmins = Get-LocalAdministrators
$localAdmins = @()

#$insecureShares = Find-InsecureShares
$insecureShares = @()

$adUsersDetailed = Get-ADUsersDetailed
$adComputersDetailed = Get-ADComputersDetailed
$adGroupsDetailed = Get-ADGroupsDetailed
$adSites = Get-ADSites
$adOUs = Get-ADOrganizationalUnits
$gpos = Get-ADGroupPolicyObjects
$privilegedUsers = Get-PrivilegedUsersExtended
$trustsDetailed = Get-ADTrustsExtended
$dcHardwareServices = Get-DCHardwareAndServices
$dcNTPStatus = Get-DCNTPStatus

#$sysvolStatus = Get-SYSVOLReplicationStatus
$sysvolStatus = @()

$dcEventLogStatus = Get-DCEVENTLogStatus
$systemSettings = Check-SystemRegistrySettings

#$auditSettings = Check-AuditAndLoggingSettings
$auditSettings = @()


$monitoringSettings = Check-MonitoringAndAttackDetection

#$gpoCompliance = Check-GPOSecurityPolicies
$gpoCompliance = @()

$patchStatus = Check-WindowsUpdateStatus
$encryptionSettings = Check-EncryptionStandards
$appHardening = Check-ApplicationHardening
$firewallNetwork = Check-FirewallNetworkSettings
$tlsCertChecks = Check-TLSAndCertificates
$userRightsAssignments = Check-UserRightsAssignments
$unsafeLDAPBindings = Test-UnsafeLDAPBindings
$replicationHealth = Test-ADReplicationHealth
$fsmoStatus = Test-FSMORoleStatus
$lapsConfig = Test-LAPSConfiguration
$sysvolNetlogonStatus = Test-SysVolNetLogonStatus

#$dcDetailedHealth = Test-DCDetailedHealth
$dcDetailedHealth = @()

#$userACLs = Check-UserObjectACLs
$userACLs = @()

$dcDetailedHealth = Get-DCDiagHealth

$kerberosDelegation = Get-KerberosDelegation

$adBackupStatus = Get-ADBackupStatus


$ResultsSummary = @{}
$ResultsSummary.InactiveUsersCount = ($inactiveUsers | Measure-Object).Count
$ResultsSummary.InactiveComputersCount = ($inactiveComputers | Measure-Object).Count
$ResultsSummary.DeprecatedProtocols = ($deprecatedProtocols | Where-Object { $_.SMB1Enabled -eq $true -or $_.LMCompatLevel -lt 5 }).Count -gt 0
$ResultsSummary.WeakPasswords = ($pwdNeverExpires | Measure-Object).Count -gt 0 -or ($pwdNotRequired | Measure-Object).Count -gt 0
$ResultsSummary.PrivilegedGroupIssues = ($privilegedGroups | Measure-Object).Count -gt 0
$ResultsSummary.LocalAdminsCount = ($localAdmins | Measure-Object).Count
$ResultsSummary.InsecureSharesCount = ($insecureShares | Measure-Object).Count

$riskResult = Get-RiskScore -Results $ResultsSummary

<#
# region HTMLReportmitPSWriteHTMLerzeugen
Write-ProgressMessage -Activity "HTML-Bericht erstellen" -Status "Generiere Bericht" -PercentComplete 100
New-HTML {
    New-HTMLHead -Title "Active Directory Security Audit Report" -StyleBlock '
        body { font-family: Segoe UI, Tahoma, Geneva, Verdana, sans-serif; margin: 20px;}
        h1 {color: darkblue;}
        table {border-collapse: collapse; width: 100%;}
        th, td {border: 1px solid #ddd; padding: 8px;}
        th {background-color: #4CAF50; color: white;}
        tr:nth-child(even) {background-color: #f2f2f2;}
        tr:hover {background-color: #ddd;}
    '
    New-HTMLBody {
        New-HTMLSection -HeaderText "Active Directory Sicherheitsprüfung (PingCastle/Purple Knight)" {
            New-HTMLText -Text "Dieser Bericht fasst wichtige Sicherheitsprüfungen des Active Directory zusammen."
        }
        New-HTMLSection -HeaderText "1. Inaktive Benutzerkonten (mehr als 90 Tage)" {
            if ($inactiveUsers) { New-HTMLTable -DataTable $inactiveUsers -Paging }
            else { New-HTMLText -Text "Keine inaktiven Benutzer gefunden." }
        }
        New-HTMLSection -HeaderText "2. Inaktive Computer (mehr als 90 Tage)" {
            if ($inactiveComputers) { New-HTMLTable -DataTable $inactiveComputers -Paging }
            else { New-HTMLText -Text "Keine inaktiven Computer gefunden." }
        }
        New-HTMLSection -HeaderText "3. Benutzer mit Passwort läuft nie ab" {
            if ($pwdNeverExpires) { New-HTMLTable -DataTable $pwdNeverExpires -Paging }
            else { New-HTMLText -Text "Keine Benutzer mit Passwort läuft nie ab gefunden." }
        }
        New-HTMLSection -HeaderText "4. Benutzer mit Passwort nicht erforderlich" {
            if ($pwdNotRequired) { New-HTMLTable -DataTable $pwdNotRequired -Paging }
            else { New-HTMLText -Text "Keine Benutzer mit Passwort nicht erforderlich gefunden." }
        }
        New-HTMLSection -HeaderText "5. Mitglieder privilegierter Gruppen" {
            foreach ($grp in $privilegedGroups) {
                New-HTMLText -Text "Gruppe: $($grp.Group)"
                if ($grp.Members) { New-HTMLTable -DataTable $grp.Members -Paging }
                else { New-HTMLText -Text "Keine Mitglieder gefunden." }
            }
        }
        New-HTMLSection -HeaderText "6. Vertrauensstellungen (Trusts)" {
            if ($trusts) { New-HTMLTable -DataTable $trusts -Paging }
            else { New-HTMLText -Text "Keine Vertrauensstellungen gefunden." }
        }
        New-HTMLSection -HeaderText "7. GPP Klartext-Passwörter in SYSVOL" {
            if ($gppPasswords -and $gppPasswords[0].FilePath -ne "Fehler") {
                New-HTMLTable -DataTable $gppPasswords -Paging
            } else {
                New-HTMLText -Text "Keine GPP Klartextpasswörter entdeckt oder SYSVOL-Zugriff fehlgeschlagen."
            }
        }
        New-HTMLSection -HeaderText "8. Benutzer mit deaktivierter Vererbung (AdminSDHolder)" {
            if ($adminSDHolderUsers) { New-HTMLTable -DataTable $adminSDHolderUsers -Paging }
            else { New-HTMLText -Text "Keine Problemfälle gefunden." }
        }
        New-HTMLSection -HeaderText "9. Benutzerobjekte mit ungewöhnlichen ACLs" {
            if ($userACLs) { New-HTMLTable -DataTable $userACLs -Paging }
            else { New-HTMLText -Text "Keine ungewöhnlichen ACLs entdeckt." }
        }
        New-HTMLSection -HeaderText "10. Veraltete/Unsichere Protokolle" {
            if ($deprecatedProtocols) { New-HTMLTable -DataTable $deprecatedProtocols -Paging }
            else { New-HTMLText -Text "Keine unsicheren Protokolle gefunden." }
        }
        New-HTMLSection -HeaderText "11. Lokale Administratorrechte" {
            if ($localAdmins) { New-HTMLTable -DataTable $localAdmins -Paging }
            else { New-HTMLText -Text "Keine lokalen Administratoren gefunden." }
        }
        New-HTMLSection -HeaderText "12. Unsichere SMB-Freigaben" {
            if ($insecureShares) { New-HTMLTable -DataTable $insecureShares -Paging }
            else { New-HTMLText -Text "Keine unsicheren Shares gefunden." }
        }
        New-HTMLSection -HeaderText "Gesamt-Risikobewertung" {
            New-HTMLTable -DataTable @($riskResult)
        }
        New-HTMLSection -HeaderText "AD Benutzer-Inventar" {
            if ($adUsersDetailed -and $adUsersDetailed.Count -gt 0) {
                New-HTMLTable -DataTable $adUsersDetailed -Paging
            } else {
                New-HTMLText -Text "Keine Benutzer gefunden."
            }
        }
        New-HTMLSection -HeaderText "Sites und Organisationseinheiten" {
            if ($adSites -and $adSites.Count -gt 0) {
                New-HTMLSubSection -HeaderText "Active Directory Sites" {
                    New-HTMLTable -DataTable $adSites -Paging
                }
            } else {
                New-HTMLText -Text "Keine AD Sites gefunden."
            }
            if ($adOUs -and $adOUs.Count -gt 0) {
                New-HTMLSubSection -HeaderText "Organizational Units (OUs)" {
                    New-HTMLTable -DataTable $adOUs -Paging
                }
            } else {
                New-HTMLText -Text "Keine OUs gefunden."
            }
        }
        New-HTMLSection -HeaderText "Gruppenrichtlinien-Objekte (GPOs)" {
            if ($gpos -and $gpos.Count -gt 0) {
                New-HTMLTable -DataTable $gpos -Paging
            } else {
                New-HTMLText -Text "Keine GPOs gefunden."
            }
        }
        New-HTMLSection -HeaderText "AD Gruppen-Inventar" {
            if ($adGroupsDetailed -and $adGroupsDetailed.Count -gt 0) {
                New-HTMLTable -DataTable $adGroupsDetailed -Paging
            } else {
                New-HTMLText -Text "Keine Gruppen gefunden."
            }
        }
        New-HTMLSection -HeaderText "Domänenvertrauensstellungen (Trusts)" {
            if ($trustsDetailed -and $trustsDetailed.Count -gt 0) {
                New-HTMLTable -DataTable $trustsDetailed -Paging
            } else {
                New-HTMLText -Text "Keine Trusts gefunden."
            }
        }
        New-HTMLSection -HeaderText "Domain Controller - Hardware & laufende Dienste" {
            if ($dcHardwareServices -and $dcHardwareServices.Count -gt 0) {
                foreach ($dc in $dcHardwareServices) {
                    New-HTMLSubSection -HeaderText "DC: $($dc.DCName)" {
                        New-HTMLText -Text "Betriebssystem: $($dc.OS)"
                        New-HTMLText -Text "Laufende Dienste: $($dc.Services)"
                    }
                }
            } else {
                New-HTMLText -Text "Keine Domain Controller Informationen gefunden."
            }
        }
        New-HTMLSection -HeaderText "Zeitserver (NTP) Status der Domain Controller" {
            if ($dcNTPStatus -and $dcNTPStatus.Count -gt 0) {
                foreach ($dc in $dcNTPStatus) {
                    New-HTMLSubSection -HeaderText "DC: $($dc.DCName)" {
                        New-HTMLText -Text ($dc.NTPSettings -replace "`n", "<br>")
                    }
                }
            } else {
                New-HTMLText -Text "Keine NTP-Statusinformationen gefunden."
            }
        }
        New-HTMLSection -HeaderText "SYSVOL Replikationsstatus" {
            if ($sysvolStatus) {
                New-HTMLText -Text "SYSVOL-Statusdaten können hier angezeigt werden (ggf. manuell formatieren)."
            } else {
                New-HTMLText -Text "Keine SYSVOL-Statusinformationen gefunden."
            }
        }
        New-HTMLSection -HeaderText "Event-Log Zustand auf Domain Controllern" {
            if ($dcEventLogStatus -and $dcEventLogStatus.Count -gt 0) {
                foreach ($dc in $dcEventLogStatus) {
                    New-HTMLSubSection -HeaderText "DC: $($dc.DCName)" {
                        if ($dc.Logs) {
                            New-HTMLTable -DataTable $dc.Logs -Paging
                        } else {
                            New-HTMLText -Text "Keine Event-Log Informationen verfügbar."
                        }
                    }
                }
            } else {
                New-HTMLText -Text "Keine Event-Log Statusinformationen gefunden."
            }
        }
        New-HTMLSection -HeaderText "System- und Registry-Settings" {
            if ($systemSettings) { New-HTMLTable -DataTable $systemSettings -Paging }
            else { New-HTMLText -Text "Keine Prüfungen durchgeführt." }
        }
        New-HTMLSection -HeaderText "Audit & Logging Einstellungen" {
            if ($auditSettings) { New-HTMLTable -DataTable $auditSettings -Paging }
            else { New-HTMLText -Text "Keine Prüfungen durchgeführt." }
        }
        New-HTMLSection -HeaderText "Monitoring- und Angriffserkennungs-Einstellungen" {
            if ($monitoringSettings) { New-HTMLTable -DataTable $monitoringSettings -Paging }
            else { New-HTMLText -Text "Keine Prüfungen durchgeführt." }
        }
        New-HTMLSection -HeaderText "GPO & Security Policy-Konformität" {
            if ($gpoCompliance) { New-HTMLTable -DataTable $gpoCompliance -Paging }
            else { New-HTMLText -Text "Keine GPO-Prüfungen durchgeführt." }
        }
        New-HTMLSection -HeaderText "Windows Update / Patch-Status" {
            if ($patchStatus) { New-HTMLTable -DataTable $patchStatus -Paging }
            else { New-HTMLText -Text "Keine Patch-Prüfungen durchgeführt." }
        }
        New-HTMLSection -HeaderText "Verschlüsselungsstandards-Systemcheck" {
            if ($encryptionSettings) { New-HTMLTable -DataTable $encryptionSettings -Paging }
            else { New-HTMLText -Text "Keine Verschlüsselungsprüfungen durchgeführt." }
        }
        New-HTMLSection -HeaderText "Applikations- und Dienst-Härtung" {
            if ($appHardening) { New-HTMLTable -DataTable $appHardening -Paging }
            else { New-HTMLText -Text "Keine Applikationsprüfungen durchgeführt." }
        }
        New-HTMLSection -HeaderText "Firewall-, Netzwerk- und Protokollkonfiguration" {
            if ($firewallNetwork) { New-HTMLTable -DataTable $firewallNetwork -Paging }
            else { New-HTMLText -Text "Keine Firewallprüfungen durchgeführt." }
        }
        New-HTMLSection -HeaderText "TLS- und Zertifikatsprüfung" {
            if ($tlsCertChecks) { New-HTMLTable -DataTable $tlsCertChecks -Paging }
            else { New-HTMLText -Text "Keine TLS-/Zertifikatsprüfungen durchgeführt." }
        }
        New-HTMLSection -HeaderText "Authentifizierungs- und Zugriffskontrollen" {
            if ($userRightsAssignments) { New-HTMLTable -DataTable $userRightsAssignments -Paging }
            else { New-HTMLText -Text "Keine Zugriffsprüfungen durchgeführt." }
        }
        New-HTMLSection -HeaderText "LDAP Bindungen (ungesichert)" {
            if ($unsafeLDAPBindings) { New-HTMLTable -DataTable $unsafeLDAPBindings -Paging }
            else { New-HTMLText -Text "Keine LDAP-Bindungen geprüft." }
        }
        New-HTMLSection -HeaderText "Active Directory Replikationsstatus" {
            if ($replicationHealth) { New-HTMLTable -DataTable $replicationHealth -Paging }
            else { New-HTMLText -Text "Keine Replikationsprüfungen durchgeführt." }
        }
        New-HTMLSection -HeaderText "FSMO-Rollen Status" {
            if ($fsmoStatus) { New-HTMLTable -DataTable $fsmoStatus -Paging }
            else { New-HTMLText -Text "Keine FSMO-Rollenprüfungen durchgeführt." }
        }
        New-HTMLSection -HeaderText "LAPS Konfiguration" {
            if ($lapsConfig) { New-HTMLTable -DataTable $lapsConfig -Paging }
            else { New-HTMLText -Text "Keine LAPS-Prüfungen durchgeführt." }
        }
        New-HTMLSection -HeaderText "SYSVOL und NETLOGON Status" {
            if ($sysvolNetlogonStatus) { New-HTMLTable -DataTable $sysvolNetlogonStatus -Paging }
            else { New-HTMLText -Text "Keine SYSVOL/NETLOGON-Prüfungen durchgeführt." }
        }
        New-HTMLSection -HeaderText "Domain Controller Health Checks" {
            if ($dcDetailedHealth) { New-HTMLTable -DataTable $dcDetailedHealth -Paging }
            else { New-HTMLText -Text "Keine DC-Health-Prüfungen durchgeführt." }
        }
    }
} | Out-File -FilePath ".\AD_SecurityAuditReport.html" -Encoding UTF8
# endregion HTMLReportmitPSWriteHTMLerzeugen
#>

<#
# HTML-Bericht erstellen (manuell)
if (-not $useCSVFallback) {
    Write-ProgressMessage -Activity "HTML-Bericht erstellen" -Status "Generiere Bericht" -PercentComplete 100
    $report = ".\AD_SecurityAuditReport.html"
    if (-not (Test-Path $report)) { New-Item $report -ItemType File }
    Clear-Content $report
    Add-Content $report "<html><head><meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
    Add-Content $report "<title>AD Security Audit Report</title>"
    Add-Content $report "<style type='text/css'>"
    Add-Content $report "body { font-family: Tahoma; font-size: 12px; }"
    Add-Content $report "table { border-collapse: collapse; width: 100%; }"
    Add-Content $report "th, td { border: 1px solid #999; padding: 8px; text-align: left; }"
    Add-Content $report "th { background-color: #4CAF50; color: white; }"
    Add-Content $report "tr:nth-child(even) { background-color: #f2f2f2; }"
    Add-Content $report "</style></head><body>"
    Add-Content $report "<h1>Active Directory Security Audit Report</h1>"
Add-Content $report "<h2>Kerberos-Delegation</h2>"
if ($kerberosDelegation) {
    Add-Content $report "<table><tr><th>SamAccountName</th><th>DelegationType</th><th>AllowedToDelegateTo</th></tr>"
    foreach ($item in $kerberosDelegation) {
        Add-Content $report "<tr><td>$($item.SamAccountName)</td><td>$($item.DelegationType)</td><td>$($item.AllowedToDelegateTo)</td></tr>"
    }
    Add-Content $report "</table>"
} else {
    Add-Content $report "<p>Keine Konten mit Kerberos-Delegation gefunden.</p>"
}	

Add-Content $report "<h2>AD-Backup-Status</h2>"
if ($adBackupStatus) {
    Add-Content $report "<table><tr><th>DCName</th><th>LastBackup</th><th>Status</th></tr>"
    foreach ($item in $adBackupStatus) {
        $rowClass = if ($item.Status -eq "Critical") { "class='critical'" } else { "" }
        Add-Content $report "<tr $rowClass><td>$($item.DCName)</td><td>$($item.LastBackup)</td><td>$($item.Status)</td></tr>"
    }
    Add-Content $report "</table>"
} else {
    Add-Content $report "<p>Keine Backup-Informationen gefunden.</p>"
}

    Add-Content $report "<h2>Inaktive Benutzerkonten (mehr als 90 Tage)</h2>"
    if ($inactiveUsers) {
        Add-Content $report "<table><tr><th>Name</th><th>SamAccountName</th><th>LastLogon</th></tr>"
        foreach ($user in $inactiveUsers) {
            Add-Content $report "<tr><td>$($user.Name)</td><td>$($user.SamAccountName)</td><td>$($user.LastLogon)</td></tr>"
        }
        Add-Content $report "</table>"
    } else {
        Add-Content $report "<p>Keine inaktiven Benutzer gefunden.</p>"
    }
    Add-Content $report "<h2>Inaktive Computer (mehr als 90 Tage)</h2>"
    if ($inactiveComputers) {
        Add-Content $report "<table><tr><th>Name</th><th>OperatingSystem</th><th>LastLogon</th></tr>"
        foreach ($computer in $inactiveComputers) {
            Add-Content $report "<tr><td>$($computer.Name)</td><td>$($computer.OperatingSystem)</td><td>$($computer.LastLogon)</td></tr>"
        }
        Add-Content $report "</table>"
    } else {
        Add-Content $report "<p>Keine inaktiven Computer gefunden.</p>"
    }
    # Weitere Abschnitte für andere Prüfungen ähnlich hinzufügen
    Add-Content $report "</body></html>"
    Write-Host "HTML-Bericht abgeschlossen. Bericht gespeichert unter: $report" -ForegroundColor Green
    Add-Content -Path ".\AD_SecurityAudit_Log.txt" -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] INFO: HTML-Bericht erfolgreich generiert." -ErrorAction SilentlyContinue
}
#>

# Ergebnisse in CSV-Dateien exportieren als Fallback
Write-ProgressMessage -Activity "Ergebnisse exportieren" -Status "Speichere Ergebnisse in CSV-Dateien" -PercentComplete 100
function Export-IfNotEmpty {
    param($Data, $Path)
    if ($Data -and ($Data | Measure-Object).Count -gt 0) {
        try {
            $Data | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8 -ErrorAction Stop
            Write-Host "Exportiert: $Path" -ForegroundColor Green
        } catch {
            Handle-Error -Message "Fehler beim Exportieren von $Path: $_"
        }
    } else {
        Write-Host "Keine Daten für $Path, Export übersprungen." -ForegroundColor Yellow
    }
}

Export-IfNotEmpty -Data $inactiveUsers -Path ".\AD_InactiveUsers.csv"
Export-IfNotEmpty -Data $inactiveComputers -Path ".\AD_InactiveComputers.csv"
Export-IfNotEmpty -Data $pwdNeverExpires -Path ".\AD_PwdNeverExpires.csv"
Export-IfNotEmpty -Data $pwdNotRequired -Path ".\AD_PwdNotRequired.csv"
$privilegedGroups | ForEach-Object { 
    if ($_.Members) { 
        Export-IfNotEmpty -Data $_.Members -Path ".\AD_PrivilegedGroup_$($_.Group -replace '[^\w\d]','_').csv"
    }
}
Export-IfNotEmpty -Data $trusts -Path ".\AD_Trusts.csv"
Export-IfNotEmpty -Data $gppPasswords -Path ".\AD_GPPPasswords.csv"
Export-IfNotEmpty -Data $adminSDHolderUsers -Path ".\AD_AdminSDHolder.csv"
Export-IfNotEmpty -Data $userACLs -Path ".\AD_UserACLs.csv"
Export-IfNotEmpty -Data $deprecatedProtocols -Path ".\AD_DeprecatedProtocols.csv"
Export-IfNotEmpty -Data $localAdmins -Path ".\AD_LocalAdmins.csv"
Export-IfNotEmpty -Data $insecureShares -Path ".\AD_InsecureShares.csv"
Export-IfNotEmpty -Data $adUsersDetailed -Path ".\AD_UsersDetailed.csv"
Export-IfNotEmpty -Data $adComputersDetailed -Path ".\AD_ComputersDetailed.csv"
Export-IfNotEmpty -Data $adGroupsDetailed -Path ".\AD_GroupsDetailed.csv"
Export-IfNotEmpty -Data $adSites -Path ".\AD_Sites.csv"
Export-IfNotEmpty -Data $adOUs -Path ".\AD_OrganizationalUnits.csv"
Export-IfNotEmpty -Data $gpos -Path ".\AD_GroupPolicyObjects.csv"
Export-IfNotEmpty -Data $privilegedUsers -Path ".\AD_PrivilegedUsers.csv"
Export-IfNotEmpty -Data $trustsDetailed -Path ".\AD_TrustsDetailed.csv"
Export-IfNotEmpty -Data $dcHardwareServices -Path ".\AD_DCHardwareServices.csv"
Export-IfNotEmpty -Data $dcNTPStatus -Path ".\AD_DCNTPStatus.csv"
Export-IfNotEmpty -Data $sysvolStatus -Path ".\AD_SYSVOLReplicationStatus.csv"
$dcEventLogStatus | ForEach-Object {
    if ($_.Logs) {
        Export-IfNotEmpty -Data $_.Logs -Path ".\AD_DCEventLogStatus_$($_.DCName -replace '[^\w\d]','_').csv"
    }
}
Export-IfNotEmpty -Data $systemSettings -Path ".\AD_SystemSettings.csv"
Export-IfNotEmpty -Data $auditSettings -Path ".\AD_AuditSettings.csv"
Export-IfNotEmpty -Data $monitoringSettings -Path ".\AD_MonitoringSettings.csv"
Export-IfNotEmpty -Data $gpoCompliance -Path ".\AD_GPOCompliance.csv"
Export-IfNotEmpty -Data $patchStatus -Path ".\AD_PatchStatus.csv"
Export-IfNotEmpty -Data $encryptionSettings -Path ".\AD_EncryptionSettings.csv"
Export-IfNotEmpty -Data $appHardening -Path ".\AD_AppHardening.csv"
Export-IfNotEmpty -Data $firewallNetwork -Path ".\AD_FirewallNetwork.csv"
Export-IfNotEmpty -Data $tlsCertChecks -Path ".\AD_TLSCertChecks.csv"
Export-IfNotEmpty -Data $userRightsAssignments -Path ".\AD_UserRightsAssignments.csv"
Export-IfNotEmpty -Data $unsafeLDAPBindings -Path ".\AD_UnsafeLDAPBindings.csv"
Export-IfNotEmpty -Data $replicationHealth -Path ".\AD_ReplicationHealth.csv"
Export-IfNotEmpty -Data $fsmoStatus -Path ".\AD_FSMOStatus.csv"
Export-IfNotEmpty -Data $lapsConfig -Path ".\AD_LAPSConfig.csv"
Export-IfNotEmpty -Data $sysvolNetlogonStatus -Path ".\AD_SysVolNetlogonStatus.csv"
Export-IfNotEmpty -Data $dcDetailedHealth -Path ".\AD_DCDetailedHealth.csv"
Export-IfNotEmpty -Data $riskResult -Path ".\AD_RiskScore.csv"
Export-IfNotEmpty -Data $kerberosDelegation -Path ".\AD_KerberosDelegation.csv"
Export-IfNotEmpty -Data $adBackupStatus -Path ".\AD_BackupStatus.csv"



$exportedFiles = Get-ChildItem -Path ".\AD_*.csv" | Select-Object -ExpandProperty Name
Add-Content -Path ".\AD_SecurityAudit_Log.txt" -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] INFO: Exportierte Dateien: $($exportedFiles -join ', ')" -ErrorAction SilentlyContinue

Write-Host "Audit abgeschlossen. Ergebnisse in CSV-Dateien im aktuellen Verzeichnis gespeichert." -ForegroundColor Green
Add-Content -Path ".\AD_SecurityAudit_Log.txt" -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] INFO: Ergebnisse in CSV-Dateien exportiert." -ErrorAction SilentlyContinue

#Send-AuditReportEmail -SmtpServer "smtp.yourdomain.com" -From "ad-audit@yourdomain.com" -To @("admin@yourdomain.com") -AttachmentPath ".\AD_SecurityAudit_Log.txt"

# Abschlussmeldung
#Write-ProgressMessage -Activity "Bericht abgeschlossen" -Status "HTML-Bericht wurde unter .\AD_SecurityAuditReport.html gespeichert." -PercentComplete 100
#Write-Host "Audit abgeschlossen. Bericht gespeichert unter: .\AD_SecurityAuditReport.html" -ForegroundColor Green
#Add-Content -Path ".\AD_SecurityAudit_Log.txt" -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] INFO: Bericht erfolgreich generiert." -ErrorAction SilentlyContinue
