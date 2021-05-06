
<#
.SYNOPSIS
	Create a backup from the NetScaler and download a copy and copy some more files
.DESCRIPTION
	Create a backup from the NetScaler and download a copy and copy some more files
.PARAMETER NSManagementURL
	Management URL, used to connect to the NetScaler
.PARAMETER NSUserName
	NetScaler username with enough access to configure it
.PARAMETER NSPassword
	NetScaler username password
.PARAMETER NSCredential
	Use a PSCredential object instead of a username or password. Use "Get-Credential" to generate a credential object
	C:\PS> $Credential = Get-Credential
.PARAMETER WinSCPAssembly
	Specify the location for the WinSCP .NET assembly (Optional)
	When not specified the default location in the %ProgramFiles% / %ProgramFiles(x86)% will be used.
.PARAMETER BackupTargetLocation
	Specify the target location where to store the configuration and logfile
.PARAMETER NSBackupLevel
	Level to be used for the Backup. `"basic`" or `"full`" (Optional)
.EXAMPLE
	.\BackupNS.ps1 -NSManagementURL "http://nsvpx01.domain.local" -NSPassword "P@ssw0rd" -NSUserName "nsroot" -BackupTargetLocation "C:\Backup" -Verbose
	Create and download a backup from netscaler `"nsvpx01.domain.local`" and store it in `"C:\Backup`". And generate verbose output.
.EXAMPLE
	.\BackupNS.ps1 -NSManagementURL "http://192.168.100.1" -Credential $(get-credential) -Target "C:\Backup" -Verbose
	Create and download a backup from netscaler `"192.168.100.1`" and store it in `"C:\Backup`". And generate verbose output.
.NOTES
	File Name : BackupNS.ps1
	Requires  : PowerShell v3 and up
	            NetScaler 11.x and up
	            Run As Administrator
	            Make sure to install WinSCP (msi) to use the default values or specify the location to the “WinSCPnet.dll” .Net assembly. 
		    You can download it here: https://winscp.net/eng/download.php
	Source    : Stolen from https://twitter.com/johnbillekens (John Billekens) and customized for my requirements
		  : Original source: https://blog.j81.nl/2017/04/06/create-offline-backups-of-the-netscaler-config/
	
.LINK
	https://blog.j81.nl
#>

[cmdletbinding(DefaultParametersetName="UsernamePassword")]
param(
		[ValidateNotNullOrEmpty()]
		[alias("URL")]
		[string]$NSManagementURL,
		
		[Parameter(ParameterSetName="UsernamePassword",Mandatory=$true)]
		[alias("User", "Username")]
		[string]$NSUserName,
		
		[Parameter(ParameterSetName="UsernamePassword",Mandatory=$true)]
		[alias("Password")]
		[string]$NSPassword,

		[Parameter(ParameterSetName="Credential",Mandatory=$true)]
		[alias("Credential")]
		[ValidateScript({
			if ($_ -is [System.Management.Automation.PSCredential]) {
				$true
			} elseif ($_ -is [string]) {
				$Script:Credential=Get-Credential -Credential $_
				$true
			} else {
				Write-Error "You passed an unexpected object type for the credential (-NSCredential)"
			}
		})][object]$NSCredential,

		[Parameter(Mandatory=$true)]
		[alias("Target")]
		[string]$BackupTargetLocation,
		
		[Parameter(Mandatory=$false)]
		[ValidateSet("full", "basic")]
		[alias("Level")]
		[string]$NSBackupLevel="full",
		
		[Parameter(Mandatory=$false)]
		[string]$WinSCPAssembly = $null
)

#requires -version 3.0
#requires -runasadministrator

#region Functions

function InvokeNSRestApi {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true)]
		[PSObject]$Session,

		[Parameter(Mandatory=$true)]
		[ValidateSet('DELETE', 'GET', 'POST', 'PUT')]
		[string]$Method,

		[Parameter(Mandatory=$true)]
		[string]$Type,

		[string]$Resource,

		[string]$Action,

		[hashtable]$Arguments = @{},

		[switch]$Stat = $false,

		[ValidateScript({$Method -eq 'GET'})]
		[hashtable]$Filters = @{},

		[ValidateScript({$Method -ne 'GET'})]
		[hashtable]$Payload = @{},

		[switch]$GetWarning = $false,

		[ValidateSet('EXIT', 'CONTINUE', 'ROLLBACK')]
		[string]$OnErrorAction = 'EXIT'
	)
	if ([string]::IsNullOrEmpty($($Session.ManagementURL))) {
		throw "ERROR. Probably not logged into the NetScaler"
	}
	if ($Stat) {
		$uri = "$($Session.ManagementURL)/nitro/v1/stat/$Type"
	} else {
		$uri = "$($Session.ManagementURL)/nitro/v1/config/$Type"
	}
	if (-not ([string]::IsNullOrEmpty($Resource))) {
		$uri += "/$Resource"
	}
	if ($Method -ne 'GET') {
		if (-not ([string]::IsNullOrEmpty($Action))) {
			$uri += "?action=$Action"
		}

		if ($Arguments.Count -gt 0) {
			$queryPresent = $true
			if ($uri -like '*?action*') {
				$uri += '&args='
			} else {
				$uri += '?args='
			}
			$argsList = @()
			foreach ($arg in $Arguments.GetEnumerator()) {
				$argsList += "$($arg.Name):$([System.Uri]::EscapeDataString($arg.Value))"
			}
			$uri += $argsList -join ','
		}
	} else {
		$queryPresent = $false
		if ($Arguments.Count -gt 0) {
			$queryPresent = $true
			$uri += '?args='
			$argsList = @()
			foreach ($arg in $Arguments.GetEnumerator()) {
				$argsList += "$($arg.Name):$([System.Uri]::EscapeDataString($arg.Value))"
			}
			$uri += $argsList -join ','
		}
		if ($Filters.Count -gt 0) {
			$uri += if ($queryPresent) { '&filter=' } else { '?filter=' }
			$filterList = @()
			foreach ($filter in $Filters.GetEnumerator()) {
				$filterList += "$($filter.Name):$([System.Uri]::EscapeDataString($filter.Value))"
			}
			$uri += $filterList -join ','
		}
	}
	Write-Verbose -Message "URI: $uri"

	$jsonPayload = $null
	if ($Method -ne 'GET') {
		$warning = if ($GetWarning) { 'YES' } else { 'NO' }
		$hashtablePayload = @{}
		$hashtablePayload.'params' = @{'warning' = $warning; 'onerror' = $OnErrorAction; <#"action"=$Action#>}
		$hashtablePayload.$Type = $Payload
		$jsonPayload = ConvertTo-Json -InputObject $hashtablePayload -Depth 100
		Write-Verbose -Message "JSON Payload:`n$jsonPayload"
	}

	$response = $null
	$restError = $null
	try {
		$restError = @()
		$restParams = @{
			Uri = $uri
			ContentType = 'application/json'
			Method = $Method
			WebSession = $Session.WebSession
			ErrorVariable = 'restError'
			Verbose = $false
		}

		if ($Method -ne 'GET') {
			$restParams.Add('Body', $jsonPayload)
		}

		$response = Invoke-RestMethod @restParams

		if ($response) {
			if ($response.severity -eq 'ERROR') {
				throw "Error. See response: `n$($response | Format-List -Property * | Out-String)"
			} else {
				Write-Verbose -Message "Response:`n$(ConvertTo-Json -InputObject $response | Out-String)"
				if ($Method -eq "GET") { return $response }
			}
		}
	}
	catch [Exception] {
		if ($Type -eq 'reboot' -and $restError[0].Message -eq 'The underlying connection was closed: The connection was closed unexpectedly.') {
			Write-Verbose -Message 'Connection closed due to reboot'
		} else {
			throw $_
		}
	}
}

function Connect-NetScaler {
	[cmdletbinding()]
	param(
		[parameter(Mandatory)]
		[string]$ManagementURL,

		[parameter(Mandatory)]
		[pscredential]$Credential = (Get-Credential -Message 'NetScaler credential'),

		[int]$Timeout = 3600,

		[switch]$PassThru
	)
	Write-Verbose -Message "Connecting to $ManagementURL..."
	try {
		$login = @{
			login = @{
				username = $Credential.UserName;
				password = $Credential.GetNetworkCredential().Password
				timeout = $Timeout
			}
		}
		$loginJson = ConvertTo-Json -InputObject $login
		Write-Verbose "JSON Data:`n$($loginJson | Out-String)"
		$saveSession = @{}
		$params = @{
			Uri = "$ManagementURL/nitro/v1/config/login"
			Method = 'POST'
			Body = $loginJson
			SessionVariable = 'saveSession'
			ContentType = 'application/json'
			ErrorVariable = 'restError'
			Verbose = $false
		}
		$response = Invoke-RestMethod @params

		if ($response.severity -eq 'ERROR') {
			throw "Error. See response: `n$($response | Format-List -Property * | Out-String)"
		} else {
			Write-Verbose -Message "Response:`n$(ConvertTo-Json -InputObject $response | Out-String)"
		}
	} catch [Exception] {
		throw $_
	}

	$session = [PSObject]@{
		ManagementURL=[string]$ManagementURL;
		WebSession=[Microsoft.PowerShell.Commands.WebRequestSession]$saveSession;
	}

	$Script:NSSession = $session
	
	if($PassThru){
			return $session
	}
}

#endregion Functions

#region Script variables

[string]$ScriptDateTime = (Get-Date).ToString("yyyyMMddHHmm")
[string]$WinSCPSite = "https://winscp.net/eng/download.php"
[string]$WinSCPErrorSite = "https://winscp.net/eng/docs/message_net_operation_not_supported"
[string]$WinSCPAssemblyx86 = "C:\Program Files\WinSCP\WinSCPnet.dll"
[string]$WinSCPAssemblyx64 = "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"
[string]$WinSCPAssemblyScript = Join-Path $(Split-Path $MyInvocation.MyCommand.Path -Parent) "WinSCPnet.dll"
[ipaddress]$NSHostIP = [System.Net.Dns]::GetHostAddresses($NSManagementURL.replace("https://","").replace("http://","").replace("/","")) | select-object IPAddressToString -expandproperty  IPAddressToString
[string]$BackupFilename = "ns-backup-$($NSHostIP)-$($ScriptDateTime)"
[string]$BackupTargetLocation = $BackupTargetLocation.Trim("\")

#endregion Script variables

#region Target Directory

if ( -Not (Test-Path $BackupTargetLocation)) {
	New-Item -Path $BackupTargetLocation -ItemType Directory -Force | out-null
}

#endregion Target Directory

#region NSCredential
	
if (-not([string]::IsNullOrWhiteSpace($NSCredential))) {
	Write-Verbose "Using NSCredential"
} elseif ((-not([string]::IsNullOrWhiteSpace($NSUserName))) -and (-not([string]::IsNullOrWhiteSpace($NSPassword)))){
	Write-Verbose "Using NSUsername / NSPassword"
	[pscredential]$NSCredential = new-object -typename System.Management.Automation.PSCredential -argumentlist $NSUserName, $(ConvertTo-SecureString -String $NSPassword -AsPlainText -Force)
} else {
	Write-Verbose "No valid username/password or credential specified. Enter a username and password, e.g. `"nsroot`""
	[pscredential]$NSCredential = Get-Credential -Message "NetScaler username and password:"
}

#endregion NSCredential

#region Backup

try {
	Write-Verbose "Login to NetScaler and save session to global variable"
	$NSSession = Connect-NetScaler -ManagementURL $NSManagementURL -Credential $NSCredential -PassThru
	Write-Verbose "Saving NetScaler configuration"
	$response = InvokeNSRestApi -Session $NSSession -Method POST -Type nsconfig -Action save
	$payload = @{"filename"="$($BackupFilename)";"level"="$($NSBackupLevel)";"comment"="Backup created by BackupNS.ps1 PoSH Script"}
	$response = InvokeNSRestApi -Session $NSSession -Method POST -Type systembackup -Payload $payload -Action create
	
	try {
		Write-Verbose "Loading WinSCP .NET assembly"
		if (-not [string]::IsNullOrWhiteSpace($WinSCPAssembly)){
			if (Test-Path $WinSCPAssembly) {
				Write-Verbose "`"$WinSCPAssembly`" will be used"
			}
		} else {
			if (Test-Path $WinSCPAssemblyx64) {
				$WinSCPAssembly = $WinSCPAssemblyx64
			} elseif (Test-Path $WinSCPAssemblyx86) {
				$WinSCPAssembly = $WinSCPAssemblyx86
			} elseif (Test-Path $WinSCPAssemblyScript) {
				$WinSCPAssembly = $WinSCPAssemblyScript
				
			} else {
				start $WinSCPSite
				throw "The .NET Assembly could not be found"
			}
			Write-Verbose "using: $WinSCPAssembly"
		}
		Add-Type -Path "$WinSCPAssembly"
		Write-Verbose "assembly successfully locaded"
	
		Write-Verbose "Setup WinSCP session options"
		$WinSCPSessionOptions = New-Object WinSCP.SessionOptions
		$WinSCPSessionOptions.Protocol = [WinSCP.Protocol]::sftp
		$WinSCPSessionOptions.HostName = "$($NSHostIP.IPAddressToString)"
		$WinSCPSessionOptions.UserName = "$($NSCredential.UserName)"
		$WinSCPSessionOptions.Password = "$($NSCredential.GetNetworkCredential().Password)"
		$WinSCPSessionOptions.GiveUpSecurityAndAcceptAnySshHostKey = $true
	
		$WinSCPSession = New-Object WinSCP.Session
		Write-Verbose "Enable Logging"
		$WinSCPSession.SessionLogPath = "$($BackupTargetLocation)\$($BackupFilename)-log.txt" 
		try {
			Write-Verbose "Connecting"
			$WinSCPSession.Open($WinSCPSessionOptions)
	
			Write-Verbose "Try to download the backup file"
			$WinSCPTransferOptions = New-Object WinSCP.TransferOptions
			$WinSCPTransferOptions.TransferMode = [WinSCP.TransferMode]::Binary
			$WinSCPTransferResult = $WinSCPSession.GetFiles("/var/ns_sys_backup/$($BackupFilename).tgz", "$($BackupTargetLocation)\$($BackupFilename).tgz", $False, $WinSCPTransferOptions)
		
      Write-Verbose "Try to download /flash/nsconfig/ns.conf"
			$WinSCPTransferOptions = New-Object WinSCP.TransferOptions
			$WinSCPTransferOptions.TransferMode = [WinSCP.TransferMode]::Binary
			$WinSCPTransferResult = $WinSCPSession.GetFiles("/flash/nsconfig/ns.conf", "$($BackupTargetLocation)\ns.conf", $False, $WinSCPTransferOptions)

      Write-Verbose "Try to download /var/log/ns.log"
			$WinSCPTransferOptions = New-Object WinSCP.TransferOptions
			$WinSCPTransferOptions.TransferMode = [WinSCP.TransferMode]::Binary
			$WinSCPTransferResult = $WinSCPSession.GetFiles("/var/log/ns.log", "$($BackupTargetLocation)\ns.log", $False, $WinSCPTransferOptions)

      Write-Verbose "Try to download /var/log/nsvpn.log"
			$WinSCPTransferOptions = New-Object WinSCP.TransferOptions
			$WinSCPTransferOptions.TransferMode = [WinSCP.TransferMode]::Binary
			$WinSCPTransferResult = $WinSCPSession.GetFiles("/var/log/nsvpn.log", "$($BackupTargetLocation)\nsvpn.log", $False, $WinSCPTransferOptions)

   

      Write-Verbose "Throw on any error"
			$WinSCPTransferResult.Check()
	
			Write-Verbose "Print results"
			foreach ($transfer in $WinSCPTransferResult.Transfers) {
				Write-Host ("Upload of {0} succeeded" -f $transfer.FileName)
			}
		} finally {
			Write-Verbose "Disconnect, clean up"
			$WinSCPSession.Dispose()
		}
	} catch [System.IO.IOException]{
		Start $WinSCPErrorSite
		Write-Error "DLL was probably downloaded with Internet Explorer, unblock before extracting"
		throw $($_.Exception.Message)
	} catch {
		throw $($_.Exception.Message)
	}
} catch {
	throw $($_.Exception.Message)
} finally {
	Write-Verbose "Removing Backup file from NetScaler"
	$response = InvokeNSRestApi -Session $NSSession -Method DELETE -Type systembackup -Resource "$($BackupFilename).tgz"
}



#endregion Backup
