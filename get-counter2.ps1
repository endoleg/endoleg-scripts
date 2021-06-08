############################################################################################
#####Auslastungstest 1.3#####
#Anforderungen:
# - Erfassung von WMI Daten 
# -	Abbrechbar durch Benutzer
# -	Ausgabe als CSV


#Anzahl der Kerne (inklusive Virtuelle)
$global:numberOfCores = 2
#Berechnung der exakten CPU-Auslastung, unterstützt Auslastung von mehr als einem Kern
$exact = 1
#Abstand zwischen Messungen in Sekunden
$global:timer = 1
#Name der Prozessgruppe, die zu untersuchen ist
$processName="chrome"
############################################################################################



$global:count = 0
$global:colData = @()
function load ($process) {

	if ($exact) {
		$compareError = 0
		
		$s1 = Get-WmiObject -class Win32_PerfRawData_PerfProc_Process

		#Start-Sleep -seconds 1

		$s2 = Get-WmiObject -class Win32_PerfRawData_PerfProc_Process

		$global:pptArray = @()

		for ($i = 0; $i -lt $s2.count; $i++) {
			if ($s2[$i].name -like "$processName*") {
				if ($s2[$i].name -like $s1[$i].name){
					$global:pptArray += (100*(($s2[$i].percentprocessortime - $s1[$i].percentprocessortime) /  ($s2[$i].TimeStamp_Sys100NS - $s1[$i].TimeStamp_Sys100NS)))
				}
				else {
				write-host -ForeGroundColor red "DATA MISMATCH, IGNORING"
				$compareError = 1
				break
				}
			}
		}
		$global:pptArray | foreach {
			$procCPU_exact += $_
		}
	}
	
	$query = Get-WmiObject -class win32_perfformatteddata_perfproc_process
	$query | foreach {
		
		if (!(($_.name -like "_Total") -or ($_.name -like "idle"))){
			$compCPU += ($_.PercentProcessortime/$global:numberOfCores)
		}
		if ($_.name -like "$process*"){
			$procCPU += ($_.PercentProcessortime/$global:numberOfCores)
			$procRAM += $_.workingsetprivate
			$procIO += $_.IOWriteBytesPerSec			
		}		
	}
	
	$objCurrent = New-Object System.Object
	$objCurrent | Add-Member -type NoteProperty -name CPU_Gesamt_% -value $compCPU
	$objCurrent | Add-Member -type NoteProperty -name CPU_Prozess_% -value $procCPU
	if ($exact) {
		if ($compareError -like 0) {
		$objCurrent | Add-Member -type NoteProperty -name CPU_Prozess_%_Exakt -value ([System.Math]::Round(($procCPU_exact /$global:numberOfCores),2))
		}
		else {
		$objCurrent | Add-Member -type NoteProperty -name CPU_Prozess_%_Exakt -value "N/A"
		}
	}
	$objCurrent | Add-Member -type NoteProperty -name RAM_MB -value ([System.Math]::Round(($procRAM /1024 /1024),2))
	$objCurrent | Add-Member -type NoteProperty -name WRITE_MB -value ([System.Math]::Round(($procIO /1024 /1024),2))
	$objCurrent | Add-Member -type NoteProperty -name Zeitpunkt -value (get-date)
	
	$procCPU = 0
	$procRAM = 0
	$procIO = 0
	
	return $objCurrent
	
	}

function read () {
	Write-host -ForeGroundColor green "Test $global:count passed, press `"c`" to stop and export data as CSV"
	for ($i = 0; ($i -lt $global:timer); $i++){
		Write-host -ForeGroundColor green "Script will continue in $($timer-$i) seconds" 
		start-Sleep -Seconds 1 
		if($host.UI.RawUI.KeyAvailable) {
			[boolean]$isKeyPressed = 1
		} else {
			[boolean]$isKeyPressed = 0
		}	
		if($isKeyPressed){
			return($host.ui.rawui.readkey("NoEcho,IncludeKeyUp")).character
		}		
	}	
}


Write-host -ForeGroundColor green "Checking all instances of $processName, press `"STRG + c`" to cancel!"

while (!($read -like "c")) {
	$global:count += 1
	$currentLoad = load($processName)
	$global:colData += $currentLoad
	echo $currentLoad
	$read = read
}
Write-host -ForeGroundColor green "Exporting CSV..."
$global:colData | export-csv -NoTypeInformation -delimiter "`t" -encoding unicode .\Auslastung.csv
