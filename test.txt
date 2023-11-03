$log= "$env:USERPROFILE\Errorlog-MapUserPrinters-WEM-V2.log"
Start-Transcript -Path $log

write-verbose -message "-----------------Anfang-----------------------------------------------" -verbose

write-verbose -message "---------- function get-timestamp Zeitstempel ----------------------------------------------------------------" -verbose
    function Get-TimeStamp {return "[{0:dd/MM/yy} {0:HH:mm:ss}]" -f (Get-Date)}

write-verbose -message "---------- function Test-RegistryPath ----------------------------------------------------------------" -verbose
    function Test-RegistryPath {
    param (
     [parameter(Mandatory=$true)]
     [ValidateNotNullOrEmpty()]$Path
    )
    try {
    Get-ItemProperty -Path $Path -ErrorAction Stop | Out-Null
     return $true
     }
    catch {
    return $false
    }
    }

write-verbose -message "$(Get-TimeStamp) ----------------------------------------------------------------" -verbose

$Druckserver3 = "NPOMS01"
write-verbose -message "--------Printserver SVA$Druckserver3 definiert-----------" -verbose

$Druckserver10 = "PRINT02"
write-verbose -message "--------Printserver SVA$Druckserver10 definiert-----------" -verbose

$Druckserver11 = "PRINT03"
write-verbose -message "--------Printserver SVA$Druckserver11 definiert-----------" -verbose

$Druckserver12 = "myq0002"
write-verbose -message "--------Printserver SVA$Druckserver12 definiert-----------" -verbose

$Druckserver13 = "EFIHF"
write-verbose -message "--------Printserver SVA$Druckserver13 definiert-----------" -verbose

#$Druckserver14 = "myq0003"
#write-verbose -message "--------Printserver SVA$Druckserver12 definiert-----------" -verbose

#		Case "EQTTST1"
#			Server = "SVAPRINT02"


# BG10.BGFE.Local/Citrix/Globale Gruppen/Drucker

$PRN = "*CTX-PRN-*"

write-verbose -message "" -verbose
write-verbose -message "$(Get-TimeStamp) ----------------------------------------------------------------" -verbose
write-verbose -message "" -verbose

write-verbose -message "$(Get-TimeStamp) --------Prüfen ob der Spooler antwortet-----------" -verbose
Get-Service -Name spooler

write-verbose -message "" -verbose
write-verbose -message "$(Get-TimeStamp) ----------  Voraussetzungen fuer AD-Abfragen (Gruppen in Gruppen) schaffen ------------" -verbose
$id = [Security.Principal.WindowsIdentity]::GetCurrent()
$groups = $id.Groups | foreach-object {$_.Translate([Security.Principal.NTAccount])}

write-verbose -message "$(Get-TimeStamp) ----------------------------------------------------------------" -verbose

write-verbose -message "--------Server und Drucker bestimmen-----------" -verbose
foreach ($g in $groups){
    if ($g -like $PRN){ 
        $teilen = $g -split "-"

    # $teile
      Switch($teilen){  

          $Druckserver3
            {
                $server = "SVA"+$teilen[2]
                $drucker = $teilen[3]
            }

          $Druckserver10
            {
                    $server = "SVA"+$teilen[2]
                    $drucker = $teilen[3]
                    #$server =$null
                    #$drucker = $null
            }

          $Druckserver11                                       
            {
                $server = "SVA"+$teilen[2]
                $drucker = $teilen[3]
            }

          $Druckserver12                                       
            {
                $server = "SVA"+$teilen[2]
                $drucker = $teilen[3]
                Write-host "SERVER !!!!" -ForegroundColor Green
            }
 
           $Druckserver13                                      
            {
               $server = "SVA"+$teilen[2]+"01"
               $drucker = $teilen[3]
            }

            <#
            $Druckserver14                                       
            {
                $server = "SVA"+$teilen[2]
                $drucker = $teilen[3]
            } 
            #>
      }

                   Write-verbose -message "$(Get-TimeStamp) --------------Druckerpfad ausgeben --------------" -verbose
                 $druckerpfad = "\\"+$server+"\"+$drucker
                 $druckerpfad                
                   Write-verbose -message "$(Get-TimeStamp) --------------Drucker $drucker wird gemappt--------------" -verbose
					$printClass = [wmiclass]'win32_printer'
					$printClass.AddPrinterConnection($druckerpfad)  
                     
    
                <#
                if ($teilen[4] -like "STD")
                {
                  Write-verbose -message "$(Get-TimeStamp) --------------Drucker als Standard setzen--------------" -verbose
                   $standard = New-Object -ComObject WScript.Network
                   $standard.SetDefaultPrinter($druckerpfad)
                }              
                #>

                Try {
                    # Code, der ausgeführt werden soll
                        if ($teilen[4] -like "STD") {
                            Write-verbose -message "$(Get-TimeStamp) --------------Drucker als Standard setzen--------------" -verbose
                            $standard = New-Object -ComObject WScript.Network
                            $standard.SetDefaultPrinter($druckerpfad)
                        }
                }
                Catch {
                    # Code, der ausgeführt wird, wenn ein Fehler auftritt
                        start-sleep 25
                        if ($teilen[4] -like "STD") {
                            $standard = New-Object -ComObject WScript.Network
                            $standard.SetDefaultPrinter($druckerpfad)
                        }
                }
                Finally {
                    # Code, der immer ausgeführt wird
                }
    }
}

Write-verbose -message "$(Get-TimeStamp) -------------- Druckermappings sind jetzt hoffentlich durch --------------" -verbose


$error.clear()

write-verbose -message "$(Get-TimeStamp) ----------------------------------------------------------------" -verbose

write-verbose -message "$(Get-TimeStamp) ---------- Drucker auflisten ----------" -verbose
$RedirectedFolders = Get-WmiObject -Class Win32_Printer | select -Property Name,Sharename
if ($RedirectedFolders -eq $null) {
write-verbose -message "$(Get-TimeStamp) ---------- Keine Drucker ----------" -verbose
} else {
    $RedirectedFolders | Format-Table -Autosize
write-verbose -message "$(Get-TimeStamp) ----------------------------------------------------------------" -verbose
write-verbose -message "$(Get-TimeStamp) ---------- Standard-Drucker ist ----------" -verbose
   (Get-WmiObject -Class Win32_Printer -Filter "Default = $true").Name
write-verbose -message "$(Get-TimeStamp) ----------------------------------------------------------------" -verbose
}

write-verbose -message "----------------------------------------------------------------" -verbose
write-verbose -message "----------------------------------------------------------------" -verbose

write-verbose -message "" -verbose
write-verbose -message "$(Get-TimeStamp) ---------- Gruppenmitgliedschaften auflisten ----------" -verbose
#import-module activedirectory
#$ausgabe= Get-ADPrincipalGroupMembership $env:USERNAME | Select name
net user $env:username /domain


write-verbose -message "$(Get-TimeStamp) ----------------------------------------------------------------" -verbose


################################################################################################
Write-Verbose -Message "Prüfung FollowMe1 Mitglied einer der AD-Gruppen" -verbose
################################################################################################
$status= Get-Service Spooler
if($status.Status -eq "Running"){
    #$groups
    if ( ($groups -contains "bg10\CTX-PRN-MYQ0002-Follow_Me_Kyocera-STD")) {
        Write-Verbose -Message "$(Get-TimeStamp) ----------- Gruppenmitgliedschaft CTX-PRN-MYQ0002-Follow_Me_Kyocera-STD besteht" -verbose
    
        $printer = Get-Printer
        $printer = $printer | Select-Object | Where-Object {$_.name -eq "\\SVAMYQ0002\Followme1"}
         $drucker= Get-Printer
        #if($printer.count -lt 1){
        if ([string]::IsNullOrEmpty($printer)){
        write-verbose -message "$(Get-TimeStamp) ---------- FollowMe ist NICHT da ----------" -verbose
        #Send-MailMessage -From "noreply@bgetem.de" -to "Enderlein.Thorsten@bgetem.de" -Subject "Der User $env:USERNAME hat keinen FollowMe-Drucker" -Body "Betroffen ist: Server: \\$ENV:COMPUTERNAME\c$. Vorhandene Drucker: $drucker" -SmtpServer "SMTP.bg10.bgfe.local"
        } 
        else {
            write-verbose -message "$(Get-TimeStamp) ---------- FollowMe ist da, alles gut----------" -verbose
        }
    }Else{
        Write-verbose -message "$(Get-TimeStamp) ----------- Gruppenmitgliedschaft \\SVAMYQ0002\Follow_Me_Kyocera-STD besteht nicht" -verbose
    }
}

else{
    do{
    Write-verbose -message "Spooler nicht da, warte 5 Sekunden" -verbose
        Start-Sleep -Seconds 5
    }while($status.Status -ne "Running")
}


#################################################################################################################################################

write-verbose -message "$(Get-TimeStamp) ---------- Get-WmiObject -Class Win32_Printer ----------" -verbose
$RedirectedFolders = Get-WmiObject -Class Win32_Printer | select -Property Name,Sharename,Printerstate,Printerstatus,Location
$RedirectedFolders

write-verbose -message "$(Get-TimeStamp) ---------- Alt-Drucker entfernen ----------" -verbose
$PRN = "*SVAPRINT03*"

foreach ($d in $RedirectedFolders)
{
    if ($d.Name -like $PRN)
    { 
           $druckersharename = $d.Sharename 
        write-verbose -message "$(Get-TimeStamp) ---------- Alt-Drucker \\SVAPRINT01\$druckersharename entfernen - falls vorhanden ----------" -verbose
           $altdrucker= Remove-Printer -Name "\\SVAPRINT01\$druckersharename" -ErrorAction SilentlyContinue                
    }
  
  }

    write-verbose -message "$(Get-TimeStamp) ---------- Alt-Drucker \\svaeqtpr01\FollowYou_1 entfernen (falls vorhanden) ----------" -verbose
        #Get-ItemProperty Registry::\HKEY_Current_User\Printers\Connections\* 
        Remove-Printer -name "\\SVAEQTPR01\FollowYou_1" -ErrorAction SilentlyContinue
            $Key = "HKCU:Printers\Connections\"
            $Printertoremove = ',,SVAEQTPR01,FollowYou_1'
            
            If(!(Test-RegistryPath -Path $Key\$Printertoremove)) {
            "nicht vorhanden"
            } else {
            "vorhanden"
            Remove-item -path $Key\$Printertoremove -Force
            }

        write-verbose -message "$(Get-TimeStamp) ---------- Alt-Drucker \\svaeqtpr02\FollowYou_2 entfernen (falls vorhanden) ----------" -verbose
            Remove-Printer -name "\\svaeqtpr02\FollowYou_2" -ErrorAction SilentlyContinue                    
            $Key = "HKCU:Printers\Connections\"
            $Printertoremove = ',,SVAEQTPR02,FollowYou_2'

            If(!(Test-RegistryPath -Path $Key\$Printertoremove)) {
            "nicht vorhanden"
            } else {
            "vorhanden"
            Remove-item -path $Key\$Printertoremove -Force
            }

                  #Kyocera Standort Datei löschen
                $TPath= test-path "\\bg10\private\homes\$env:Username\Standort.txt"
                if($TPath){
                   Remove-Item "\\bg10\private\homes\$env:Username\Standort.txt"
                }

#################################################################################################################################################


write-verbose -message "$(Get-TimeStamp) ---------- CTX-PRN-Gruppen - Analyse Drucker Printer ----------" -verbose
    Get-ADPrincipalGroupMembership $env:USERNAME|Where-Object -FilterScript  {$_.name -like 'CTX-PRN-*'} | Sort-Object -Property Name| Format-table Name, distinguishedName

write-verbose -message "$(Get-TimeStamp) ---------- Get-Printer ----------" -verbose
    Get-Printer | Format-List Name,Computername,DriverName,Type,Portname,published,shared

write-verbose -message "$(Get-TimeStamp) ---------- Printer aus Registry ----------" -verbose
    Get-ChildItem Registry::\HKEY_Current_User\Printers\Connections -Recurse | Select-Object -ExpandProperty Name

write-verbose -message "$(Get-TimeStamp) -----------------ENDE-----------------------------------------------" -verbose

Stop-Transcript
