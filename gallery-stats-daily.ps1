$datename = get-date -Format dd.MM.yyyy
$filepath="c:\Windows\gallery-stats-$datename.log"
Start-Transcript -Path $filepath


$AvailableModules=find-module -repository psgallery 
[datetime]$Date=(Get-Date).AddDays(-1)

foreach($m in $AvailableModules){
     
                 if($m.PublishedDate.Date -eq $Date.Date ){
                    write-verbose -Message "" -Verbose
                    write-verbose -Message "------------------------------------------------------------------------------" -Verbose
                    write-verbose -Message "Author: $($m.Author)" -Verbose
                    write-verbose -Message "ModuleName: $($m.Name)" -Verbose
                    #write-verbose -Message "Description: $($m.Description)" -Verbose
                    #write-verbose -Message "AdditionalMetadata: " -Verbose
                    $m.AdditionalMetadata
                    #write-verbose -Message "PublishedDate: $($m.PublishedDate.DateTime)" -Verbose                    
                    write-verbose -Message "Functions:"  -Verbose
                    $($m.Includes.Function)                    
                    if($m.ProjectUri){write-verbose -Message "ProjectUri"  -Verbose
                    $m.ProjectUri.AbsoluteUri}
                    write-verbose -Message "------------------------------------------------------------------------------" -Verbose
                    write-verbose -Message "" -Verbose                    
                  }    
                 }

stop-Transcript

#    Send-MailMessage -From "Powershell-Gallery-Stats@bgetem.de" -To test@test.com -Subject "Gallery-Stats $($datename)" -Body "Yeah" -SmtpServer "SmtpServer" -Attachments $filepath

